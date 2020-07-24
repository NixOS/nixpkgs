{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}: {
  fpm = import ./fpm.nix { inherit system pkgs; };
  httpd = import ./httpd.nix { inherit system pkgs; };
  pcre = import ./pcre.nix { inherit system pkgs; };
}
