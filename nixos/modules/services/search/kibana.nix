{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kibana;

  atLeast54 = versionAtLeast (builtins.parseDrvName cfg.package.name).version "5.4";

  cfgFile = if atLeast54 then cfgFile5 else cfgFile4;

  cfgFile4 = pkgs.writeText "kibana.json" (builtins.toJSON (
    (filterAttrsRecursive (n: v: v != null) ({
      host = cfg.listenAddress;
      port = cfg.port;
      ssl_cert_file = cfg.cert;
      ssl_key_file = cfg.key;

      kibana_index = cfg.index;
      default_app_id = cfg.defaultAppId;

      elasticsearch_url = cfg.elasticsearch.url;
      kibana_elasticsearch_username = cfg.elasticsearch.username;
      kibana_elasticsearch_password = cfg.elasticsearch.password;
      kibana_elasticsearch_cert = cfg.elasticsearch.cert;
      kibana_elasticsearch_key = cfg.elasticsearch.key;
      ca = cfg.elasticsearch.ca;

      bundled_plugin_ids = [
        "plugins/dashboard/index"
        "plugins/discover/index"
        "plugins/doc/index"
        "plugins/kibana/index"
        "plugins/markdown_vis/index"
        "plugins/metric_vis/index"
        "plugins/settings/index"
        "plugins/table_vis/index"
        "plugins/vis_types/index"
        "plugins/visualize/index"
      ];
    } // cfg.extraConf)
  )));

  cfgFile5 = pkgs.writeText "kibana.json" (builtins.toJSON (
    (filterAttrsRecursive (n: v: v != null) ({
      server.host = cfg.listenAddress;
      server.port = cfg.port;
      server.ssl.certificate = cfg.cert;
      server.ssl.key = cfg.key;

      kibana.index = cfg.index;
      kibana.defaultAppId = cfg.defaultAppId;

      elasticsearch.url = cfg.elasticsearch.url;
      elasticsearch.username = cfg.elasticsearch.username;
      elasticsearch.password = cfg.elasticsearch.password;

      elasticsearch.ssl.certificate = cfg.elasticsearch.cert;
      elasticsearch.ssl.key = cfg.elasticsearch.key;
      elasticsearch.ssl.certificateAuthorities = cfg.elasticsearch.certificateAuthorities;
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
        description = ''
          CA file to auth against elasticsearch.

          It's recommended to use the <option>certificateAuthorities</option> option
          when using kibana-5.4 or newer.
        '';
        default = null;
        type = types.nullOr types.path;
      };

      certificateAuthorities = mkOption {
        description = ''
          CA files to auth against elasticsearch.

          Please use the <option>ca</option> option when using kibana &lt; 5.4
          because those old versions don't support setting multiple CA's.

          This defaults to the singleton list [ca] when the <option>ca</option> option is defined.
        '';
        default = if isNull cfg.elasticsearch.ca then [] else [ca];
        type = types.listOf types.path;
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

    package = mkOption {
      description = "Kibana package to use";
      default = pkgs.kibana;
      defaultText = "pkgs.kibana";
      example = "pkgs.kibana5";
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
      after = [ "network.target" "elasticsearch.service" ];
      environment = { BABEL_CACHE_PATH = "${cfg.dataDir}/.babelcache.json"; };
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
