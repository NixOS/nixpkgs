{ pkgs }:

pkgs.substituteAll {
  src = ./extlinux-conf-builder.sh;
  isExecutable = true;
  path = [
    pkgs.coreutils
    pkgs.gnused
    pkgs.gnugrep
  ];
  inherit (pkgs) bash;
}
