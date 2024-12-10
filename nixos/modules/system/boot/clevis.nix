{ config, lib, pkgs, ... }:
let
  cfg = config.boot.initrd.clevis;
  systemd = config.boot.initrd.systemd;
  supportedFs = [ "zfs" "bcachefs" ];
in
{
  meta.maintainers = with lib.maintainers; [ julienmalka camillemndn ];
  meta.doc = ./clevis.md;

  options = {
    boot.initrd.clevis.enable = lib.mkEnableOption "Clevis in initrd";


    boot.initrd.clevis.package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.clevis;
      defaultText = "pkgs.clevis";
      description = "Clevis package";
    };

    boot.initrd.clevis.devices = lib.mkOption {
      description = "Encrypted devices that need to be unlocked at boot using Clevis";
      default = { };
      type = lib.types.attrsOf (lib.types.submodule ({
        options.secretFile = lib.mkOption {
          description = "Clevis JWE file used to decrypt the device at boot, in concert with the chosen pin (one of TPM2, Tang server, or SSS).";
          type = lib.types.path;
        };
      }));
    };

    boot.initrd.clevis.useTang = lib.mkOption {
      description = "Whether the Clevis JWE file used to decrypt the devices uses a Tang server as a pin.";
      default = false;
      type = lib.types.bool;
    };

  };

  config = lib.mkIf cfg.enable {

    # Implementation of clevis unlocking for the supported filesystems are located directly in the respective modules.


    assertions = (lib.attrValues (lib.mapAttrs
      (device: _: {
        assertion = (lib.any (fs: fs.device == device && (lib.elem fs.fsType supportedFs) || (fs.fsType == "zfs" && lib.hasPrefix "${device}/" fs.device)) config.system.build.fileSystems) || (lib.hasAttr device config.boot.initrd.luks.devices);
        message = ''
          No filesystem or LUKS device with the name ${device} is declared in your configuration.'';
      })
      cfg.devices));


    warnings =
      if cfg.useTang && !config.boot.initrd.network.enable && !config.boot.initrd.systemd.network.enable
      then [ "In order to use a Tang pinned secret you must configure networking in initrd" ]
      else [ ];

    boot.initrd = {
      extraUtilsCommands = lib.mkIf (!systemd.enable) ''
        copy_bin_and_libs ${pkgs.jose}/bin/jose
        copy_bin_and_libs ${pkgs.curl}/bin/curl
        copy_bin_and_libs ${pkgs.bash}/bin/bash

        copy_bin_and_libs ${pkgs.tpm2-tools}/bin/.tpm2-wrapped
        mv $out/bin/{.tpm2-wrapped,tpm2}
        cp {${pkgs.tpm2-tss},$out}/lib/libtss2-tcti-device.so.0

        copy_bin_and_libs ${cfg.package}/bin/.clevis-wrapped
        mv $out/bin/{.clevis-wrapped,clevis}

        for BIN in ${cfg.package}/bin/clevis-decrypt*; do
          copy_bin_and_libs $BIN
        done

        for BIN in $out/bin/clevis{,-decrypt{,-null,-tang,-tpm2}}; do
          sed -i $BIN -e 's,${pkgs.bash},,' -e 's,${pkgs.coreutils},,'
        done

        sed -i $out/bin/clevis-decrypt-tpm2 -e 's,tpm2_,tpm2 ,'
      '';

      secrets = lib.mapAttrs' (name: value: lib.nameValuePair "/etc/clevis/${name}.jwe" value.secretFile) cfg.devices;

      systemd = {
        extraBin = lib.mkIf systemd.enable {
          clevis = "${cfg.package}/bin/clevis";
          curl = "${pkgs.curl}/bin/curl";
        };

        storePaths = lib.mkIf systemd.enable [
          cfg.package
          "${pkgs.jose}/bin/jose"
          "${pkgs.curl}/bin/curl"
          "${pkgs.tpm2-tools}/bin/tpm2_createprimary"
          "${pkgs.tpm2-tools}/bin/tpm2_flushcontext"
          "${pkgs.tpm2-tools}/bin/tpm2_load"
          "${pkgs.tpm2-tools}/bin/tpm2_unseal"
        ];
      };
    };
  };
}
