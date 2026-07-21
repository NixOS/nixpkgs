{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib.options) mkEnableOption mkPackageOption mkOption;
  inherit (lib.modules) mkMerge mkIf;
  inherit (lib.lists) flatten filter imap0;
  inherit (lib.attrsets)
    recursiveUpdate
    mapAttrsToList
    listToAttrs
    nameValuePair
    ;
  inherit (lib.strings) concatStringsSep;
  inherit (lib) types;

  cfg = config.services.rauc;
  format = pkgs.formats.ini { };

  mountDir = "${cfg.dataDir}/mnt";

  mkSlot =
    slot:
    if slot.enable then
      slot.settings
      // {
        inherit (slot) device type;
      }
    else
      null;

  slotSections = listToAttrs (
    filter (slot: slot != null) (
      flatten (
        mapAttrsToList (
          name: indexes: imap0 (idx: slot: nameValuePair "slot.${name}.${toString idx}" (mkSlot slot)) indexes
        ) cfg.slots
      )
    )
  );

  configFile = format.generate "rauc.conf" (
    recursiveUpdate cfg.settings (
      recursiveUpdate {
        system = {
          inherit (cfg) compatible bootloader;
          bundle-formats = concatStringsSep " " cfg.bundleFormats;
          data-directory = cfg.dataDir;
          mountprefix = mountDir;
        };
      } slotSections
    )
  );
in
{
  options = {
    services.rauc = {
      enable = mkEnableOption "RAUC A/B update service";
      mark-good.enable = mkEnableOption "RAUC Good-marking service";
      client.enable = mkEnableOption "RAUC client in the system environment";
      package = mkPackageOption pkgs "rauc" { };
      compatible = mkOption {
        description = "The compatibility string for this system. Can be any format so long as you are consistent.";
        type = types.str;
        example = "nix/appliance/foo";
      };
      bootloader = mkOption {
        description = "The bootloader backend for RAUC.";
        type = types.enum [
          "barebox"
          "grub"
          "uboot"
          "efi"
          "custom"
          "noop"
        ];
        example = "grub";
      };
      bundleFormats = mkOption {
        description = "Allowable formats for the RAUC bundle.";
        type = with types; listOf str;
        default = [
          "-plain"
          "+verity"
        ];
        example = [
          "-plain"
          "+verity"
        ];
      };
      dataDir = mkOption {
        description = "The state directory for RAUC.";
        default = "/var/lib/rauc";
        type = types.path;
      };
      slots = mkOption {
        description = "RAUC slot definitions. Every key is a slot class and every value is a list of slot indexes.";
        default = { };
        type = types.attrsOf (
          types.listOf (
            types.submodule {
              options = {
                enable = mkEnableOption "this RAUC slot";
                device = mkOption {
                  description = "The device to update.";
                  type = types.str;
                };
                type = mkOption {
                  description = "The type of the device.";
                  type = types.enum [
                    "raw"
                    "nand"
                    "nor"
                    "ubivol"
                    "ubifs"
                    "ext4"
                    "vfat"
                  ];
                  default = "raw";
                };
                settings = mkOption {
                  description = "Settings for this slot.";
                  type = types.attrs;
                  default = { };
                };
              };
            }
          )
        );
      };
      settings = mkOption {
        type = format.type;
        default = { };
        description = ''
          Rauc configuration that will be converted to INI. Refer to:
          <https://rauc.readthedocs.io/en/latest/reference.html#sec-ref-slot-config>
          for details on supported values.

          All module-specific options override these.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      systemd.services.rauc = {
        description = "RAUC Update Service";
        documentation = [ "https://rauc.readthedocs.io" ];
        wants = [ "basic.target" ];
        wantedBy = [ "multi-user.target" ];
        after = [
          "dbus.service"
        ];
        serviceConfig = {
          Type = "dbus";
          BusName = "de.pengutronix.rauc";
          ExecStart = "${lib.getExe cfg.package} --conf=${configFile} --mount=/run/rauc/mnt service";
          RuntimeDirectory = "rauc/mnt";
          MountFlags = "slave";
          StateDirectory = baseNameOf cfg.dataDir;
          WorkingDirectory = cfg.dataDir;
        };
      };
      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir} 0750 root root - -"
        "d ${mountDir} 0750 root root - -"
      ];
    })
    (mkIf (cfg.enable && cfg.client.enable) {
      services.dbus.packages = [ cfg.package ];
      environment.systemPackages = [ cfg.package ];
    })
    (mkIf (cfg.enable && cfg.mark-good.enable) {
      systemd.services.rauc-mark-good = {
        description = "RAUC Good-marking service";
        documentation = [ "https://rauc.readthedocs.io" ];
        wantedBy = [ "multi-user.target" ];
        after = [
          "rauc.service"
          "multi-user.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe cfg.package} --conf=${configFile} status mark-good";
        };
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [ numinit ];
}
