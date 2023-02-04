{ nixpkgs ? import ../.. { }
}:
with nixpkgs;
let
  pyEnv = python3.withPackages(ps: [ ps.gitpython ]);
in
mkShell {
  packages = [
    pyEnv
    luarocks-nix
    nix-prefetch-scripts
  ];
}
