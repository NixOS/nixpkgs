{ nixpkgs ? import ../.. { }
}:
with nixpkgs;
mkShell {
  buildInputs = [
    haskellPackages.cabal2nix
  ];
  NIXPKGS_ROOT = toString ../..;
}
