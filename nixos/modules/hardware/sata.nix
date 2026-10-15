{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.hardware.sata.timeout;

  buildRule =
    d:
    lib.concatStringsSep ", " [
      ''ACTION=="add"''
      ''SUBSYSTEM=="block"''
      ''ENV{ID_${lib.toUpper d.idBy}}=="${d.name}"''
      ''TAG+="systemd"''
      ''ENV{SYSTEMD_WANTS}="${unitName d}"''
    ];

  devicePath = device: "/dev/disk/by-${device.idBy}/${device.name}";

  unitName = device: "sata-timeout-${lib.strings.sanitizeDerivationName device.name}";

  startScript = pkgs.writeShellScript "sata-timeout.sh" ''
    set -eEuo pipefail

    device="$1"

    ${pkgs.smartmontools}/bin/smartctl \
      -l scterc,${toString cfg.deciSeconds},${toString cfg.deciSeconds} \
      --quietmode errorsonly \
      "$device"
  '';

in
{
  meta.maintainers = with lib.maintainers; [ peterhoeg ];

  options.hardware.sata.timeout = {
    enable = mkEnableOption "SATA drive timeouts";

    deciSeconds = mkOption {
      example = 70;
      type = types.int;
      description = ''
        Set SCT Error Recovery Control timeout in deciseconds for use in RAID configurations.

        Values are as follows:
           0 = disable SCT ERT
          70 = default in consumer drives (7 seconds)

        Maximum is disk dependant but probably 60 seconds.
      '';
    };

    drives = mkOption {
      description = "List of drives for which to configure the timeout.";
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              description = "Drive name without the full path.";
              type = types.str;
            };

            idBy = mkOption {
              description = "The method to identify the drive.";
              type = types.enum [
                "path"
                "wwn"
              ];
              default = "path";
            };
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    services.udev.extraRules = lib.concatMapStringsSep "\n" buildRule cfg.drives;

    systemd.services = lib.listToAttrs (
      map (
        e:
        lib.nameValuePair (unitName e) {
          description = "SATA timeout for ${e.name}";
          wantedBy = [ "sata-timeout.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${startScript} '${devicePath e}'";
            PrivateTmp = true;
            PrivateNetwork = true;
            ProtectHome = "tmpfs";
            ProtectSystem = "strict";
          };
        }
      ) cfg.drives
    );

    systemd.targets.sata-timeout = {
      description = "SATA timeout";
      wantedBy = [ "multi-user.target" ];
    };
  };
}
