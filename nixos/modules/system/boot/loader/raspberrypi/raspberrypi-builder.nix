{ pkgs, configTxt, firmware ? pkgs.raspberrypifw }:

pkgs.substituteAll {
  src = ./raspberrypi-builder.sh;
  isExecutable = true;
  inherit (pkgs) bash;
  path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  inherit firmware configTxt;
}
