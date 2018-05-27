{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.datadog-agent;

  ddConf = {
    dd_url              = "https://app.datadoghq.com";
    skip_ssl_validation = "no";
    api_key             = "";
    confd_path          = "/etc/datadog-agent/conf.d";
    additional_checksd  = "/etc/datadog-agent/checks.d";
    use_dogstatsd       = "yes";
  }
  // optionalAttrs (cfg.logLevel != null) { log_level = cfg.logLevel; }
  // optionalAttrs (cfg.hostname != null) { inherit (cfg) hostname; }
  // optionalAttrs (cfg.tags != null ) { tags = concatStringsSep ", " cfg.tags; }
  // cfg.extraConfig;

  makeConfigDir = entries: mapAttrsToList (name: conf: {
    source = pkgs.writeText (baseNameOf name) (builtins.toJSON conf);
    target = "datadog-agent/" + name;
  }) (filterAttrs (name: conf: conf != null) entries);

  etcfiles = makeConfigDir
    { "datadog.yaml" = ddConf;
      "conf.d/disk.yaml" = cfg.diskConfig;
      "conf.d/network.yaml" = cfg.networkConfig;
      "conf.d/postgres.d/conf.yaml" = cfg.postgresqlConfig;
      "conf.d/nginx.d/conf.yaml" = cfg.nginxConfig;
      "conf.d/mongo.d/conf.yaml" = cfg.mongoConfig;
      "conf.d/process.yaml" = cfg.processConfig;
      "conf.d/jmx.yaml" = cfg.jmxConfig;
    };

in {
  options.services.datadog-agent = {
    enable = mkOption {
      description = ''
        Whether to enable the datadog-agent v6 monitoring service
      '';
      default = false;
      type = types.bool;
    };

    package = mkOption {
      default = pkgs.datadog-agent;
      defaultText = "pkgs.datadog-agent";
      description = ''
        Which DataDog v6 agent package to use.
        Override the <literal>pythonPackages</literal> argument
        of this derivation to include more checks.
      '';
      type = types.package;
    };

    apiKeyFile = mkOption {
      description = ''
        Path to a file containing the Datadog API key to associate the
        agent with your account.
      '';
      example = "/run/keys/datadog_api_key";
      type = types.path;
    };

    tags = mkOption {
      description = "The tags to mark this Datadog agent";
      example = [ "test" "service" ];
      default = null;
      type = types.nullOr (types.listOf types.str);
    };

    hostname = mkOption {
      description = "The hostname to show in the Datadog dashboard (optional)";
      default = null;
      example = "mymachine.mydomain";
      type = types.uniq (types.nullOr types.string);
    };

    logLevel = mkOption {
      description = "Logging verbosity.";
      default = null;
      type = types.nullOr (types.enum ["DEBUG" "INFO" "WARN" "ERROR"]);
    };

    extraConfig = mkOption {
      default = {};
      type = types.attrs;
      description = ''
        Extra configuration options that will be merged into the
        main config file <filename>datadog.yaml</filename>.
      '';
     };

    diskConfig = mkOption {
      description = "Disk check config";
      type = types.attrs;
      default = {
        init_config = {};
        instances = [ { use-mount = "no"; } ];
      };
     };

    networkConfig = mkOption {
      description = "Network check config";
      type = types.attrs;
      default = {
        init_config = {};
        # Network check only supports one configured instance
        instances = [ { collect_connection_state = false;
                        excluded_interfaces = [ "lo" "lo0" ]; } ];
      };
    };

    postgresqlConfig = mkOption {
      description = "Datadog PostgreSQL integration configuration";
      default = null;
      type = types.nullOr types.attrs;
    };

    nginxConfig = mkOption {
      description = "Datadog nginx integration configuration";
      default = null;
      type = types.nullOr types.attrs;
    };

    mongoConfig = mkOption {
      description = "MongoDB integration configuration";
      default = null;
      type = types.nullOr types.attrs;
    };

    jmxConfig = mkOption {
      description = "JMX integration configuration";
      default = null;
      type = types.nullOr types.attrs;
    };

    processConfig = mkOption {
      description = ''
        Process integration configuration

        See http://docs.datadoghq.com/integrations/process/
      '';
      default = null;
      type = types.nullOr types.attrs;
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package pkgs.sysstat pkgs.procps ];

    users.extraUsers.datadog = {
      description = "Datadog Agent User";
      uid = config.ids.uids.datadog;
      group = "datadog";
      home = "/var/log/datadog/";
      createHome = true;
    };

    users.extraGroups.datadog.gid = config.ids.gids.datadog;

    systemd.services = let
      makeService = attrs: recursiveUpdate {
        path = [ cfg.package pkgs.python pkgs.sysstat pkgs.procps ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "datadog";
          Group = "datadog";
          Restart = "always";
          RestartSec = 2;
          PrivateTmp = true;
        };
        restartTriggers = [ cfg.package ] ++ map (etc: etc.source) etcfiles;
      } attrs;
    in {
      datadog-agent = makeService {
        description = "Datadog agent monitor";
        preStart = ''
          chown -R datadog: /etc/datadog-agent
          rm -f /etc/datadog-agent/auth_token
        '';
        script = ''
          export DD_API_KEY=$(head -n1 ${cfg.apiKeyFile})
          exec ${cfg.package}/bin/agent start -c /etc/datadog-agent/datadog.yaml
        '';
        serviceConfig.PermissionsStartOnly = true;
      };

      dd-jmxfetch = lib.mkIf (cfg.jmxConfig != null) (makeService {
        description = "Datadog JMX Fetcher";
        path = [ cfg.package pkgs.python pkgs.sysstat pkgs.procps pkgs.jdk ];
        serviceConfig.ExecStart = "${cfg.package}/bin/dd-jmxfetch";
      });
    };

    environment.etc = etcfiles;
  };
}
