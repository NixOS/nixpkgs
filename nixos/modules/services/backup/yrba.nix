{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.yrba;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "yrba.toml" cfg.extraConfig;
in
{
  meta.maintainers = with lib.maintainers; [
    lilith-roth
  ];

  options.services.yrba = {
    enable = lib.mkEnableOption "Incremental remote backups made easy!";

    package = lib.mkPackageOption pkgs "yrba" { };

    schedule = {
      enable = lib.mkEnableOption "Periodic backups with YRBA";

      dates = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "weekly";
        description = ''
          How often backups are created and uploaded/copied. Passed to systemd.time

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };
    };

    extraConfig = lib.mkOption {
      default = { };
      description = "Extra configuration options for telegraf";
      type = settingsFormat.type;
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.schedule.enable -> cfg.enable;
        message = "programs.yrba.schedule.enable requires programs.yrba.enable";
      }
    ];

    environment = lib.mkIf cfg.enable {
      systemPackages = [ cfg.package ];
    };

    systemd = {
      services.yrba = {
        description = "Automatic incremental remote backups using YRBA";
        startAt = cfg.schedule.dates;
        path = [ config.nix.package ];
        wants = [ "network-online.target" "remote-fs.target" "nss-lookup.target" ];
        after = [ "network-online.target" "remote-fs.target" "nss-lookup.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe cfg.package} -c /etc/yrba.toml";
          ExecStartPre = (
            pkgs.writeShellScript "pre-start" ''
              umask 077
              ${pkgs.envsubst}/bin/envsubst -i "${configFile}" > /etc/yrba.toml
            ''
          );
        };
      };
      timers.yrba = {
        timerConfig = {
          Persistent = true;
        };
      };
    };
  };
}
