{ pkgs }:

pkgs.substituteAll {
  src = ./extlinux-conf-builder.sh;
  isExecutable = true;
  path = [pkgs.buildPackages.coreutils pkgs.buildPackages.gnused pkgs.buildPackages.gnugrep];
  inherit (pkgs.buildPackages) bash;
}
