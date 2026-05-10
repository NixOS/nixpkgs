{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption types;

  cfg = config.hardware.sensor.hddtemp;

  script = ''
    set -eEuo pipefail

    file=/var/lib/hddtemp/hddtemp.db

    raw_drives=""
    ${lib.concatStringsSep "\n" (map (drives: "raw_drives+=\"${drives} \"") cfg.drives)}
    drives=""
    for i in $raw_drives; do
      drives+=" $(realpath $i)"
    done

    cp ${pkgs.hddtemp}/share/hddtemp/hddtemp.db $file
    ${lib.concatMapStringsSep "\n" (e: "echo ${lib.escapeShellArg e} >> $file") cfg.dbEntries}

    ${pkgs.hddtemp}/bin/hddtemp ${lib.escapeShellArgs cfg.extraArgs} \
      --daemon \
      --unit=${cfg.unit} \
      --file=$file \
      $drives
  '';

in
{
  meta.maintainers = with lib.maintainers; [ peterhoeg ];

  ###### interface

  options = {
    hardware.sensor.hddtemp = {
      enable = mkOption {
        description = ''
          Enable this option to support HDD/SSD temperature sensors.
        '';
        type = types.bool;
        default = false;
      };

      drives = mkOption {
        description = "List of drives to monitor. If you pass /dev/disk/by-path/* entries the symlinks will be resolved as hddtemp doesn't like names with colons.";
        type = types.listOf types.str;
      };

      unit = mkOption {
        description = "Celsius or Fahrenheit";
        type = types.enum [
          "C"
          "F"
        ];
        default = "C";
      };

      dbEntries = mkOption {
        description = "Additional DB entries";
        type = types.listOf types.str;
        default = [ ];
      };

      extraArgs = mkOption {
        description = "Additional arguments passed to the daemon.";
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.hddtemp = {
      description = "HDD/SSD temperature";
      documentation = [ "man:hddtemp(8)" ];
      wantedBy = [ "multi-user.target" ];
      inherit script;
      serviceConfig = {
        Type = "forking";
        StateDirectory = "hddtemp";
        PrivateTmp = true;
        ProtectHome = "tmpfs";
        ProtectSystem = "strict";
      };
    };
  };
}
