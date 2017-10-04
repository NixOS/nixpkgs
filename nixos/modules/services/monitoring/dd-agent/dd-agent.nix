{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dd-agent;

  ddConf = pkgs.writeText "datadog.conf" ''
    [Main]
    dd_url: https://app.datadoghq.com
    skip_ssl_validation: no
    api_key: ${cfg.api_key}
    ${optionalString (cfg.hostname != null) "hostname: ${cfg.hostname}"}

    collector_log_file: /var/log/datadog/collector.log
    forwarder_log_file: /var/log/datadog/forwarder.log
    dogstatsd_log_file: /var/log/datadog/dogstatsd.log
    jmxfetch_log_file:  /var/log/datadog/jmxfetch.log
    go-metro_log_file:  /var/log/datadog/go-metro.log
    trace-agent_log_file: /var/log/datadog/trace-agent.log

    ${optionalString (cfg.tags != null ) "tags: ${concatStringsSep "," cfg.tags }"}
    ${cfg.extraDdConfig}
  '';

  # Integrations requested by the user, always-on disk and network
  # integrations and any integrations we have explicit support for.
  allWantedIntegrations =
    let fromConfig =  n: c: optional (c != null) { name = n; config = c; };
    in cfg.integrations ++ [ { name = "disk"; } { name = "network"; } ] ++
       (fromConfig "postgres" cfg.postgresqlConfig) ++
       (fromConfig "nginx" cfg.nginxConfig) ++
       (fromConfig "mongo" cfg.mongoConfig) ++
       (fromConfig "process" cfg.processConfig) ++
       (fromConfig "jmx" cfg.jmxConfig);

  etcfiles =
    map (i: { source = if builtins.hasAttr "config" i
                       then pkgs.writeText "${i.name}.yaml" i.config
                       else "${cfg.agent}/agent/conf.d-system/${i.name}.yaml";
              target = "dd-agent/conf.d/${i.name}.yaml";
            }
        ) allWantedIntegrations ++
        [ { source = ddConf;
            target = "dd-agent/datadog.conf";
          }
        ];

  # restart triggers
  etcSources = map (i: i.source) etcfiles;

  # Only pull in dependencies for default supported integrations if
  # they are actually used.
  defaultIntegrationDeps = with pkgs.pythonPackages;
    let mDep = n: ds: if builtins.any (i: i.name == n) allWantedIntegrations then ds else [];
    in mDep "disk" [ psutil ] ++
       mDep "network" [ psutil ] ++
       mDep "postgres" [ pg8000 psycopg2 ] ++
       mDep "mongo" [ pymongo ];
in {
  options.services.dd-agent = {
    enable = mkOption {
      description = "Whether to enable the dd-agent montioring service";
      default = false;
      type = types.bool;
    };

    api_key = mkOption {
      description = "The Datadog API key to associate the agent with your account";
      example = "ae0aa6a8f08efa988ba0a17578f009ab";
      type = types.str;
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

    postgresqlConfig = mkOption {
      description = "Datadog PostgreSQL integration configuration";
      default = null;
      type = types.uniq (types.nullOr types.string);
    };

    nginxConfig = mkOption {
      description = "Datadog nginx integration configuration";
      default = null;
      type = types.uniq (types.nullOr types.string);
    };

    mongoConfig = mkOption {
      description = "MongoDB integration configuration";
      default = null;
      type = types.uniq (types.nullOr types.string);
    };

    jmxConfig = mkOption {
      description = "JMX integration configuration";
      default = null;
      type = types.uniq (types.nullOr types.string);
    };

    processConfig = mkOption {
      description = ''
        Process integration configuration

        See http://docs.datadoghq.com/integrations/process/
      '';
      default = null;
      type = types.uniq (types.nullOr types.string);
    };

    agent = mkOption {
      description = "The dd-agent package to use. Useful when overriding the package.";
      default = pkgs.dd-agent.override {
        # Make sure we have dependencies that default supported
        # integrations need.
        extraBuildInputs = defaultIntegrationDeps;
      };
      type = types.package;
    };

    integrations = mkOption {
      description = ''
        Any integrations to use. Default config used if none
        specified. It is currently up to the user to make sure that
        the dd-agent package used has all the dependencies chosen
        integrations require in scope. <literal>disk</literal> and
        <literal>network</literal> integrations are always included.
        An integration configured through explicit service support
        such as <literal>processConfig</literal> takes precedence over
        any configuration specified here.
      '';
      type = types.listOf (types.attrsOf types.string);
      default = [];
      example = ''
        [ { name = "elastic";
            config = '''
              init_config:

              instances:
                - url: http://localhost:9200
            ''';
          }
          { name = "nginx"; }
          { name = "ntp"; }
        ]
      '';
    };

    extraDdConfig = mkOption {
      description = "Extra settings to append to datadog agent config.";
      default = "";
      type = types.string;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.agent pkgs.sysstat pkgs.procps ];

    users.extraUsers.datadog = {
      description = "Datadog Agent User";
      uid = config.ids.uids.datadog;
      group = "datadog";
      home = "/var/log/datadog/";
      createHome = true;
    };

    users.extraGroups.datadog.gid = config.ids.gids.datadog;

    systemd.services.dd-agent = {
      description = "Datadog agent monitor";
      path = [ pkgs.sysstat pkgs.procps ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.supervisor}/bin/supervisord -c ${cfg.agent}/agent/supervisor.conf";
        User = "datadog";
        Group = "datadog";
        Restart = "always";
        WorkingDirectory = "${cfg.agent}";
        RestartSec = 2;
      };
      restartTriggers = [ cfg.agent ddConf ] ++ etcSources;
    };

    environment.etc = etcfiles;
  };
}
