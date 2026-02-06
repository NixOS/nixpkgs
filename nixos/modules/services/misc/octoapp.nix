{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.octoapp;
  pkg = cfg.package;

  moonrakerCfg = config.services.moonraker;
  moonrakerStateDir = moonrakerCfg.stateDir;
  configDir = "${moonrakerStateDir}/config";
  logDir = "${moonrakerStateDir}/logs";

  jsonConfig = builtins.toJSON {
    ConfigFolder = configDir;
    LogFolder = logDir;
    LocalFileStoragePath = "/var/lib/octoapp";
    ServiceName = "octoapp";
    VirtualEnvPath = "/var/lib/octoapp/venv";
    RepoRootFolder = "${pkg}/lib/octoapp";
    IsCompanion = false;
    MoonrakerConfigFile = "${configDir}/moonraker-temp.cfg";
  };
in
{
  options.services.octoapp = {
    enable = lib.mkEnableOption "OctoApp, a companion service for Moonraker providing push notifications and remote monitoring via the OctoApp mobile app";

    package = lib.mkPackageOption pkgs "octoapp" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = moonrakerCfg.user;
      defaultText = lib.literalExpression "config.services.moonraker.user";
      description = "User account under which OctoApp runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = moonrakerCfg.group;
      defaultText = lib.literalExpression "config.services.moonraker.group";
      description = "Group account under which OctoApp runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.moonraker.enable;
        message = "services.octoapp requires Moonraker to be enabled (services.moonraker.enable).";
      }
    ];

    systemd.services.octoapp = {
      description = "OctoApp Companion for Moonraker";
      after = [
        "network-online.target"
        "moonraker.service"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "${pkg}/lib/octoapp";
        ExecStart = pkgs.writeShellScript "start-octoapp" ''
          CONFIG_B64=$(echo -n '${jsonConfig}' | ${pkgs.coreutils}/bin/base64 -w0)
          exec ${pkg}/bin/octoapp "$CONFIG_B64"
        '';
        Restart = "always";
        RestartSec = 10;
        StateDirectory = "octoapp";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ imadnyc ];
}
