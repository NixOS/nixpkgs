{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.ovn;
  inherit (lib) mkOption types;

  runDir = "/run/ovn";
  stateDir = "/var/lib/ovn";
  ovnUser = "ovn";
  ovnGroup = "ovn";
  jsonFormat = pkgs.formats.json { };

  tlsType = types.submodule {
    options = {
      privateKey = mkOption {
        type = types.externalPath;
        description = "Absolute path to the PEM private key.";
      };

      certificate = mkOption {
        type = types.externalPath;
        description = "Absolute path to the PEM certificate.";
      };

      caCertificate = mkOption {
        type = types.externalPath;
        description = "Absolute path to the PEM CA certificate.";
      };
    };
  };

  mkListenerType =
    {
      defaultPort,
      southbound ? false,
    }:
    types.submodule {
      options = {
        address = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = "Address on which the database server listens.";
        };

        port = mkOption {
          type = types.port;
          default = defaultPort;
          description = "Port on which the database server listens.";
        };

        openFirewall = lib.mkEnableOption "opening this listener's port in the firewall";

        transport = mkOption {
          type = types.enum [
            "tcp"
            "ssl"
          ];
          default = "ssl";
          description = "Transport used by this listener.";
        };
      }
      // lib.optionalAttrs southbound {
        role = mkOption {
          type = types.nullOr types.nonEmptyStr;
          default = "ovn-controller";
          description = ''
            OVSDB RBAC role assigned to connections accepted by this listener.
            Set to `null` to leave the role empty and grant unrestricted
            database access, as required by trusted administrative clients and
            `ovn-northd`.
          '';
        };
      };
    };

  mkRaftOptions = clusterPort: {
    openFirewall = lib.mkEnableOption "opening the local Raft port in the firewall";

    transport = mkOption {
      type = types.enum [
        "tcp"
        "ssl"
      ];
      default = "ssl";
      description = "Transport used for database cluster traffic.";
    };

    localAddress = mkOption {
      type = types.nullOr types.nonEmptyStr;
      default = null;
      description = "Address advertised by this database cluster member.";
    };

    localPort = mkOption {
      type = types.port;
      default = clusterPort;
      description = "Port used for database cluster traffic.";
    };

    bootstrap = {
      mode = mkOption {
        type = types.enum [
          "create"
          "join"
        ];
        default = "create";
        description = ''
          Whether to create a new cluster or join an existing member when the
          local database does not exist.
        '';
      };

      address = mkOption {
        type = types.nullOr types.nonEmptyStr;
        default = null;
        description = "Address of an existing member to join.";
      };

      port = mkOption {
        type = types.port;
        default = clusterPort;
        description = "Cluster port of the existing member to join.";
      };
    };
  };

  mkDatabaseOptions =
    {
      name,
      clientPort,
      clusterPort,
      southbound ? false,
    }:
    {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run the OVN ${name} database.";
      };

      mode = mkOption {
        type = types.enum [
          "standalone"
          "raft"
        ];
        default = "standalone";
        description = "Database replication mode.";
      };

      listeners = mkOption {
        type = types.attrsOf (mkListenerType {
          defaultPort = clientPort;
          inherit southbound;
        });
        default = { };
        description = ''
          Network listeners. The local Unix socket is always enabled. Listener
          names only identify definitions in the Nix configuration. The `tcp`
          and `ssl` transports produce the passive OVSDB connection methods
          `ptcp` and `pssl`, respectively.
        '';
      };

      tls = mkOption {
        type = types.nullOr tlsType;
        default = null;
        description = "TLS credentials used by SSL listeners and Raft transport.";
      };

      raft = mkRaftOptions clusterPort;
    };

  encapsulationType = types.submodule {
    options = {
      types = mkOption {
        type = types.nonEmptyListOf (
          types.enum [
            "geneve"
            "vxlan"
          ]
        );
        default = [ "geneve" ];
        description = "Tunnel encapsulation types advertised by this chassis.";
      };

      ips = mkOption {
        type = types.nonEmptyListOf types.nonEmptyStr;
        description = "Tunnel endpoint IP addresses advertised by this chassis.";
      };
    };
  };

  controllerInstanceType = types.submodule {
    options = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to run this controller instance.";
      };

      chassisName = mkOption {
        type = types.nonEmptyStr;
        description = "Chassis name advertised by this controller.";
      };

      encapsulation = mkOption {
        type = encapsulationType;
        description = "Tunnel encapsulation advertised by this controller.";
      };

      settings = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          "ovn-remote" = "ssl:192.0.2.1:6642";
          "ovn-bridge" = "br-int";
          "ovn-bridge-mappings" = "provider:br-provider";
        };
        description = ''
          OVN controller settings written to the local Open vSwitch
          `external_ids` map. Keys use their upstream, unsuffixed names. The
          module appends the chassis name to every key.
        '';
      };

      tls = mkOption {
        type = types.nullOr tlsType;
        default = null;
        description = "TLS credentials used for connections to OVN databases.";
      };
    };
  };

  enabledInstances = lib.filterAttrs (_: instance: instance.enable) cfg.controller.instances;
  instanceList = lib.attrValues enabledInstances;
  ovnEnabled =
    cfg.northbound.enable
    || cfg.southbound.enable
    || cfg.relay.enable
    || cfg.northd.enable
    || cfg.controller.enable;

  enabledDatabases = lib.filter (database: database.enable) [
    cfg.northbound
    cfg.southbound
  ];
  enabledServers = enabledDatabases ++ lib.optional cfg.relay.enable cfg.relay;

  encapsulationPorts = {
    geneve = 6081;
    vxlan = 4789;
  };

  controllerFirewallPorts = map (type: encapsulationPorts.${type}) (
    lib.unique (lib.concatMap (instance: instance.encapsulation.types) instanceList)
  );

  nativeControllerSettingKeys = [
    "ovn-encap-ip"
    "ovn-encap-type"
  ];

  controllerExternalIds =
    lib.attrsToList cfg.controller.settings
    ++ lib.concatMap (
      instance:
      [
        {
          name = "ovn-encap-ip-${instance.chassisName}";
          value = lib.concatStringsSep "," instance.encapsulation.ips;
        }
        {
          name = "ovn-encap-type-${instance.chassisName}";
          value = lib.concatStringsSep "," instance.encapsulation.types;
        }
      ]
      ++ lib.mapAttrsToList (name: value: {
        name = "${name}-${instance.chassisName}";
        inherit value;
      }) instance.settings
    ) instanceList;

  databaseInfo = {
    northbound = {
      shortName = "nb";
      file = "${stateDir}/ovnnb_db.db";
      socket = "${runDir}/ovnnb_db.sock";
      serviceName = "ovn-northbound";
    };
    southbound = {
      shortName = "sb";
      file = "${stateDir}/ovnsb_db.db";
      socket = "${runDir}/ovnsb_db.sock";
      serviceName = "ovn-southbound";
    };
  };

  passiveRemote = listener: "p${listener.transport}:${toString listener.port}:${listener.address}";

  listenerRemotes =
    listeners:
    lib.listToAttrs (
      map (listener: {
        name = passiveRemote listener;
        value = lib.optionalAttrs ((listener.role or null) != null) {
          inherit (listener) role;
        };
      }) (lib.attrValues listeners)
    );

  mkDatabaseService =
    name:
    let
      database = cfg.${name};
      info = databaseInfo.${name};
      prefix = "db-${info.shortName}";
      serverConfig = jsonFormat.generate "${info.serviceName}.json" {
        remotes = {
          "punix:${info.socket}" = { };
        }
        // listenerRemotes database.listeners;
        databases = {
          "${info.file}" = { };
        };
      };
      raftArgs = lib.optionals (database.mode == "raft") (
        [
          "--${prefix}-cluster-local-addr=${database.raft.localAddress}"
          "--${prefix}-cluster-local-port=${toString database.raft.localPort}"
          "--${prefix}-cluster-local-proto=${database.raft.transport}"
        ]
        ++ lib.optionals (database.raft.bootstrap.mode == "join") [
          "--${prefix}-cluster-remote-addr=${database.raft.bootstrap.address}"
          "--${prefix}-cluster-remote-port=${toString database.raft.bootstrap.port}"
          "--${prefix}-cluster-remote-proto=${database.raft.transport}"
        ]
      );
      tlsArgs = lib.optionals (database.tls != null) [
        "--ovn-${info.shortName}-db-ssl-key=${database.tls.privateKey}"
        "--ovn-${info.shortName}-db-ssl-cert=${database.tls.certificate}"
        "--ovn-${info.shortName}-db-ssl-ca-cert=${database.tls.caCertificate}"
      ];
      ctlArgs = [
        "--no-monitor"
        "--${prefix}-config-file=${serverConfig}"
      ]
      ++ tlsArgs
      ++ raftArgs;
      ovnCtl = "${cfg.package}/share/ovn/scripts/ovn-ctl";
      startScript = pkgs.writeShellScript "start-${info.serviceName}" ''
        exec ${ovnCtl} ${lib.escapeShellArgs ctlArgs} start_${info.shortName}_ovsdb
      '';
      stopScript = pkgs.writeShellScript "stop-${info.serviceName}" ''
        exec ${ovnCtl} ${lib.escapeShellArgs ctlArgs} stop_${info.shortName}_ovsdb
      '';
    in
    {
      description = "OVN ${name} database";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = [ config.virtualisation.vswitch.package ];
      serviceConfig = {
        User = ovnUser;
        Group = ovnGroup;
        Type = "forking";
        PIDFile = "${runDir}/ovn${info.shortName}_db.pid";
        ExecStart = startScript;
        ExecStop = stopScript;
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStartSec = 120;
        StateDirectory = "ovn";
        LogsDirectory = "ovn";
      };
      # Raft joiners may start before their bootstrap peer. Keep retrying
      # instead of entering start-limit-hit during concurrent cluster boots.
      unitConfig.StartLimitIntervalSec = 0;
    };

  mkControllerService =
    name: instance:
    let
      tlsArgs = lib.optionals (instance.tls != null) [
        "--private-key=${instance.tls.privateKey}"
        "--certificate=${instance.tls.certificate}"
        "--ca-cert=${instance.tls.caCertificate}"
      ];
      args = [
        "-n"
        instance.chassisName
        "--unixctl=${runDir}/ovn-controller-${name}.ctl"
      ]
      ++ tlsArgs;
    in
    {
      description = "OVN controller ${name}";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "ovsdb-external-ids.service"
        # ovs-vswitchd is Type=forking, so this waits for daemonization. The
        # controller reconnects gracefully if its bridge socket appears later.
        "ovs-vswitchd.service"
      ];
      wants = [ "network-online.target" ];
      requires = [
        "ovsdb-external-ids.service"
        "ovs-vswitchd.service"
      ];
      serviceConfig = {
        User = ovnUser;
        Group = ovnGroup;
        # ovn-controller communicates with OVS through its Unix sockets.
        SupplementaryGroups = [ "openvswitch" ];
        ExecStart = utils.escapeSystemdExecArgs ([ (lib.getExe' cfg.package "ovn-controller") ] ++ args);
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

  sslListenerConfigured =
    database: lib.any (listener: listener.transport == "ssl") (lib.attrValues database.listeners);

in
{
  options.services.ovn = {
    package = lib.mkPackageOption pkgs "ovn" { };

    northbound = mkDatabaseOptions {
      name = "northbound";
      clientPort = 6641;
      clusterPort = 6643;
    };

    southbound = mkDatabaseOptions {
      name = "southbound";
      clientPort = 6642;
      clusterPort = 6644;
      southbound = true;
    };

    relay = {
      enable = lib.mkEnableOption "a colocated OVN southbound relay for chassis connections";

      listeners = mkOption {
        type = types.attrsOf (mkListenerType {
          defaultPort = 6642;
          southbound = true;
        });
        default = { };
        description = ''
          Chassis-facing listeners. The relay enforces their RBAC roles before
          forwarding writes to the local southbound database's Unix socket.
        '';
      };

      tls = mkOption {
        type = types.nullOr tlsType;
        default = null;
        description = ''
          TLS credentials for chassis connections. Configure a chassis CA
          separate from the control-plane CA trusted by the database servers.
        '';
      };
    };

    northd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run `ovn-northd`.";
      };

      northbound = mkOption {
        type = types.nonEmptyStr;
        default = "unix:${databaseInfo.northbound.socket}";
        description = "Northbound database remote used by `ovn-northd`.";
      };

      southbound = mkOption {
        type = types.nonEmptyStr;
        default = "unix:${databaseInfo.southbound.socket}";
        description = "Southbound database remote used by `ovn-northd`.";
      };

      tls = mkOption {
        type = types.nullOr tlsType;
        default = null;
        description = "TLS credentials used for SSL database remotes.";
      };
    };

    controller = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run configured OVN controller instances.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the standard UDP ports for the configured Geneve
          and VXLAN encapsulation types in the firewall. Custom tunnel ports
          must be opened separately.
        '';
      };

      settings = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = ''
          Host-global OVN controller settings written to the local Open
          vSwitch `external_ids` map. Keys use their upstream names.
        '';
      };

      instances = mkOption {
        type = types.attrsOf controllerInstanceType;
        default = { };
        description = "OVN controller instances running on this host.";
      };
    };
  };

  config = lib.mkMerge [
    {
      users = lib.mkIf ovnEnabled {
        users.${ovnUser} = {
          isSystemUser = true;
          group = ovnGroup;
        };
        groups.${ovnGroup} = { };
      };

      systemd.tmpfiles.rules = lib.mkIf ovnEnabled [
        "d ${runDir} 0750 ${ovnUser} ${ovnGroup} -"
      ];

      networking.firewall.allowedTCPPorts = lib.unique (
        lib.concatMap (
          server:
          map (listener: listener.port) (
            lib.filter (listener: listener.openFirewall) (lib.attrValues server.listeners)
          )
        ) enabledServers
        ++ map (database: database.raft.localPort) (
          lib.filter (database: database.mode == "raft" && database.raft.openFirewall) enabledDatabases
        )
      );

      assertions =
        let
          southboundServers = lib.filter (server: server.enable) [
            cfg.southbound
            cfg.relay
          ];
          chassisNames = map (instance: instance.chassisName) instanceList;
          integrationBridges = map (instance: instance.settings."ovn-bridge" or null) instanceList;
          externalIdKeys = map (setting: setting.name) controllerExternalIds;
          listenerTargets = database: map passiveRemote (lib.attrValues database.listeners);
        in
        [
          {
            assertion = cfg.relay.enable -> cfg.southbound.enable;
            message = "The OVN relay requires the local southbound database.";
          }
          {
            assertion = lib.all (
              database: database.mode == "raft" -> database.raft.localAddress != null
            ) enabledDatabases;
            message = "OVN Raft databases require raft.localAddress.";
          }
          {
            assertion = lib.all (
              database:
              (database.mode == "raft" && database.raft.bootstrap.mode == "join")
              -> database.raft.bootstrap.address != null
            ) enabledDatabases;
            message = "OVN Raft databases in join mode require raft.bootstrap.address.";
          }
          {
            assertion = lib.all (server: sslListenerConfigured server -> server.tls != null) enabledServers;
            message = "OVN SSL listeners require TLS credentials.";
          }
          {
            assertion = lib.all (server: lib.allUnique (listenerTargets server)) enabledServers;
            message = "OVN database listeners must use distinct connection methods.";
          }
          {
            assertion = lib.all (
              database: (database.mode == "raft" && database.raft.transport == "ssl") -> database.tls != null
            ) enabledDatabases;
            message = "OVN Raft databases using SSL require TLS credentials.";
          }
          {
            assertion = lib.all (
              server:
              lib.all (listener: listener.role != null -> listener.transport == "ssl") (
                lib.attrValues server.listeners
              )
            ) southboundServers;
            message = ''
              OVN southbound listeners with an RBAC role must use SSL because
              RBAC authenticates clients by their certificate common name.
            '';
          }
          {
            assertion = lib.all (
              server:
              let
                listeners = lib.attrValues server.listeners;
              in
              !(
                lib.any (listener: listener.role == null) listeners
                && lib.any (listener: listener.role != null) listeners
              )
            ) southboundServers;
            message = ''
              OVN restricted and unrestricted listeners must use separate servers.
              Use a colocated relay with a separate chassis CA.
            '';
          }
          {
            assertion = cfg.controller.enable -> lib.allUnique chassisNames;
            message = "OVN controller chassis names must be unique.";
          }
          {
            assertion =
              cfg.controller.enable
              -> lib.all (
                settings: lib.intersectLists nativeControllerSettingKeys (lib.attrNames settings) == [ ]
              ) ([ cfg.controller.settings ] ++ map (instance: instance.settings) instanceList);
            message = ''
              OVN controller settings may not contain ${lib.concatStringsSep ", " nativeControllerSettingKeys};
              use the native encapsulation option instead.
            '';
          }
          {
            assertion =
              cfg.controller.enable
              -> lib.all (instance: !(builtins.hasAttr "system-id" instance.settings)) instanceList;
            message = "OVN controller settings may not contain system-id.";
          }
          {
            assertion = cfg.controller.enable -> lib.allUnique externalIdKeys;
            message = ''
              OVN controller Open vSwitch external IDs and generated
              per-controller external IDs must not use the same key.
            '';
          }
          {
            assertion =
              cfg.controller.enable
              -> (
                lib.length instanceList <= 1
                || (lib.all (bridge: bridge != null) integrationBridges && lib.allUnique integrationBridges)
              );
            message = "Co-hosted OVN controllers require distinct ovn-bridge settings.";
          }
          {
            assertion =
              cfg.controller.enable
              -> lib.all (
                instance: lib.hasInfix "ssl:" (instance.settings."ovn-remote" or "") -> instance.tls != null
              ) instanceList;
            message = "OVN controllers using SSL remotes require TLS credentials.";
          }
          {
            assertion =
              (
                cfg.northd.enable
                && (lib.hasInfix "ssl:" cfg.northd.northbound || lib.hasInfix "ssl:" cfg.northd.southbound)
              )
              -> cfg.northd.tls != null;
            message = "ovn-northd using SSL remotes requires TLS credentials.";
          }
        ];
    }

    (lib.mkIf (cfg.northbound.enable || cfg.southbound.enable || cfg.northd.enable) {
      environment.systemPackages = [ cfg.package ];

      systemd.services =
        lib.optionalAttrs cfg.northbound.enable {
          ovn-northbound = mkDatabaseService "northbound";
        }
        // lib.optionalAttrs cfg.southbound.enable {
          ovn-southbound = mkDatabaseService "southbound";
        }
        // lib.optionalAttrs cfg.northd.enable {
          ovn-northd = {
            description = "OVN central control daemon";
            wantedBy = [ "multi-user.target" ];
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            serviceConfig = {
              User = ovnUser;
              Group = ovnGroup;
              ExecStart = utils.escapeSystemdExecArgs (
                [ (lib.getExe' cfg.package "ovn-northd") ]
                ++ [
                  "--ovnnb-db=${cfg.northd.northbound}"
                  "--ovnsb-db=${cfg.northd.southbound}"
                  "--unixctl=${runDir}/ovn-northd.ctl"
                ]
                ++ lib.optionals (cfg.northd.tls != null) [
                  "--private-key=${cfg.northd.tls.privateKey}"
                  "--certificate=${cfg.northd.tls.certificate}"
                  "--ca-cert=${cfg.northd.tls.caCertificate}"
                ]
              );
              Restart = "on-failure";
              RestartSec = 1;
            };
          };
        };
    })

    (lib.mkIf cfg.relay.enable {
      environment.systemPackages = [ cfg.package ];

      systemd.services.ovn-relay =
        let
          serverConfig = jsonFormat.generate "ovn-relay.json" {
            remotes = listenerRemotes cfg.relay.listeners;
            databases.OVN_Southbound = {
              service-model = "relay";
              source."unix:${databaseInfo.southbound.socket}" = { };
            };
          };
        in
        {
          description = "OVN southbound relay";
          wantedBy = [ "multi-user.target" ];
          wants = [ "ovn-southbound.service" ];
          after = [ "ovn-southbound.service" ];
          serviceConfig = {
            User = ovnUser;
            Group = ovnGroup;
            ExecStart = utils.escapeSystemdExecArgs (
              [
                (lib.getExe' config.virtualisation.vswitch.package "ovsdb-server")
                "--config-file=${serverConfig}"
                "--unixctl=${runDir}/ovn-relay.ctl"
              ]
              ++ lib.optionals (cfg.relay.tls != null) [
                "--private-key=${cfg.relay.tls.privateKey}"
                "--certificate=${cfg.relay.tls.certificate}"
                "--ca-cert=${cfg.relay.tls.caCertificate}"
              ]
            );
            Restart = "on-failure";
            RestartSec = 1;
          };
        };
    })

    (lib.mkIf cfg.controller.enable {
      virtualisation.vswitch.enable = true;
      virtualisation.vswitch.externalIds = builtins.listToAttrs controllerExternalIds;
      environment.systemPackages = [ cfg.package ];
      networking.firewall.allowedUDPPorts = lib.mkIf cfg.controller.openFirewall controllerFirewallPorts;

      systemd.services = lib.mapAttrs' (
        name: instance: lib.nameValuePair "ovn-controller-${name}" (mkControllerService name instance)
      ) enabledInstances;
    })
  ];

  meta = {
    doc = ./ovn.md;
    maintainers = pkgs.ovn.meta.maintainers;
  };
}
