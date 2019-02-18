{ system ? builtins.currentSystem
, pkgs ? import ../../.. { inherit system; }
}:
{
  mit = import ./mit.nix { inherit system pkgs; };
  heimdal = import ./heimdal.nix { inherit system pkgs; };
}
