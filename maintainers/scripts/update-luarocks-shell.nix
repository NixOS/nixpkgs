{ nixpkgs ? import ../.. { }
}:
with nixpkgs;
mkShell {
  buildInputs = [
    bash luarocks-nix nix-prefetch-scripts parallel
  ];
  LUAROCKS_NIXPKGS_PATH = toString nixpkgs.path;
}
