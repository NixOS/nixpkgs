{ pkgs, lib, stdenv, substituteAll, coreutils, bash, raspberrypifw, version
, ubootEnabled ? false }:

let
  uboot =
    if version == 0 then
      pkgs.ubootRaspberryPiZero
    else if version == 1 then
      pkgs.ubootRaspberryPi
    else if version == 2 then
      pkgs.ubootRaspberryPi2
    else if version == 3 then
      if stdenv.hostPlatform.isAarch64 then
        pkgs.ubootRaspberryPi3_64bit
      else
        pkgs.ubootRaspberryPi3_32bit
    else
      throw "U-Boot is not yet supported on the Raspberry Pi 4.";
in
substituteAll {
  src = ./firmware-builder.sh;
  isExecutable = true;
  path = lib.makeBinPath [ coreutils ];
  inherit bash raspberrypifw;
  uboot = lib.optionalString ubootEnabled uboot;
}

