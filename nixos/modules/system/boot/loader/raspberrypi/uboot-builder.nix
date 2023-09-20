{ pkgs, version, configTxt }:

let
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;

  uboot =
    if version == 0 then
      pkgs.ubootRaspberryPiZero
    else if version == 1 then
      pkgs.ubootRaspberryPi
    else if version == 2 then
      pkgs.ubootRaspberryPi2
    else if version == 3 then
      if isAarch64 then
        pkgs.ubootRaspberryPi3_64bit
      else
        pkgs.ubootRaspberryPi3_32bit
    else
      throw "U-Boot is not yet supported on the raspberry pi 4.";

  extlinuxConfBuilder =
    import ../generic-extlinux-compatible/extlinux-conf-builder.nix {
      pkgs = pkgs.buildPackages;
    };
in
pkgs.substituteAll {
  src = ./uboot-builder.sh;
  isExecutable = true;
  inherit (pkgs) bash;
  path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  firmware = pkgs.raspberrypifw;
  inherit uboot;
  inherit configTxt;
  inherit extlinuxConfBuilder;
  inherit version;
}

