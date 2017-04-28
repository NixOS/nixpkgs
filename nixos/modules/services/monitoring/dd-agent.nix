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

    # proxy_host: my-proxy.com
    # proxy_port: 3128
    # proxy_user: user
    # proxy_password: password

    # tags: mytag0, mytag1
    ${optionalString (cfg.tags != null ) "tags: ${concatStringsSep "," cfg.tags }"}

    # collect_ec2_tags: no
    # recent_point_threshold: 30
    # use_mount: no
    # listen_port: 17123
    # graphite_listen_port: 17124
    # non_local_traffic: no
    # use_curl_http_client: False
    # bind_host: localhost

    # use_pup: no
    # pup_port: 17125
    # pup_interface: localhost
    # pup_url: http://localhost:17125

    # dogstatsd_port : 8125
    # dogstatsd_interval : 10
    # dogstatsd_normalize : yes
    # statsd_forward_host: address_of_own_statsd_server
    # statsd_forward_port: 8125

    # device_blacklist_re: .*\/dev\/mapper\/lxc-box.*

    # ganglia_host: localhost
    # ganglia_port: 8651
  '';

  diskConfig = pkgs.writeText "disk.yaml" ''
    init_config:

    instances:
      - use_mount: no
  '';

  networkConfig = pkgs.writeText "network.yaml" ''
    init_config:

    instances:
      # Network check only supports one configured instance
      - collect_connection_state: false
        excluded_interfaces:
          - lo
          - lo0
  '';

  postgresqlConfig = pkgs.writeText "postgres.yaml" cfg.postgresqlConfig;
  nginxConfig = pkgs.writeText "nginx.yaml" cfg.nginxConfig;
  mongoConfig = pkgs.writeText "mongo.yaml" cfg.mongoConfig;
  jmxConfig = pkgs.writeText "jmx.yaml" cfg.jmxConfig;
  processConfig = pkgs.writeText "process.yaml" cfg.processConfig;

  conf-d = pkgs.runCommand "dd-agent-conf.d" {} ''
    mkdir -p $out/conf.d

    # Copy default configs first
    cp -R ${pkgs.dd-agent}/agent/conf.d-system/* $out/conf.d/

    # Override config files
    ln -sf ${ddConf} $out/datadog.conf
    ln -sf ${diskConfig} $out/conf.d/disk.yaml
    ln -sf ${networkConfig} $out/conf.d/network.yaml
    ${optionalString (cfg.postgresqlConfig != null) "ln -sf ${postgresqlConfig} $out/conf.d/postgres.yaml"}
    ${optionalString (cfg.nginxConfig != null) "ln -sf ${nginxConfig} $out/conf.d/nginx.yaml"}
    ${optionalString (cfg.mongoConfig != null) "ln -sf ${mongoConfig} $out/conf.d/mongo.yaml"}
    ${optionalString (cfg.processConfig != null) "ln -sf ${processConfig} $out/conf.d/process.yaml"}
    ${optionalString (cfg.jmxConfig != null) "ln -sf ${jmxConfig} $out/conf.d/jmx.yaml"}
  '';
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

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs."dd-agent" pkgs.sysstat pkgs.procps ];

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
      path = [ pkgs."dd-agent" pkgs.python pkgs.sysstat pkgs.procps ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dd-agent}/bin/dd-agent foreground";
        User = "datadog";
        Group = "datadog";
        Restart = "always";
        RestartSec = 2;
      };
      restartTriggers = [ pkgs.dd-agent ddConf diskConfig networkConfig postgresqlConfig nginxConfig mongoConfig jmxConfig processConfig ];
    };

    systemd.services.dogstatsd = {
      description = "Datadog statsd";
      path = [ pkgs."dd-agent" pkgs.python pkgs.procps ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dd-agent}/bin/dogstatsd start";
        User = "datadog";
        Group = "datadog";
        Type = "forking";
        PIDFile = "/tmp/dogstatsd.pid";
        Restart = "always";
        RestartSec = 2;
      };
      restartTriggers = [ pkgs.dd-agent ddConf diskConfig networkConfig postgresqlConfig nginxConfig mongoConfig jmxConfig processConfig ];
    };

    systemd.services.dd-jmxfetch = lib.mkIf (cfg.jmxConfig != null) {
      description = "Datadog JMX Fetcher";
      path = [ pkgs."dd-agent" pkgs.python pkgs.sysstat pkgs.procps pkgs.jdk ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.dd-agent}/bin/dd-jmxfetch";
        User = "datadog";
        Group = "datadog";
        Restart = "always";
        RestartSec = 2;
      };
      restartTriggers = [ pkgs.dd-agent ddConf diskConfig networkConfig postgresqlConfig nginxConfig mongoConfig jmxConfig ];
    };

    environment.etc = [{
      source = conf-d;
      target = "dd-agent";
    }];
  };
}
