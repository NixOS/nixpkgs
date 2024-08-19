{
  description = "Testing calamares-nixos-extensions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      packages = [
        (pkgs.python3.withPackages (pp: with pp; [ pytest pytest-mock ]))
      ];
    in
    {
      packages.${system}.default = pkgs.writeShellApplication {
        name = "test-nixos-install";
        runtimeInputs = packages;
        text = ''
          #!${pkgs.stdenv.shell}
          pytest -vv testing
        '';
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit packages;
      };
    };
}
