{ pkgs, configTxt }:

pkgs.substituteAll {
  src = ./raspberrypi-builder.sh;
  isExecutable = true;

  checkPhase = "shellcheck $out";
  checkInputs = [ pkgs.buildPackages.shellcheck ];
  doCheck = false;

  inherit (pkgs.buildPackages) bash;
  path = with pkgs.buildPackages; [coreutils gnused gnugrep];
  firmware = pkgs.raspberrypifw;
  inherit configTxt;
}
