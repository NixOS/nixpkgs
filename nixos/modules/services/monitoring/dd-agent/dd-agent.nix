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
    ${optionalString (cfg.tags != null ) "tags: ${concatStringsSep ", " cfg.tags }"}

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

  etcfiles =
    let
      defaultConfd = import ./dd-agent-defaults.nix;
    in
      listToAttrs (map (f: {
        name = "dd-agent/conf.d/${f}";
        value.source = "${pkgs.dd-agent}/agent/conf.d-system/${f}";
      }) defaultConfd) //
      {
        "dd-agent/datadog.conf".source = ddConf;
        "dd-agent/conf.d/disk.yaml".source = diskConfig;
        "dd-agent/conf.d/network.yaml".source = networkConfig;
      } //
      (optionalAttrs (cfg.postgresqlConfig != null)
      {
        "dd-agent/conf.d/postgres.yaml".source = postgresqlConfig;
      }) //
      (optionalAttrs (cfg.nginxConfig != null)
      {
        "dd-agent/conf.d/nginx.yaml".source = nginxConfig;
      }) //
      (optionalAttrs (cfg.mongoConfig != null)
      {
        "dd-agent/conf.d/mongo.yaml".source = mongoConfig;
      }) //
      (optionalAttrs (cfg.processConfig != null)
      {
        "dd-agent/conf.d/process.yaml".source = processConfig;
      }) //
      (optionalAttrs (cfg.jmxConfig != null)
      {
        "dd-agent/conf.d/jmx.yaml".source = jmxConfig;
      });

in {
  options.services.dd-agent = {
    enable = mkOption {
      description = lib.mdDoc ''
        Whether to enable the dd-agent v5 monitoring service.
        For datadog-agent v6, see {option}`services.datadog-agent.enable`.
      '';
      default = false;
      type = types.bool;
    };

    api_key = mkOption {
      description = lib.mdDoc ''
        The Datadog API key to associate the agent with your account.

        Warning: this key is stored in cleartext within the world-readable
        Nix store! Consider using the new v6
        {option}`services.datadog-agent` module instead.
      '';
      example = "ae0aa6a8f08efa988ba0a17578f009ab";
      type = types.str;
    };

    tags = mkOption {
      description = lib.mdDoc "The tags to mark this Datadog agent";
      example = [ "test" "service" ];
      default = null;
      type = types.nullOr (types.listOf types.str);
    };

    hostname = mkOption {
      description = lib.mdDoc "The hostname to show in the Datadog dashboard (optional)";
      default = null;
      example = "mymachine.mydomain";
      type = types.nullOr types.str;
    };

    postgresqlConfig = mkOption {
      description = lib.mdDoc "Datadog PostgreSQL integration configuration";
      default = null;
      type = types.nullOr types.lines;
    };

    nginxConfig = mkOption {
      description = lib.mdDoc "Datadog nginx integration configuration";
      default = null;
      type = types.nullOr types.lines;
    };

    mongoConfig = mkOption {
      description = lib.mdDoc "MongoDB integration configuration";
      default = null;
      type = types.nullOr types.lines;
    };

    jmxConfig = mkOption {
      description = lib.mdDoc "JMX integration configuration";
      default = null;
      type = types.nullOr types.lines;
    };

    processConfig = mkOption {
      description = lib.mdDoc ''
        Process integration configuration
        See <https://docs.datadoghq.com/integrations/process/>
      '';
      default = null;
      type = types.nullOr types.lines;
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.dd-agent pkgs.sysstat pkgs.procps ];

    users.users.datadog = {
      description = "Datadog Agent User";
      uid = config.ids.uids.datadog;
      group = "datadog";
      home = "/var/log/datadog/";
      createHome = true;
    };

    users.groups.datadog.gid = config.ids.gids.datadog;

    systemd.services = let
      makeService = attrs: recursiveUpdate {
        path = [ pkgs.dd-agent pkgs.python pkgs.sysstat pkgs.procps pkgs.gohai ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "datadog";
          Group = "datadog";
          Restart = "always";
          RestartSec = 2;
          PrivateTmp = true;
        };
        restartTriggers = [ pkgs.dd-agent ddConf diskConfig networkConfig postgresqlConfig nginxConfig mongoConfig jmxConfig processConfig ];
      } attrs;
    in {
      dd-agent = makeService {
        description = "Datadog agent monitor";
        serviceConfig.ExecStart = "${pkgs.dd-agent}/bin/dd-agent foreground";
      };

      dogstatsd = makeService {
        description = "Datadog statsd";
        environment.TMPDIR = "/run/dogstatsd";
        serviceConfig = {
          ExecStart = "${pkgs.dd-agent}/bin/dogstatsd start";
          Type = "forking";
          PIDFile = "/run/dogstatsd/dogstatsd.pid";
          RuntimeDirectory = "dogstatsd";
        };
      };

      dd-jmxfetch = lib.mkIf (cfg.jmxConfig != null) {
        description = "Datadog JMX Fetcher";
        path = [ pkgs.dd-agent pkgs.python pkgs.sysstat pkgs.procps pkgs.jdk ];
        serviceConfig.ExecStart = "${pkgs.dd-agent}/bin/dd-jmxfetch";
      };
    };

    environment.etc = etcfiles;
  };
}
