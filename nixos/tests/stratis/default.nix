{ system ? builtins.currentSystem
, pkgs ? import ../../.. { inherit system; }
}:

{
  simple = import ./simple.nix { inherit system pkgs; };
  encryption = import ./encryption.nix { inherit system pkgs; };
}
