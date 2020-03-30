{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}: {
  fpm = import ./fpm.nix { inherit system pkgs; };
}
