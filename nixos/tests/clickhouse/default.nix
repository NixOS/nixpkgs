{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  base = import ./base.nix { inherit system pkgs; };
  kafka = import ./kafka.nix { inherit system pkgs; };
}
