{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

{
  prometheus-pair = import ./prometheus-pair.nix { inherit system pkgs; };
}
