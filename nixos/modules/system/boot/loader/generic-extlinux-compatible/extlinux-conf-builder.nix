{ pkgs }:

pkgs.substituteAll {
  src = ./extlinux-conf-builder.sh;
  isExecutable = true;
  path = with pkgs.buildPackages;
    [ coreutils gnused gnugrep ];
  inherit (pkgs.buildPackages) bash;
}
