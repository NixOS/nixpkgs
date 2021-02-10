{ pkgs, config, lib }:

let
  # TODO: allow user to extend this maybe?
  # but for now we use the config.txt directly from the rpi4_uefi release
  configTxt = ''
  '';

  grubBootBuilder =
    (import ../systemd-boot/gummiboot-builder.nix {
      pkgs = pkgs.buildPackages;
      inherit config lib;
    });

  rpi4uefi = pkgs.callPackage (
    { stdenv, runCommandNoCC, unzip }:
    let
      version = "v1.22";
      sha256 = "0yklg00fmg82rg1plyz6wc3kdgss9xp85ilhmc61p6jgvn0s138q";
      src = builtins.fetchurl {
        url = "https://github.com/pftf/RPi4/releases/download/${version}/RPi4_UEFI_Firmware_${version}.zip";
        inherit sha256;
      };
    in
      runCommandNoCC "rpi4-uefi-fw-${version}" {} ''
        mkdir -p $out/
        echo ${unzip}/bin/unzip "${src}" -d $out/
        ${unzip}/bin/unzip "${src}" -d $out/
      ''
  ) {};

  nextStage = grubBootBuilder;
in
pkgs.substituteAll {
  src = ./rpi4uefi-builder.sh;
  isExecutable = true;
  inherit (pkgs) bash;
  path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  rpi4uefi = rpi4-uefi;
  systemdBootBuilder = "${systemdBootBuilder}";
  grubBootBuilder = "${grubBootBuilder}";
  efiSysMountPoint = config.boot.loader.efi.efiSysMountPoint;
  inherit configTxt;
}
