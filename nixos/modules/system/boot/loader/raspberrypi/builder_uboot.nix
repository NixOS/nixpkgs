{ config, pkgs, configTxt }:

let
  cfg = config.boot.loader.raspberryPi;
  isAarch64 = pkgs.stdenv.isAarch64;

  uboot =
    if cfg.version == 1 then
      pkgs.ubootRaspberryPi
    else if cfg.version == 2 then
      pkgs.ubootRaspberryPi2
    else
      if isAarch64 then
        pkgs.ubootRaspberryPi3_64bit
      else
        pkgs.ubootRaspberryPi3_32bit;

  extlinuxConfBuilder =
    import ../generic-extlinux-compatible/extlinux-conf-builder.nix {
      inherit pkgs;
    };
in
pkgs.substituteAll {
  src = ./builder_uboot.sh;
  isExecutable = true;
  inherit (pkgs) bash;
  path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  firmware = pkgs.raspberrypifw;
  inherit uboot;
  inherit configTxt;
  inherit extlinuxConfBuilder;
  version = cfg.version;
}

