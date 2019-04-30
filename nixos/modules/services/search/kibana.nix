{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kibana;

  ge7 = builtins.compareVersions cfg.package.version "7" >= 0;
  lt6_6 = builtins.compareVersions cfg.package.version "6.6" < 0;

  cfgFile = pkgs.writeText "kibana.json" (builtins.toJSON (
    (filterAttrsRecursive (n: v: v != null) ({
      server.host = cfg.listenAddress;
      server.port = cfg.port;
      server.ssl.certificate = cfg.cert;
      server.ssl.key = cfg.key;

      kibana.index = cfg.index;
      kibana.defaultAppId = cfg.defaultAppId;

      elasticsearch.url = cfg.elasticsearch.url;
      elasticsearch.hosts = cfg.elasticsearch.hosts;
      elasticsearch.username = cfg.elasticsearch.username;
      elasticsearch.password = cfg.elasticsearch.password;

      elasticsearch.ssl.certificate = cfg.elasticsearch.cert;
      elasticsearch.ssl.key = cfg.elasticsearch.key;
      elasticsearch.ssl.certificateAuthorities = cfg.elasticsearch.certificateAuthorities;
    } // cfg.extraConf)
  )));

in {
  options.services.kibana = {
    enable = mkEnableOption "kibana service";

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
        description = ''
          Elasticsearch url.

          Defaults to <literal>"http://localhost:9200"</literal>.

          Don't set this when using Kibana >= 7.0.0 because it will result in a
          configuration error. Use <option>services.kibana.elasticsearch.hosts</option>
          instead.
        '';
        default = null;
        type = types.nullOr types.str;
      };

      hosts = mkOption {
        description = ''
          The URLs of the Elasticsearch instances to use for all your queries.
          All nodes listed here must be on the same cluster.

          Defaults to <literal>[ "http://localhost:9200" ]</literal>.

          This option is only valid when using kibana >= 6.6.
        '';
        default = null;
        type = types.nullOr (types.listOf types.str);
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
    assertions = [
      {
        assertion = ge7 -> cfg.elasticsearch.url == null;
        message =
          "The option services.kibana.elasticsearch.url has been removed when using kibana >= 7.0.0. " +
          "Please use option services.kibana.elasticsearch.hosts instead.";
      }
      {
        assertion = lt6_6 -> cfg.elasticsearch.hosts == null;
        message =
          "The option services.kibana.elasticsearch.hosts is only valid for kibana >= 6.6.";
      }
    ];
    systemd.services.kibana = {
      description = "Kibana Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "elasticsearch.service" ];
      environment = { BABEL_CACHE_PATH = "${cfg.dataDir}/.babelcache.json"; };
      serviceConfig = {
        ExecStart =
          "${cfg.package}/bin/kibana" +
          " --config ${cfgFile}" +
          " --path.data ${cfg.dataDir}";
        User = "kibana";
        WorkingDirectory = cfg.dataDir;
      };
    };

    environment.systemPackages = [ cfg.package ];

    users.users = singleton {
      name = "kibana";
      uid = config.ids.uids.kibana;
      description = "Kibana service user";
      home = cfg.dataDir;
      createHome = true;
    };
  };
}
