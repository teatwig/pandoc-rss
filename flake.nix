{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.default = pkgs.stdenvNoCC.mkDerivation {
        name = "pandoc-rss";

        src = ./.;
        makeFlags = [ "PREFIX=$(out)" ];

        inputs = with pkgs; [ coreutils ];

        postInstall = ''
          substituteInPlace $out/bin/pandoc-rss --replace /usr/bin/date date
        '';
      };
    }
  );
}
