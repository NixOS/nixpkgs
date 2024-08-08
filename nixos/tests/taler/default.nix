{
  system ? builtins.currentSystem,
  pkgs ? import ../../.. { inherit system; },
}:
{
  basic = import ./basic.nix { inherit system pkgs; };
}
