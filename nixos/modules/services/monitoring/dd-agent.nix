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
  
  etcfiles =
    [ { source = ddConf;
        target = "dd-agent/datadog.conf";
      }
      { source = diskConfig;
        target = "dd-agent/conf.d/disk.yaml";
      }
      { source = networkConfig;
        target = "dd-agent/conf.d/network.yaml";
      } ] ++
    (optional (cfg.postgresqlConfig != null)
      { source = postgresqlConfig;
        target = "dd-agent/conf.d/postgres.yaml";
      }) ++
    (optional (cfg.nginxConfig != null)
      { source = nginxConfig;
        target = "dd-agent/conf.d/nginx.yaml";
      }) ++
    (optional (cfg.mongoConfig != null)
      { source = mongoConfig;
        target = "dd-agent/conf.d/mongo.yaml";
      });

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
      restartTriggers = [ pkgs.dd-agent ddConf diskConfig networkConfig postgresqlConfig nginxConfig mongoConfig ];
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
      restartTriggers = [ pkgs.dd-agent ddConf diskConfig networkConfig postgresqlConfig nginxConfig mongoConfig ];
    };

    environment.etc = etcfiles;
  };
}
