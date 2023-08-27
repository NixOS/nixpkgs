{config, lib, pkgs, ...}:

with lib;

let
  cfg = config.boot.initrd.clevis;
  zfsKeyScript = ''
  filesystem=$1

  # check for zfs property latchset.clevis:decrypt = "yes"
  zfs get -rH latchset.clevis:decrypt $filesystem | awk '{exit $3 != "yes"}' || { echo "Clevis decryption not enabled";  exit 1; }

  # then load jwe from latchset.clevis:jwe, decrypt and pass to zfs load-keys
  zfs get -rH latchset.clevis:jwe $filesystem | awk '{print $3}' | clevis decrypt | zfs load-key $filesystem
  '';
in
{
  imports = [];

  options = {
    boot.initrd.clevis.enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Enable automatic unlocking of ZFS datasets using native encryption,
        with a password secured by clevis.
      '';
    };

    boot.initrd.clevis.package = mkOption {
      type = types.package;
      defaultText = "pkgs.clevis";
      description = lib.mdDoc ''
        Clevis package.
      '';
    };
  };

  config = mkIf (cfg.enable) {
    # TODO: assert systemd initrd
    boot.initrd.clevis.package = mkDefault pkgs.clevis;

    # Include clevis package in initrd
    boot.initrd.systemd.storePaths = [
      cfg.package
      "${pkgs.jose}/bin/jose"
      "${pkgs.tpm2-tools}/bin/tpm2_createprimary"
      "${pkgs.tpm2-tools}/bin/tpm2_flushcontext"
      "${pkgs.tpm2-tools}/bin/tpm2_load"
      "${pkgs.tpm2-tools}/bin/tpm2_unseal"
    ];
    boot.initrd.systemd.extraBin.clevis = "${cfg.package}/bin/clevis";

    boot.zfs.keyScripts = [zfsKeyScript];
  };
}
