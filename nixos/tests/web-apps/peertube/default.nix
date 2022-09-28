{ system ? builtins.currentSystem
, pkgs ? import ../../../.. { inherit system; }
}:
{
  base = import ./base.nix { inherit system pkgs; };
  plugins = import ./plugins.nix { inherit system pkgs; };
}
