{ config, pkgs, lib, ... }:
let
  cfg = config.services.veilid;
  dataDir = "/var/lib/veilid";

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "veilid.yaml" cfg.settings;
in {
  config = lib.mkIf cfg.enable {
    networking = {
      firewall = {
        allowedTCPPorts = [ 5150 ];
        allowedUDPPorts = [ 5150 ];
      };
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
    enable = lib.mkEnableOption "veilid";
    settings = lib.mkOption {

      type = lib.types.attrsOf (lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          daemon = {
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            pid_file = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            chroot = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            working_directory = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            user = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            group = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            stdout_file = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
            stderr_file = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
          };
          client_api = {
            ipc_enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
            ipc_directory = lib.mkOption {
              type = lib.types.str;
              default =
                "/home/${config.users.users.veilid.name}/.local/share/veilid/ipc";
            };
            network_enabled = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            listen_address = lib.mkOption {
              type = lib.types.str;
              default = "localhost:5959";
            };
          };
          auto_attach = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          logging = {
            system = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              level = lib.mkOption {
                type = lib.types.str;
                default = "info";
              };
              ignore_log_targets = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
            };
            terminal = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              level = lib.mkOption {
                type = lib.types.str;
                default = "info";
              };
              ignore_log_targets = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
            };
            file = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              path = lib.mkOption {
                type = lib.types.str;
                default = "";
              };
              append = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
              level = lib.mkOption {
                type = lib.types.str;
                default = "info";
              };
              ignore_log_targets = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
            };
            api = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              level = lib.mkOption {
                type = lib.types.str;
                default = "info";
              };
              ignore_log_targets = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
            };
            otlp = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
              level = lib.mkOption {
                type = lib.types.str;
                default = "trace";
              };
              grpc_endpoint = lib.mkOption {
                type = lib.types.str;
                default = "localhost:4317";
              };
              ignore_log_targets = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
            };
            console = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
            };
          };
          testing = {
            subnode_index = lib.mkOption {
              type = lib.types.number;
              default = 0;
            };
          };
          core = {
            capabilities = {
              disable = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
              };
            };
            protected_store = {
              allow_insecure_fallback = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
              always_use_insecure_storage = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
              directory = lib.mkOption {
                type = lib.types.str;
                default =
                  "/home/${config.users.users.veilid.name}/.local/share/veilid/protected_store";
              };
              delete = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
              device_encryption_key_password = lib.mkOption {
                type = lib.types.str;
                default =
                  "/home/${config.users.users.veilid.name}/.local/share/veilid/protected_store";
              };
              new_device_encryption_key_password = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
            };
            table_store = {
              directory = lib.mkOption {
                type = lib.types.str;
                default =
                  "/home/${config.users.users.veilid.name}/.local/share/veilid/table_store";
              };
              delete = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
            };
            block_store = {
              directory = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default =
                  "/home/${config.users.users.veilid.name}/.local/share/veilid/block_store";
              };
              delete = lib.mkOption {
                type = lib.types.bool;
                default = false;
              };
            };
            network = {
              connection_initial_timeout_ms = lib.mkOption {
                type = lib.types.number;
                default = 2000;
              };
              connection_inactivity_timeout_ms = lib.mkOption {
                type = lib.types.number;
                default = 60000;
              };
              max_connections_per_ip4 = lib.mkOption {
                type = lib.types.number;
                default = 32;
              };
              max_connections_per_ip6_prefix = lib.mkOption {
                type = lib.types.number;
                default = 32;
              };
              max_connections_per_ip6_prefix_size = lib.mkOption {
                type = lib.types.number;
                default = 56;
              };
              max_connection_frequency_per_min = lib.mkOption {
                type = lib.types.number;
                default = 128;
              };
              client_allowlist_timeout_ms = lib.mkOption {
                type = lib.types.number;
                default = 300000;
              };
              reverse_connection_receipt_time_ms = lib.mkOption {
                type = lib.types.number;
                default = 5000;
              };
              network_key_password = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
            };
            routing_table = {
              node_id = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              node_id_secret = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              bootstrap = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ "bootstrap.veilid.net" ];
              };
              limit_over_attached = lib.mkOption {
                type = lib.types.number;
                default = 64;
              };
              limit_fully_attached = lib.mkOption {
                type = lib.types.number;
                default = 32;
              };
              limit_attached_strong = lib.mkOption {
                type = lib.types.number;
                default = 32;
              };
              limit_attached_good = lib.mkOption {
                type = lib.types.number;
                default = 8;
              };
              limit_attached_weak = lib.mkOption {
                type = lib.types.number;
                default = 4;
              };
            };
            rpc = {
              concurrency = lib.mkOption {
                type = lib.types.number;
                default = 0;
              };
              queue_size = lib.mkOption {
                type = lib.types.number;
                default = 1024;
              };
              max_timestamp_behind_ms = lib.mkOption {
                type = lib.types.number;
                default = 10000;
              };
              max_timestamp_ahead_ms = lib.mkOption {
                type = lib.types.number;
                default = 10000;
              };
              timeout_ms = lib.mkOption {
                type = lib.types.number;
                default = 5000;
              };
              max_route_hop_count = lib.mkOption {
                type = lib.types.number;
                default = 4;
              };
              default_route_hop_count = lib.mkOption {
                type = lib.types.number;
                default = 1;
              };
            };
            dht = {
              max_find_node_count = lib.mkOption {
                type = lib.types.number;
                default = 20;
              };
              resolve_node_timeout_ms = lib.mkOption {
                type = lib.types.number;
                default = 10000;
              };
              resolve_node_count = lib.mkOption {
                type = lib.types.number;
                default = 1;
              };
              resolve_node_fanout = lib.mkOption {
                type = lib.types.number;
                default = 4;
              };
              get_value_timeout_ms = lib.mkOption {
                type = lib.types.number;
                default = 10000;
              };
              get_value_count = lib.mkOption {
                type = lib.types.number;
                default = 3;
              };
              get_value_fanout = lib.mkOption {
                type = lib.types.number;
                default = 4;
              };
              set_value_timeout_ms = lib.mkOption {
                type = lib.types.number;
                default = 10000;
              };
              set_value_count = lib.mkOption {
                type = lib.types.number;
                default = 5;
              };
              set_value_fanout = lib.mkOption {
                type = lib.types.number;
                default = 4;
              };
              min_peer_count = lib.mkOption {
                type = lib.types.number;
                default = 20;
              };
              min_peer_refresh_time_ms = lib.mkOption {
                type = lib.types.number;
                default = 60000;
              };
              validate_dial_info_receipt_time_ms = lib.mkOption {
                type = lib.types.number;
                default = 2000;
              };
              local_subkey_cache_size = lib.mkOption {
                type = lib.types.number;
                default = 128;
              };
              local_max_subkey_cache_memory_mb = lib.mkOption {
                type = lib.types.number;
                default = 256;
              };
              remote_subkey_cache_size = lib.mkOption {
                type = lib.types.number;
                default = 1024;
              };
              remote_max_records = lib.mkOption {
                type = lib.types.number;
                default = 65536;
              };
              remote_max_subkey_cache_memory_mb = lib.mkOption {
                type = lib.types.number;
                default = 2552;
              };
              remote_max_storage_space_mb = lib.mkOption {
                type = lib.types.number;
                default = 10000;
              };
              public_watch_limit = lib.mkOption {
                type = lib.types.number;
                default = 32;
              };
              member_watch_limit = lib.mkOption {
                type = lib.types.number;
                default = 8;
              };
              max_watch_expiration_ms = lib.mkOption {
                type = lib.types.number;
                default = 600000;
              };
            };
            upnp = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
            detect_address_changes = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
            restricted_nat_retries = lib.mkOption {
              type = lib.types.number;
              default = 0;
            };
            tls = {
              certificate_path = lib.mkOption {
                type = lib.types.str;
                default =
                  "/home/${config.users.users.veilid.name}/.local/share/veilid/protected_store";
              };
              private_key_path = lib.mkOption {
                type = lib.types.str;
                default =
                  "/home/${config.users.users.veilid.name}/.local/share/veilid/protected_store";
              };
              connection_initial_timeout_ms = lib.mkOption {
                type = lib.types.number;
                default = 2000;
              };
            };
            application = {
              https = {
                enabled = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                listen_address = lib.mkOption {
                  type = lib.types.str;
                  default = ":433";
                };

                path = lib.mkOption {
                  type = lib.types.str;
                  default = "app";
                };
                url = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
              };
            };
            protocol = {
              udp = {
                enabled = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                socket_pool_size = lib.mkOption {
                  type = lib.types.number;
                  default = 0;
                };
                listen_address = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                };
                public_address = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
              };
              tcp = {
                connect = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                listen = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                max_connections = lib.mkOption {
                  type = lib.types.number;
                  default = 32;
                };
                listen_address = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                };
                public_address = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
              };
              ws = {
                connect = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                listen = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                max_connections = lib.mkOption {
                  type = lib.types.number;
                  default = 32;
                };
                listen_address = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                };

                path = lib.mkOption {
                  type = lib.types.str;
                  default = "ws";
                };
                url = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
              };
              wss = {
                connect = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                listen = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                max_connections = lib.mkOption {
                  type = lib.types.number;
                  default = 32;
                };
                listen_address = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                };

                path = lib.mkOption {
                  type = lib.types.str;
                  default = "ws";
                };
                url = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
              };
            };
          };
        };
      });
    };
  };

}
