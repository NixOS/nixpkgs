{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.veilid;
  dataDir = "/var/lib/veilid";

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "veilid.yaml" cfg.settings;
in {
  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
        allowedTCPPorts = [ 5150 ];
        allowedUDPPorts = [ 5150 ];
    };

    systemd.services.veilid = {
      enable = true;
      description = "Veilid Network Service";
      after = [ "network-pre.target" ];
      wants = [ "network.target" ];
      before = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];
      environment = { HOME = dataDir; };
      serviceConfig = {
        User = "veilid";
        Restart = "always";
        StateDirectory = "veilid";
        RuntimeDirectory = "veilid";
        ExecStart = "${pkgs.veilid}/bin/veilid-server -c ${configFile}";
      };
    };
    users.users.veilid = { isSystemUser = true; };

    users.users.veilid.group = "veilid";
    users.groups.veilid = { };

    environment = {
      etc."veilid/veilid-server.conf".source = configFile;
      systemPackages = [ pkgs.veilid ];
    };
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
        Check [Configuration Keys](https://veilid.gitlab.io/developer-book/admin/config.html#configuration-keys).
      '';
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          client_api = {
            ipc_enabled = mkOption {
              type = types.bool;
              default = true;
              description =
                "veilid-server will respond to Python and other JSON client requests.";
            };
            ipc_directory = mkOption {
              type = types.str;
              default = "${dataDir}/ipc";
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
                description =
                  "The minimum priority of system events to be logged.";
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
                description =
                  "The minimum priority of terminal events to be logged.";
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
                description =
                  "The minimum priority of api events to be logged.";
              };
            };
          };
          core = {
            capabilities = {
              disable = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description =
                  "A list of capabilities to disable (for example, DHTV to say you cannot store DHT information).";
              };
            };
            protected_store = {
              allow_insecure_fallback = mkOption {
                type = types.bool;
                default = true;
                description =
                  "If we can't use system-provided secure storage, should we proceed anyway?";
              };
              always_use_insecure_storage = mkOption {
                type = types.bool;
                default = true;
                description =
                  "Should we bypass any attempt to use system-provided secure storage?";
              };
              directory = mkOption {
                type = types.str;
                default = "${dataDir}/protected_store";
                description =
                  "The filesystem directory to store your protected store in.";
              };
            };
            table_store = {
              directory = mkOption {
                type = types.str;
                default = "${dataDir}/table_store";
                description =
                  "The filesystem directory to store your table store within.";
              };
            };
            block_store = {
              directory = mkOption {
                type = types.nullOr types.str;
                default = "${dataDir}/block_store";
                description =
                  "The filesystem directory to store blocks for the block store.";
              };
            };
            network = {
            routing_table = {
                bootstrap = mkOption {
                  type = types.listOf types.str;
                default = [ "bootstrap.veilid.net" ];
                  description =
                    "Host name of existing well-known Veilid bootstrap servers for the network to connect to.";
                };
              };
              dht = {
                min_peer_count = mkOption {
                  type = types.number;
                  default = 20;
                  description =
                    "Minimum number of nodes to keep in the peer table.";
                };
              };
              upnp = mkOption {
                type = types.bool;
                  default = true;
                description =
                  "Should the app try to improve its incoming network connectivity using UPnP?";
              };
              detect_address_changes = mkOption {
                type = types.bool;
                  default = true;
                description =
                  "Should veilid-core detect and notify on network address changes?";
              };
            };
          };
        };
      };
    };
  };

  meta.maintainers = with maintainers; [ figboy9 ];
}
