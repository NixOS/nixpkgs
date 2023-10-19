{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.errbot;
  pluginEnv = plugins: pkgs.buildEnv {
    name = "errbot-plugins";
    paths = plugins;
  };
  mkConfigDir = instanceCfg: dataDir: pkgs.writeTextDir "config.py" ''
    import logging
    BACKEND = '${instanceCfg.backend}'
    BOT_DATA_DIR = '${dataDir}'
    BOT_EXTRA_PLUGIN_DIR = '${pluginEnv instanceCfg.plugins}'

    BOT_LOG_LEVEL = logging.${instanceCfg.logLevel}
    BOT_LOG_FILE = False

    BOT_ADMINS = (${concatMapStringsSep "," (name: "'${name}'") instanceCfg.admins})

    BOT_IDENTITY = ${builtins.toJSON instanceCfg.identity}

    ${instanceCfg.extraConfig}
  '';
in {
  options = {
    services.errbot.instances = mkOption {
      default = {};
      description = lib.mdDoc "Errbot instance configs";
      type = types.attrsOf (types.submodule {
        options = {
          dataDir = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = lib.mdDoc "Data directory for errbot instance.";
          };

          plugins = mkOption {
            type = types.listOf types.package;
            default = [];
            description = lib.mdDoc "List of errbot plugin derivations.";
          };

          logLevel = mkOption {
            type = types.str;
            default = "INFO";
            description = lib.mdDoc "Errbot log level";
          };

          admins = mkOption {
            type = types.listOf types.str;
            default = [];
            description = lib.mdDoc "List of identifiers of errbot admins.";
          };

          backend = mkOption {
            type = types.str;
            default = "XMPP";
            description = lib.mdDoc "Errbot backend name.";
          };

          identity = mkOption {
            type = types.attrs;
            description = lib.mdDoc "Errbot identity configuration";
          };

          extraConfig = mkOption {
            type = types.lines;
            default = "";
            description = lib.mdDoc "String to be appended to the config verbatim";
          };
        };
      });
    };
  };

  config = mkIf (cfg.instances != {}) {
    users.users.errbot = {
      group = "errbot";
      isSystemUser = true;
    };
    users.groups.errbot = {};

    systemd.services = mapAttrs' (name: instanceCfg: nameValuePair "errbot-${name}" (
    let
      dataDir = if instanceCfg.dataDir != null then instanceCfg.dataDir else
        "/var/lib/errbot/${name}";
    in {
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${dataDir}
        chown -R errbot:errbot ${dataDir}
      '';
      serviceConfig = {
        User = "errbot";
        Restart = "on-failure";
        ExecStart = "${pkgs.errbot}/bin/errbot -c ${mkConfigDir instanceCfg dataDir}/config.py";
        PermissionsStartOnly = true;
      };
    })) cfg.instances;
  };
}
