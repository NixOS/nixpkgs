{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

{
  basic = import ./basic.nix { inherit system pkgs; };
  provision-dashboards = import ./provision-dashboards { inherit system pkgs; };
}
