{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../../.. { inherit system config; }
, php ? pkgs.php
}: {
  fpm = import ./fpm.nix { inherit system pkgs php; };
  httpd = import ./httpd.nix { inherit system pkgs php; };
  pcre = import ./pcre.nix { inherit system pkgs php; };
}
