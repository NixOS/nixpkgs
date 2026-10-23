{
  pkgs ? import ../../../../../.. { },
}:

# Ideally, pkgs points to default.nix file of Nixpkgs official tree
with pkgs;

mkShell {
  inputsFrom = [
    (import ../../update-shell.nix { inherit pkgs; })
  ];
  packages = [
    nix-prefetch-github
    nurl
    prefetch-npm-deps
  ];
}
