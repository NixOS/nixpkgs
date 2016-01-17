{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kibana;

  cfgFile = pkgs.writeText "kibana.json" (builtins.toJSON (
    (filterAttrsRecursive (n: v: v != null) ({
      server = {
        host = cfg.listenAddress;
        port = cfg.port;
        ssl = {
          cert = cfg.cert;
          key = cfg.key;
        };
      };

      kibana = {
        index = cfg.index;
        defaultAppId = cfg.defaultAppId;
      };

      elasticsearch = {
        url = cfg.elasticsearch.url;
        username = cfg.elasticsearch.username;
        password = cfg.elasticsearch.password;
        ssl = {
          cert = cfg.elasticsearch.cert;
          key = cfg.elasticsearch.key;
          ca = cfg.elasticsearch.ca;
        };
      };

      logging = {
        verbose = cfg.logLevel == "verbose";
        quiet = cfg.logLevel == "quiet";
        silent = cfg.logLevel == "silent";
        dest = "stdout";
      };
    } // cfg.extraConf)
  )));
in {
  options.services.kibana = {
    enable = mkEnableOption "enable kibana service";

    listenAddress = mkOption {
      description = "Kibana listening host";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = "Kibana listening port";
      default = 5601;
      type = types.int;
    };

    cert = mkOption {
      description = "Kibana ssl certificate.";
      default = null;
      type = types.nullOr types.path;
    };

    key = mkOption {
      description = "Kibana ssl key.";
      default = null;
      type = types.nullOr types.path;
    };

    index = mkOption {
      description = "Elasticsearch index to use for saving kibana config.";
      default = ".kibana";
      type = types.str;
    };

    defaultAppId = mkOption {
      description = "Elasticsearch default application id.";
      default = "discover";
      type = types.str;
    };

    elasticsearch = {
      url = mkOption {
        description = "Elasticsearch url";
        default = "http://localhost:9200";
        type = types.str;
      };

      username = mkOption {
        description = "Username for elasticsearch basic auth.";
        default = null;
        type = types.nullOr types.str;
      };

      password = mkOption {
        description = "Password for elasticsearch basic auth.";
        default = null;
        type = types.nullOr types.str;
      };

      ca = mkOption {
        description = "CA file to auth against elasticsearch.";
        default = null;
        type = types.nullOr types.path;
      };

      cert = mkOption {
        description = "Certificate file to auth against elasticsearch.";
        default = null;
        type = types.nullOr types.path;
      };

      key = mkOption {
        description = "Key file to auth against elasticsearch.";
        default = null;
        type = types.nullOr types.path;
      };
    };

    logLevel = mkOption {
      description = "Kibana log level";
      default = "normal";
      type = types.enum ["verbose" "normal" "silent" "quiet"];
    };

    package = mkOption {
      description = "Kibana package to use";
      default = pkgs.kibana;
      defaultText = "pkgs.kibana";
      type = types.package;
    };

    dataDir = mkOption {
      description = "Kibana data directory";
      default = "/var/lib/kibana";
      type = types.path;
    };

    extraConf = mkOption {
      description = "Kibana extra configuration";
      default = {};
      type = types.attrs;
    };
  };

  config = mkIf (cfg.enable) {
    systemd.services.kibana = {
      description = "Kibana Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-interfaces.target" "elasticsearch.service" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/kibana --config ${cfgFile}";
        User = "kibana";
        WorkingDirectory = cfg.dataDir;
      };
    };

    environment.systemPackages = [ cfg.package ];

    users.extraUsers = singleton {
      name = "kibana";
      uid = config.ids.uids.kibana;
      description = "Kibana service user";
      home = cfg.dataDir;
      createHome = true;
    };
  };
}
