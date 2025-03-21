{
  fetchFromGitHub,
  lib,
  pkgs,
  system ? builtins.currentSystem,
}:
let
  src = fetchFromGitHub {
    owner = "gchq";
    repo = "nix-bootstrap";
    tag = "2.0.1.2";
    hash = "sha256-1GBXa1fVLQ15LF0XyQ/SJw3JMwcnzuaSM21RwgtzTSk=";
  };
  inherit (import "${src}/nix/haskell-env.nix" { nixpkgs = pkgs; }) baseHaskellPackages;
in
(import "${src}/nix/release.nix" {
  inherit baseHaskellPackages;
  nixpkgs = pkgs;
}).nix-bootstrap.overrideAttrs
  (
    _: _: {
      meta = {
        description = "Generates nix-based devShells/builds for common project types";
        homepage = "https://github.com/gchq/nix-bootstrap/blob/2.0.1.2/README.md";
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [ sd234678 ];
        mainProgram = "nix-bootstrap";
        platforms = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      };
    }
  )
