{ config, pkgs, lib, ... }:

let
  cfg = config.services.netmeta;

  mkCue = package: value: pkgs.runCommand "out.cue" {
    nativeBuildInputs = [ pkgs.cue ];
    value = builtins.toJSON value;
    passAsFile = [ "value" ];
  } ''
    mv $valuePath input.json
    cue import -o $out -p ${package} input.json
  '';

  images_local = mkCue "k8s" {
    netmeta.images = {
      helloworld = { image = ""; digest = ""; };
      risinfo = { image = ""; digest = ""; };
      goflow = { image = ""; digest = ""; };
      portmirror = { image = ""; digest = ""; };
      reconciler = { image = ""; digest = ""; };
      grafana = { image = ""; digest = ""; };
    };
  };

  config_local = mkCue "k8s" {
    netmeta.config = {
      grafanaInitialAdminPassword = "<generate and paste secret here>";
      clickhouseAdminPassword =  "";
      clickhouseReadonlyPassword =  "";
      sessionSecret = "<generate and paste secret here>";

      publicHostname = "flowmon.example.com";

      letsencryptMode = "staging"; # change to "production" later
      letsencryptAccountMail = "letsencrypt@example.com";
    } // cfg.settings;
  };

  cue-dump-dashboards = pkgs.runCommand "dashboards" {
    nativeBuildInputs = [ pkgs.cue pkgs.yq-go ];
  } ''
    cp --no-preserve=mode -r ${pkgs.netmeta.src}/* .
    pushd deploy/single-node

    cp ${config_local} ./config_local.cue
    cp ${images_local} ./images_local.cue

    cue dump_dashboards
    cp -r out/dashboards $out
  '';

  cue-dump-json = pkgs.runCommand "cue-dump.json" {
    nativeBuildInputs = [ pkgs.cue pkgs.yq-go ];
  } ''
    cp --no-preserve=mode -r ${pkgs.netmeta.src}/* .
    pushd deploy/single-node

    cp ${config_local} ./config_local.cue
    cp ${images_local} ./images_local.cue

    cue dump | yq -o json . > $out
  '';

  reconcilerConfig = pkgs.runCommand "reconciler_config" {
    nativeBuildInputs = [ pkgs.jq ];
  } ''
    mkdir -p $out
    for i in $(jq -r 'select( .metadata.name == "reconciler-config") | .data | to_entries | .[] | @base64' ${cue-dump-json})
    do
      row=$(echo $i | base64 -d)
      echo "$row" | jq -r .value | sed "s/netmeta-kafka-bootstrap/localhost/g" > "$out/$(echo "$row" | jq -r .key)"
    done
  '';

  clickhouseConfig = pkgs.runCommand "clickhouse_config" {
    nativeBuildInputs = [ pkgs.jq ];
  } ''
    mkdir -p $out
    for i in $(jq -r 'select( .kind == "ClickHouseInstallation") | .spec.configuration.files | to_entries | .[] | @base64' ${cue-dump-json})
    do
      row=$(echo $i | base64 -d)
      echo "$row" | jq -r .value | sed "s;http://risinfo;http://localhost:14680;g" | sed "s;/etc/clickhouse-server/config.d;$out;g" > "$out/$(echo "$row" | jq -r .key)"
    done
  '';

in {

  options = with lib; {
    services.netmeta = {
      enable = mkEnableOption (lib.mdDoc "netmeta");

      settings = mkOption {
        type = types.attrs;
        default = {};
        description = lib.mdDoc ''
          Additional settings for NetMeta.
          Note that only the options related to the Grafana dashboards and the ClickHouse database are used. The options for reverse proxy, Let's Encrypt and port mirrors are not supported in the NixOS module!
          Check [config.cue](https://github.com/monogon-dev/NetMeta/blob/8c5f861d89903d858b7266187e703f3d20ea4c07/deploy/single-node/config.cue) for all available settings.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.sampler or {} != {};
        message = "You must specify a sampler config for netmeta to work correctly";
      }
    ];

    systemd.services.goflow2 = {
      wantedBy = [ "multi-user.target" ];
      after = [ "apache-kafka.service" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe pkgs.netmeta.goflow2} -metrics.addr :3507 -transport kafka -format pb -format.protobuf.fixedlen true";
        Restart = "always";
        RestartSec = 2;
      };
    };

    systemd.services.clickhouse.path = [ config.services.clickhouse.package ];

    systemd.services.netmeta-reconciler = {
      wantedBy = [ "multi-user.target" ];
      after = [ "clickhouse.service" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.netmeta}/bin/reconciler";
        WorkingDirectory = reconcilerConfig;
        Restart = "always";
        RestartSec = 2;
      };

      environment = {
        DB_HOST = "localhost:9000";
        DB_USER = "";
        DB_PASS = "";
      };
    };

    systemd.services.netmeta-risinfo = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.netmeta}/bin/risinfo -addr :14680";
        Restart = "always";
        RestartSec = 2;
      };
    };

    systemd.services.netmeta-migrations = {
      wantedBy = [ "multi-user.target" ];
      after = [ "clickhouse.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        DynamicUser = true;
        ExecStart = "${lib.getExe pkgs.netmeta.goose} up";
        Restart = "on-failure";
        RestartSec = 2;
      };
      environment = {
        GOOSE_DRIVER = "clickhouse";
        GOOSE_DBSTRING="tcp://localhost:9000/default";
        GOOSE_MIGRATION_DIR = "${pkgs.netmeta.src}/deploy/single-node/schema";
      };
    };

    services.zookeeper.enable = true;
    services.apache-kafka = {
      enable = true;
      settings = {
        "zookeeper.connect" = "127.0.0.1:2181";
        "log.dirs" = ["/var/lib/apache-kafka/logs"];
        "offsets.topic.replication.factor" = 1;
        "log.retention.bytes" = 1000000000;
        "log.cleaner.enable" = true;
        "log.cleanup.policy" = "delete";
      };
    };
    systemd.services.apache-kafka.serviceConfig.StateDirectory = "apache-kafka";

    services.clickhouse = {
      enable = true;
      package = pkgs.netmeta.clickhouse;
    };
    environment.etc."clickhouse-server/config.d/netmeta.xml".text = ''
      <?xml version="1.0"?>
      <clickhouse>
        <format_schema_path>${clickhouseConfig}/</format_schema_path>
        <dictionaries_config>${clickhouseConfig}/*.conf</dictionaries_config>
        <user_defined_executable_functions_config>${clickhouseConfig}/*_function.xml</user_defined_executable_functions_config>
      </clickhouse>
    '';

    systemd.services.clickhouse = {
      restartTriggers = [ config.environment.etc."clickhouse-server/config.d/netmeta.xml".source ];
    };

    services.grafana = {
      enable = lib.mkDefault true;

      settings = { };

      declarativePlugins = with pkgs.grafanaPlugins; [
        grafana-clickhouse-datasource
        netsage-sankey-panel
      ];

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            type = "grafana-clickhouse-datasource";
            name = "ClickHouse";
            isDefault = true;
            jsonData = {
              server = "localhost";
              port = "9000";
            };
          }
        ];
        dashboards.settings.providers = [
          {
            options.path = cue-dump-dashboards;
          }
        ];
      };
    };
  };
}
