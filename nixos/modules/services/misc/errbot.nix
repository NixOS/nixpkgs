{ config, lib, pkgs, ... }:

with lib;

# FIXME multiple instances

let
  cfg = config.services.errbot;
  pluginEnv = pkgs.buildEnv {
    name = "errbot-plugins";
    paths = cfg.plugins;
  };
  configFile = pkgs.writeText "errbot-config.py" ''
    import logging
    BACKEND = '${cfg.backend}'
    BOT_DATA_DIR = '${cfg.dataDir}'
    BOT_EXTRA_PLUGIN_DIR = '${pluginEnv}'

    BOT_LOG_LEVEL = logging.${cfg.logLevel}
    BOT_LOG_FILE = False

    BOT_ADMINS = (${concatStringsSep "," (map (name: "'${name}'") cfg.admins)})

    BOT_IDENTITY = ${cfg.identity}

    ${cfg.extraConfig}
  '';
in {
  options = {
    services.errbot = {
      enable = mkEnableOption "errbot";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/errbot/data";
        description = "Gitlab state directory, logs are stored here.";
      };

      plugins = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Gitlab path for backups.";
      };

      logLevel = mkOption {
        type = types.str;
        default = "DEBUG";
        description = "Gitlab database hostname.";
      };

      admins = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Gitlab database user password.";
      };

      backend = mkOption {
        type = types.str;
        default = "XMPP";
        description = "Gitlab database name.";
      };

      identity = mkOption {
        type = types.str;
        default = "{}";
        description = "Gitlab database user.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "extraConfig";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers.errbot.group = "errbot";
    users.extraGroups.errbot = {};

    systemd.services.errbot = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.dataDir}
        chown -R errbot:errbot ${cfg.dataDir}
      '';
      serviceConfig = {
        Type = "simple";
        User = "errbot";
        Group = "errbot";
        Restart = "on-failure";
        ExecStart="${pkgs.errbot}/bin/errbot -c ${configFile}";
        PermissionsStartOnly = true;
      };
    };
  };
}
