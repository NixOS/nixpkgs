{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  base = import ./base.nix { inherit system pkgs; };
  cluster = import ./cluster.nix { inherit system pkgs; };
}
