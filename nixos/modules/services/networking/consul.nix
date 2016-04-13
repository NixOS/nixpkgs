{ config, lib, pkgs, utils, ... }:

with lib;
let

  dataDir = "/var/lib/consul";
  cfg = config.services.consul;

  configOptions = { data_dir = dataDir; } //
    (if cfg.webUi then { ui_dir = "${cfg.package.ui}"; } else { }) //
    cfg.extraConfig;

  configFiles = [ "/etc/consul.json" "/etc/consul-addrs.json" ]
    ++ cfg.extraConfigFiles;

  devices = attrValues (filterAttrs (_: i: i != null) cfg.interface);
  systemdDevices = flip map devices
    (i: "sys-subsystem-net-devices-${utils.escapeSystemdPath i}.device");
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


      webUi = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables the web interface on the consul http port.
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

      interface = {

        advertise = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The name of the interface to pull the advertise_addr from.
          '';
        };

        bind = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The name of the interface to pull the bind_addr from.
          '';
        };

      };

      forceIpv4 = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether we should force the interfaces to only pull ipv4 addresses.
        '';
      };

      dropPrivileges = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether the consul agent should be run as a non-root consul user.
        '';
      };

      extraConfig = mkOption {
        default = { };
        description = ''
          Extra configuration options which are serialized to json and added
          to the config.json file.
        '';
      };

      extraConfigFiles = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = ''
          Additional configuration files to pass to consul
          NOTE: These will not trigger the service to be restarted when altered.
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
          description = "Api listening address.";
          default = "localhost:9000";
          type = types.str;
        };

        consulAddr = mkOption {
          description = "Consul api listening adddress";
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
    mkMerge [{

      users.extraUsers."consul" = {
        description = "Consul agent daemon user";
        uid = config.ids.uids.consul;
        # The shell is needed for health checks
        shell = "/run/current-system/sw/bin/bash";
      };

      environment = {
        etc."consul.json".text = builtins.toJSON configOptions;
        # We need consul.d to exist for consul to start
        etc."consul.d/dummy.json".text = "{ }";
        systemPackages = [ cfg.package ];
      };

      systemd.services.consul = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ] ++ systemdDevices;
        bindsTo = systemdDevices;
        restartTriggers = [ config.environment.etc."consul.json".source ]
          ++ mapAttrsToList (_: d: d.source)
            (filterAttrs (n: _: hasPrefix "consul.d/" n) config.environment.etc);

        serviceConfig = {
          ExecStart = "@${cfg.package}/bin/consul consul agent -config-dir /etc/consul.d"
            + concatMapStrings (n: " -config-file ${n}") configFiles;
          ExecReload = "${cfg.package}/bin/consul reload";
          PermissionsStartOnly = true;
          User = if cfg.dropPrivileges then "consul" else null;
          TimeoutStartSec = "0";
        } // (optionalAttrs (cfg.leaveOnStop) {
          ExecStop = "${cfg.package}/bin/consul leave";
        });

        path = with pkgs; [ iproute gnugrep gawk consul ];
        preStart = ''
          mkdir -m 0700 -p ${dataDir}
          chown -R consul ${dataDir}

          # Determine interface addresses
          getAddrOnce () {
            ip addr show dev "$1" \
              | grep 'inet${optionalString (cfg.forceIpv4) " "}.*scope global' \
              | awk -F '[ /\t]*' '{print $3}' | head -n 1
          }
          getAddr () {
            ADDR="$(getAddrOnce $1)"
            LEFT=60 # Die after 1 minute
            while [ -z "$ADDR" ]; do
              sleep 1
              LEFT=$(expr $LEFT - 1)
              if [ "$LEFT" -eq "0" ]; then
                echo "Address lookup timed out"
                exit 1
              fi
              ADDR="$(getAddrOnce $1)"
            done
            echo "$ADDR"
          }
          echo "{" > /etc/consul-addrs.json
          delim=" "
        ''
        + concatStrings (flip mapAttrsToList cfg.interface (name: i:
          optionalString (i != null) ''
            echo "$delim \"${name}_addr\": \"$(getAddr "${i}")\"" >> /etc/consul-addrs.json
            delim=","
          ''))
        + ''
          echo "}" >> /etc/consul-addrs.json
        '';
      };
    }

    (mkIf (cfg.alerts.enable) {
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
          User = if cfg.dropPrivileges then "consul" else null;
          Restart = "on-failure";
        };
      };
    })

  ]);
}
