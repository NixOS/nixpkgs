{ pkgs, configTxt }:

pkgs.substituteAll {
  src = ./raspberrypi-builder.sh;
  isExecutable = true;
  inherit (pkgs) bash;
  path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  firmware = pkgs.raspberrypifw;
  inherit configTxt;
}
