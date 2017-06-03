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
    pup_log_file:       /var/log/datadog/pup.log
    ${optionalString (cfg.tags != null ) "tags: ${concatStringsSep "," cfg.tags }"}
    ${cfg.extraDdConfig}
  '';

  etcfiles =
    map (i: { source = if builtins.hasAttr "config" i
                       then pkgs.writeText "${i.name}.yaml" i.config
                       else "${pkgs.dd-agent}/agent/conf.d-system/${i.name}.yaml";
              target = "dd-agent/conf.d/${i.name}.yaml";
            }
        ) cfg.integrations ++
        [ { source = ddConf;
            target = "dd-agent/datadog.conf";
          }
        ];

  # restart triggers
  etcSources = map (i: i.source) etcfiles;

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

    agent = mkOption {
      description = "The dd-agent package to use. Useful when overriding the package.";
      default = pkgs.dd-agent;
      type = types.package;
    };

    integrations = mkOption {
      description = ''
        Any integrations to use. Default config used if none
        specified. It is currently up to the user to make sure that
        the dd-agent package used has all the dependencies chosen
        integrations require in scope.
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
          { name = "network"; }
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
      path = [ cfg.agent pkgs.python pkgs.sysstat pkgs.procps ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dd-agent}/bin/dd-agent foreground";
        User = "datadog";
        Group = "datadog";
        Restart = "always";
        RestartSec = 2;
      };
      restartTriggers = [ pkgs.dd-agent ddConf ] ++ etcSources;
    };

    systemd.services.dd-jmxfetch = lib.mkIf (builtins.any (i: i.name == "jmx") cfg.integrations) {
      description = "Datadog JMX Fetcher";
      path = [ cfg.agent pkgs.python pkgs.sysstat pkgs.procps pkgs.jdk ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dd-agent}/bin/dd-jmxfetch";
        User = "datadog";
        Group = "datadog";
        Restart = "always";
        RestartSec = 2;
      };
      restartTriggers = [ cfg.agent ddConf ] ++ etcSources;
    };

    environment.etc = etcfiles;
  };
}
