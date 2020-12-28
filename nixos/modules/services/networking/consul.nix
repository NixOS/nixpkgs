{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.consul;
  json = pkgs.formats.json { };
  settings = {
    data_dir = "/var/lib/consul";
  } // cfg.settings;
  settingsFiles = [ "/etc/consul.json" ] ++ cfg.settingsFiles;
in
{
  options = {
    services.consul = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables the consul daemon.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.consul;
        defaultText = "pkgs.consul";
        description = ''
          The package used for the Consul agent and CLI.
        '';
      };

      leaveOnStop = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, causes a leave action to be sent when closing consul.
          This allows a clean termination of the node, but permanently removes
          it from the cluster. You probably don't want this option unless you
          are running a node which going offline in a permanent / semi-permanent
          fashion.
        '';
      };

      settings = mkOption {
        type = format.type;
        default = { };
        description = ''
          Extra configuration options which are serialized to json and added
          to the config.json file.

          For example, to bind the client to specific interface's IP address you
          can use Consul's support for go-sockaddr templates:

          settings = {
            client_addr = "{{ GetInterfaceIP \"eth0\" }}";
          };
        '';
      };

      settingsFiles = mkOption {
        default = [ ];
        type = types.listOf (types.oneOf [ types.path types.str ]);
        description = ''
          Additional configuration files to pass to consul
        '';
      };

      dropPrivileges = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether the consul agent should be run as a non-root consul user.
        '';
      };

      alerts = {
        enable = mkEnableOption "consul-alerts";

        package = mkOption {
          description = "Package to use for consul-alerts.";
          default = pkgs.consul-alerts;
          defaultText = "pkgs.consul-alerts";
          type = types.package;
        };

        listenAddr = mkOption {
          description = "API listening address.";
          default = "localhost:9000";
          type = types.str;
        };

        consulAddr = mkOption {
          description = "Consul API listening adddress";
          default = "localhost:8500";
          type = types.str;
        };

        watchChecks = mkOption {
          description = "Whether to enable check watcher.";
          default = true;
          type = types.bool;
        };

        watchEvents = mkOption {
          description = "Whether to enable event watcher.";
          default = true;
          type = types.bool;
        };
      };
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        environment = {
          etc."consul.json".source = json.generate "consul.json" settings;
          systemPackages = [ cfg.package ];
        };

        systemd.services.consul = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          requires = [ "network-online.target" ];
          restartTriggers = settingsFiles;

          serviceConfig = {
            ExecStart = "${cfg.package}/bin/consul agent"
              + concatMapStrings (file: " -config-file=${file}") settingsFiles;
            ExecReload = "${pkgs.coreutils}/bin/kill --signal HUP $MAINPID";
            ExecStop = optionalString cfg.leaveOnStop "${cfg.package}/bin/consul leave";
            DynamicUser = cfg.dropPrivileges;
            User = optionalString cfg.dropPrivileges "consul";
            Type = "notify";
            KillMode = "process";
            KillSignal = "SIGTERM";
            Restart = "on-failure";
            StateDirectory = "consul";
            TimeoutStartSec = "infinity";
          };
        };
      }

      (mkIf cfg.alerts.enable {
        systemd.services.consul-alerts = {
          wantedBy = [ "multi-user.target" ];
          after = [ "consul.service" ];

          path = [ cfg.package ];

          serviceConfig = {
            ExecStart = ''
              ${cfg.alerts.package}/bin/consul-alerts start \
                --alert-addr=${cfg.alerts.listenAddr} \
                --consul-addr=${cfg.alerts.consulAddr} \
                ${optionalString cfg.alerts.watchChecks "--watch-checks"} \
                ${optionalString cfg.alerts.watchEvents "--watch-events"}
            '';
            DynamicUser = cfg.dropPrivileges;
            User = optionalString cfg.dropPrivileges "consul";
            Restart = "on-failure";
          };
        };
      })
    ]
  );
}
