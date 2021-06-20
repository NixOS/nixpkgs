{ nixpkgs ? import ../.. { }
}:
with nixpkgs;
mkShell {
  packages = [
    bash
    luarocks-nix
    nix-prefetch-scripts
    parallel
  ];
  LUAROCKS_NIXPKGS_PATH = toString nixpkgs.path;
}
