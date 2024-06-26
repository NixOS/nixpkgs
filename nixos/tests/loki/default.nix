{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

{
  standalone = import ./standalone.nix { inherit system pkgs; };
  ssd = import ./ssd.nix { inherit system pkgs; };
}
