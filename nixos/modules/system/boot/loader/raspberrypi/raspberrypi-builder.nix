{ pkgs, configTxt }:

pkgs.substituteAll {
  src = ./raspberrypi-builder.sh;
  isExecutable = true;
  postInstall = "shellcheck $out";
  nativeBuildInputs = [ pkgs.buildPackages.shellcheck ];

  inherit (pkgs.buildPackages) bash;
  path = with pkgs.buildPackages; [coreutils gnused gnugrep];
  firmware = pkgs.raspberrypifw;
  inherit configTxt;
}
