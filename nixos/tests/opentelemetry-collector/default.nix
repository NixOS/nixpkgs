{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

{
  with-settings = import ./with-settings.nix { inherit system pkgs; };
  with-config-file = import ./with-config-file.nix { inherit system pkgs; };
  with-config-files = import ./with-config-files.nix { inherit system pkgs; };
}
