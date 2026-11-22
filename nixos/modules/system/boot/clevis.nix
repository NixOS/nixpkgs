{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.initrd.clevis;
  supportedFs = [
    "zfs"
    "bcachefs"
  ];
in
{
  meta.maintainers = with lib.maintainers; [
    julienmalka
    camillemndn
  ];
  meta.doc = ./clevis.md;

  options = {
    boot.initrd.clevis.enable = lib.mkEnableOption "Clevis in initrd";

    boot.initrd.clevis.package = lib.mkPackageOption pkgs "clevis" { };

    boot.initrd.clevis.devices = lib.mkOption {
      description = "Encrypted devices that need to be unlocked at boot using Clevis";
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options.secretFile = lib.mkOption {
            description = "Clevis JWE file used to decrypt the device at boot, in concert with the chosen pin (one of TPM2, Tang server, or SSS).";
            type = lib.types.path;
          };
        }
      );
    };

    boot.initrd.clevis.useTang = lib.mkOption {
      description = "Whether the Clevis JWE file used to decrypt the devices uses a Tang server as a pin.";
      default = false;
      type = lib.types.bool;
    };

  };

  config = lib.mkIf cfg.enable {

    # Implementation of clevis unlocking for the supported filesystems are located directly in the respective modules.

    assertions = (
      lib.attrValues (
        lib.mapAttrs (device: _: {
          assertion =
            (lib.any (
              fs:
              fs.device == device && (lib.elem fs.fsType supportedFs)
              || (fs.fsType == "zfs" && lib.hasPrefix "${device}/" fs.device)
            ) config.system.build.fileSystems)
            || (lib.hasAttr device config.boot.initrd.luks.devices);
          message = "No filesystem or LUKS device with the name ${device} is declared in your configuration.";
        }) cfg.devices
      )
    );

    warnings =
      if
        cfg.useTang && !config.boot.initrd.network.enable && !config.boot.initrd.systemd.network.enable
      then
        [ "In order to use a Tang pinned secret you must configure networking in initrd" ]
      else
        [ ];

    boot.initrd = {
      secrets = lib.mapAttrs' (
        name: value: lib.nameValuePair "/etc/clevis/${name}.jwe" value.secretFile
      ) cfg.devices;

      systemd = {
        extraBin = {
          clevis = "${cfg.package}/bin/clevis";
          curl = "${pkgs.curl}/bin/curl";
        };

        storePaths = [
          cfg.package
          "${pkgs.jose}/bin/jose"
          "${pkgs.curl}/bin/curl"
          "${pkgs.cryptsetup}/bin/cryptsetup"
          "${pkgs.gnused}/bin/sed"
          "${pkgs.gnugrep}/bin/grep"
          "${pkgs.tpm2-tools}/bin/tpm2_createprimary"
          "${pkgs.tpm2-tools}/bin/tpm2_flushcontext"
          "${pkgs.tpm2-tools}/bin/tpm2_load"
          "${pkgs.tpm2-tools}/bin/tpm2_unseal"
        ];
      };
    };
  };
}
