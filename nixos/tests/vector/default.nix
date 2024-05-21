{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

{
  file-sink = import ./file-sink.nix { inherit system pkgs; };
  api = import ./api.nix { inherit system pkgs; };
}
