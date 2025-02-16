{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  basic = import ./basic.nix { inherit system pkgs; };
  provision = import ./provision { inherit system pkgs; };
}
