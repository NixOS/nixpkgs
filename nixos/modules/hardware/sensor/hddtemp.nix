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

    # Intentionally unquoted to allow shell expansion and evaluation.
    # shellcheck disable=SC2207
    raw_drives=( ${lib.concatStringsSep " " cfg.drives} )
    declare -a drives
    for i in "''${raw_drives[@]}"; do
      drives+=( "$(realpath "$i")" )
    done

    cp ${pkgs.hddtemp}/share/hddtemp/hddtemp.db $file
    ${lib.concatMapStringsSep "\n" (e: "echo ${lib.escapeShellArg e} >> $file") cfg.dbEntries}

    ${pkgs.hddtemp}/bin/hddtemp ${lib.escapeShellArgs cfg.extraArgs} \
      --daemon \
      --unit=${cfg.unit} \
      --file=$file \
      "''${drives[@]}"
  '';

in
{
  meta.maintainers = with lib.maintainers; [
    peterhoeg
    usovalx
  ];

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
        description = ''
          List of drives or shell expressions that expand to drives to monitor.
          Expressions are evaluated when the service starts, so shell wildcards
          and command substitutions can be used.
        '';
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
      enableStrictShellChecks = true;
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
