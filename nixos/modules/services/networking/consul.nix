{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let

  dataDir = "/var/lib/consul";
  cfg = config.services.consul;

  configOptions = {
    data_dir = dataDir;
    ui_config = {
      enabled = cfg.webUi;
    };
  } // cfg.extraConfig;

  configFiles = [
    "/etc/consul.json"
    "/etc/consul-addrs.json"
  ] ++ cfg.extraConfigFiles;

  devices = lib.attrValues (lib.filterAttrs (_: i: i != null) cfg.interface);
  systemdDevices = lib.forEach devices (
    i: "sys-subsystem-net-devices-${utils.escapeSystemdPath i}.device"
  );
in
{
  options = {

    services.consul = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enables the consul daemon.
        '';
      };

      package = lib.mkPackageOption pkgs "consul" { };

      webUi = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enables the web interface on the consul http port.
        '';
      };

      leaveOnStop = lib.mkOption {
        type = lib.types.bool;
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

        advertise = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            The name of the interface to pull the advertise_addr from.
          '';
        };

        bind = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            The name of the interface to pull the bind_addr from.
          '';
        };
      };

      forceAddrFamily = lib.mkOption {
        type = lib.types.enum [
          "any"
          "ipv4"
          "ipv6"
        ];
        default = "any";
        description = ''
          Whether to bind ipv4/ipv6 or both kind of addresses.
        '';
      };

      forceIpv4 = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = ''
          Deprecated: Use consul.forceAddrFamily instead.
          Whether we should force the interfaces to only pull ipv4 addresses.
        '';
      };

      dropPrivileges = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether the consul agent should be run as a non-root consul user.
        '';
      };

      extraConfig = lib.mkOption {
        default = { };
        type = lib.types.attrsOf lib.types.anything;
        description = ''
          Extra configuration options which are serialized to json and added
          to the config.json file.
        '';
      };

      extraConfigFiles = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Additional configuration files to pass to consul
          NOTE: These will not trigger the service to be restarted when altered.
        '';
      };

      alerts = {
        enable = lib.mkEnableOption "consul-alerts";

        package = lib.mkPackageOption pkgs "consul-alerts" { };

        listenAddr = lib.mkOption {
          description = "Api listening address.";
          default = "localhost:9000";
          type = lib.types.str;
        };

        consulAddr = lib.mkOption {
          description = "Consul api listening address";
          default = "localhost:8500";
          type = lib.types.str;
        };

        watchChecks = lib.mkOption {
          description = "Whether to enable check watcher.";
          default = true;
          type = lib.types.bool;
        };

        watchEvents = lib.mkOption {
          description = "Whether to enable event watcher.";
          default = true;
          type = lib.types.bool;
        };
      };

    };

  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {

        users.users.consul = {
          description = "Consul agent daemon user";
          isSystemUser = true;
          group = "consul";
          # The shell is needed for health checks
          shell = "/run/current-system/sw/bin/bash";
        };
        users.groups.consul = { };

        environment = {
          etc."consul.json".text = builtins.toJSON configOptions;
          # We need consul.d to exist for consul to start
          etc."consul.d/dummy.json".text = "{ }";
          systemPackages = [ cfg.package ];
        };

        warnings = lib.flatten [
          (lib.optional (cfg.forceIpv4 != null) ''
            The option consul.forceIpv4 is deprecated, please use
            consul.forceAddrFamily instead.
          '')
        ];

        systemd.services.consul = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ] ++ systemdDevices;
          bindsTo = systemdDevices;
          restartTriggers =
            [ config.environment.etc."consul.json".source ]
            ++ lib.mapAttrsToList (_: d: d.source) (
              lib.filterAttrs (n: _: lib.hasPrefix "consul.d/" n) config.environment.etc
            );

          serviceConfig =
            {
              ExecStart =
                "@${lib.getExe cfg.package} consul agent -config-dir /etc/consul.d"
                + lib.concatMapStrings (n: " -config-file ${n}") configFiles;
              ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
              PermissionsStartOnly = true;
              User = if cfg.dropPrivileges then "consul" else null;
              Restart = "on-failure";
              TimeoutStartSec = "infinity";
            }
            // (lib.optionalAttrs (cfg.leaveOnStop) {
              ExecStop = "${lib.getExe cfg.package} leave";
            });

          path = with pkgs; [
            iproute2
            gawk
            cfg.package
          ];
          preStart =
            let
              family =
                if cfg.forceAddrFamily == "ipv6" then
                  "-6"
                else if cfg.forceAddrFamily == "ipv4" then
                  "-4"
                else
                  "";
            in
            ''
              mkdir -m 0700 -p ${dataDir}
              chown -R consul ${dataDir}

              # Determine interface addresses
              getAddrOnce () {
                ip ${family} addr show dev "$1" scope global \
                  | awk -F '[ /\t]*' '/inet/ {print $3}' | head -n 1
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
            + lib.concatStrings (
              lib.flip lib.mapAttrsToList cfg.interface (
                name: i:
                lib.optionalString (i != null) ''
                  echo "$delim \"${name}_addr\": \"$(getAddr "${i}")\"" >> /etc/consul-addrs.json
                  delim=","
                ''
              )
            )
            + ''
              echo "}" >> /etc/consul-addrs.json
            '';
        };
      }

      # deprecated
      (lib.mkIf (cfg.forceIpv4 != null && cfg.forceIpv4) {
        services.consul.forceAddrFamily = "ipv4";
      })

      (lib.mkIf (cfg.alerts.enable) {
        systemd.services.consul-alerts = {
          wantedBy = [ "multi-user.target" ];
          after = [ "consul.service" ];

          path = [ cfg.package ];

          serviceConfig = {
            ExecStart = ''
              ${lib.getExe cfg.alerts.package} start \
                --alert-addr=${cfg.alerts.listenAddr} \
                --consul-addr=${cfg.alerts.consulAddr} \
                ${lib.optionalString cfg.alerts.watchChecks "--watch-checks"} \
                ${lib.optionalString cfg.alerts.watchEvents "--watch-events"}
            '';
            User = if cfg.dropPrivileges then "consul" else null;
            Restart = "on-failure";
          };
        };
      })

    ]
  );
}
