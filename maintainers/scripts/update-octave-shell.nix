{ nixpkgs ? import ../.. { }
}:
with nixpkgs;
let
  pyEnv = python3.withPackages(ps: with ps; [ packaging requests toolz pyyaml ]);
in
mkShell {
  packages = [
    pyEnv
    nix-prefetch-scripts
  ];
}
