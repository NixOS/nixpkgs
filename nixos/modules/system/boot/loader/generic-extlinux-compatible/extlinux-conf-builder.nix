{ pkgs }:

let
  builderPkgs = if (pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform) then pkgs else pkgs.buildPackages;
in pkgs.substituteAll {
  src = ./extlinux-conf-builder.sh;
  isExecutable = true;
  path = [builderPkgs.coreutils builderPkgs.gnused builderPkgs.gnugrep];
  inherit (builderPkgs) bash;
}
