{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.veilid;
  dataDir = "/var/db/veilid-server";

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "veilid-server.conf" cfg.settings;
in
{
  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 5150 ];
      allowedUDPPorts = [ 5150 ];
    };

    # Based on https://gitlab.com/veilid/veilid/-/blob/main/package/systemd/veilid-server.service?ref_type=heads
    systemd.services.veilid = {
      enable = true;
      description = "Veilid Headless Node";
      wants = [ "network-online.target" ];
      before = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];
      environment = {
        RUST_BACKTRACE = "1";
      };
      serviceConfig = {
        ExecStart = "${pkgs.veilid}/bin/veilid-server -c ${configFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -s HUP $MAINPID";
        KillSignal = "SIGQUIT";
        TimeoutStopSec = 5;
        WorkingDirectory = "/";
        User = "veilid";
        Group = "veilid";
        UMask = "0002";

        CapabilityBoundingSet = "";
        SystemCallFilter = [ "@system-service" ];
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = dataDir;

        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        LockPersonality = true;
        RestrictSUIDSGID = true;
      };
    };
    users.users.veilid = {
      isSystemUser = true;
      group = "veilid";
      home = dataDir;
      createHome = true;
    };
    users.groups.veilid = { };

    environment = {
      systemPackages = [ pkgs.veilid ];
    };
    services.veilid.settings = { };
  };

  options.services.veilid = {
    enable = mkEnableOption "Veilid Headless Node";
    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open firewall on ports 5150/tcp, 5150/udp";
    };
    settings = mkOption {
      description = ''
        Build veilid-server.conf with nix expression.
        Check <link xlink:href="https://veilid.gitlab.io/developer-book/admin/config.html#configuration-keys">Configuration Keys</link>.
      '';
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          client_api = {
            ipc_enabled = mkOption {
              type = types.bool;
              default = true;
              description = "veilid-server will respond to Python and other JSON client requests.";
            };
            ipc_directory = mkOption {
              type = types.str;
              default = "${dataDir}/ipc";
              description = "IPC directory where file sockets are stored.";
            };
          };
          logging = {
            system = {
              enabled = mkOption {
                type = types.bool;
                default = true;
                description = "Events of type 'system' will be logged.";
              };
              level = mkOption {
                type = types.str;
                default = "info";
                example = "debug";
                description = "The minimum priority of system events to be logged.";
              };
            };
            terminal = {
              enabled = mkOption {
                type = types.bool;
                default = false;
                description = "Events of type 'terminal' will be logged.";
              };
              level = mkOption {
                type = types.str;
                default = "info";
                example = "debug";
                description = "The minimum priority of terminal events to be logged.";
              };
            };
            api = {
              enabled = mkOption {
                type = types.bool;
                default = false;
                description = "Events of type 'api' will be logged.";
              };
              level = mkOption {
                type = types.str;
                default = "info";
                example = "debug";
                description = "The minimum priority of api events to be logged.";
              };
            };
          };
          core = {
            capabilities = {
              disable = mkOption {
                type = types.listOf types.str;
                default = [ ];
                example = [ "APPM" ];
                description = "A list of capabilities to disable (for example, DHTV to say you cannot store DHT information).";
              };
            };
            protected_store = {
              allow_insecure_fallback = mkOption {
                type = types.bool;
                default = true;
                description = "If we can't use system-provided secure storage, should we proceed anyway?";
              };
              always_use_insecure_storage = mkOption {
                type = types.bool;
                default = true;
                description = "Should we bypass any attempt to use system-provided secure storage?";
              };
              directory = mkOption {
                type = types.str;
                default = "${dataDir}/protected_store";
                description = "The filesystem directory to store your protected store in.";
              };
            };
            table_store = {
              directory = mkOption {
                type = types.str;
                default = "${dataDir}/table_store";
                description = "The filesystem directory to store your table store within.";
              };
            };
            block_store = {
              directory = mkOption {
                type = types.nullOr types.str;
                default = "${dataDir}/block_store";
                description = "The filesystem directory to store blocks for the block store.";
              };
            };
            network = {
              routing_table = {
                bootstrap = mkOption {
                  type = types.listOf types.str;
                  default = [ "bootstrap.veilid.net" ];
                  description = "Host name of existing well-known Veilid bootstrap servers for the network to connect to.";
                };
                node_id = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Base64-encoded public key for the node, used as the node's ID.";
                };
              };
              dht = {
                min_peer_count = mkOption {
                  type = types.number;
                  default = 20;
                  description = "Minimum number of nodes to keep in the peer table.";
                };
              };
              upnp = mkOption {
                type = types.bool;
                default = true;
                description = "Should the app try to improve its incoming network connectivity using UPnP?";
              };
              detect_address_changes = mkOption {
                type = types.bool;
                default = true;
                description = "Should veilid-core detect and notify on network address changes?";
              };
            };
          };
        };
      };
    };
  };

  meta.maintainers = with maintainers; [ figboy9 ];
}
