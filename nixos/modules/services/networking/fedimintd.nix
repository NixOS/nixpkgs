{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatLists
    filterAttrs
    mapAttrs'
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    mkOverride
    mkPackageOption
    nameValuePair
    recursiveUpdate
    types
    ;

  fedimintdOpts =
    {
      config,
      lib,
      name,
      ...
    }:
    {
      imports = [
        ../../misc/assertions.nix
        (lib.mkRenamedOptionModule [ "bitcoin" "rpc" "secretFile" ] [ "bitcoin" "bitcoindSecretFile" ])
        (lib.mkRemovedOptionModule [ "bitcoin" "rpc" "url" ] ''
          Fedimint 0.10 no longer has a generic Bitcoin RPC URL. Set
          `bitcoin.bitcoindUrl` and `bitcoin.bitcoindUser` for bitcoind, or
          `bitcoin.esploraUrl` for Esplora. URLs with embedded credentials are
          not supported; use `bitcoin.bitcoindSecretFile` for the password.
        '')
        (lib.mkRemovedOptionModule [ "bitcoin" "rpc" "kind" ] ''
          Fedimint 0.10 selects its Bitcoin backend from `bitcoin.bitcoindUrl`
          and `bitcoin.esploraUrl`. The Electrum backend is no longer
          supported.
        '')
      ];

      options = {
        enable = mkEnableOption "fedimintd";

        package = mkPackageOption pkgs "fedimint" { };

        environment = mkOption {
          type = types.attrsOf types.str;
          description = "Extra Environment variables to pass to the fedimintd.";
          default = {
            RUST_BACKTRACE = "1";
            RUST_LIB_BACKTRACE = "0";
          };
          example = {
            RUST_LOG = "info,fm=debug";
            RUST_BACKTRACE = "1";
            RUST_LIB_BACKTRACE = "0";
          };
        };

        p2p = {
          openFirewall = mkOption {
            type = types.bool;
            default = true;
            description = "Opens the TCP p2p port for a TCP federation, or the UDP p2p port when Iroh is selected during initial federation setup.";
          };
          port = mkOption {
            type = types.port;
            default = 8173;
            description = "Port to bind on for p2p connections from peers (TCP, and UDP when Iroh is selected during initial federation setup).";
          };
          bind = mkOption {
            type = types.str;
            default = "0.0.0.0";
            description = "Address to bind on for p2p connections from peers (both TCP and UDP)";
          };
          url = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "fedimint://p2p.myfedimint.com:8173";
            description = ''
              Public address for p2p connections from peers (if TCP is used)
            '';
          };
        };
        api_ws = {
          openFirewall = mkOption {
            type = types.bool;
            default = false;
            description = "Opens TCP port in firewall for fedimintd's Websocket API";
          };
          port = mkOption {
            type = types.port;
            default = 8174;
            description = "TCP Port to bind on for API connections relayed by the reverse proxy/tls terminator.";
          };
          bind = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Address to bind on for API connections relied by the reverse proxy/tls terminator.";
          };
          url = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Public URL of the API address of the reverse proxy/tls terminator. Usually starting with `wss://`.
            '';
          };
        };
        api_iroh = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Selects Iroh for both API and P2P transport during initial federation setup.
              Fedimint persists this choice in the federation configuration, so do not change
              it for an existing federation. Set it to false only when creating a new TCP
              federation; this requires public `p2p.url` and `api_ws.url` values.
            '';
          };
          openFirewall = mkOption {
            type = types.bool;
            default = false;
            description = "Opens UDP port in firewall for Fedimint's Iroh API endpoint.";
          };
          port = mkOption {
            type = types.port;
            default = 8174;
            description = "UDP port for the Iroh API endpoint. It must match the WebSocket API port.";
          };
          bind = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Address for the Iroh API endpoint. It must match the WebSocket API bind address.";
          };
        };
        ui = {
          openFirewall = mkOption {
            type = types.bool;
            default = false;
            description = "Opens TCP port in firewall for built-in UI";
          };
          port = mkOption {
            type = types.port;
            default = 8175;
            description = "TCP Port to bind on for UI connections";
          };
          bind = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Address to bind on for UI connections";
          };
        };
        metrics = {
          openFirewall = mkOption {
            type = types.bool;
            default = false;
            description = "Opens the TCP port in the firewall for Fedimint metrics.";
          };
          port = mkOption {
            type = types.port;
            default = 8176;
            description = "TCP port to bind for Fedimint metrics. Each enabled instance needs a unique metrics port.";
          };
          bind = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Address to bind for Fedimint metrics.";
          };
        };
        bitcoin = {
          network = mkOption {
            type = types.str;
            default = "signet";
            example = "bitcoin";
            description = "Bitcoin network to participate in.";
          };

          bitcoindUrl = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "http://127.0.0.1:38332";
            description = "Bitcoind RPC URL without embedded credentials.";
          };

          bitcoindUser = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "bitcoin";
            description = "Bitcoind RPC user";
          };

          bitcoindSecretFile = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Runtime file containing the bitcoind RPC password. Fedimint reads this file at
              runtime, so its contents do not enter the Nix store. This is not a bitcoind
              cookie file.
            '';
          };

          esploraUrl = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "https://mempool.space/signet/api";
            description = "Esplora HTTP API base URL.";
          };

        };

        consensus.finalityDelay = mkOption {
          type = types.ints.unsigned;
          default = 10;
          description = "Consensus peg-in finality delay.";
        };

        dataDir = mkOption {
          type = types.path;
          default = "/var/lib/fedimintd-${name}/";
          readOnly = true;
          description = ''
            Path to the data dir fedimintd will use to store its data.
            Note that due to using the DynamicUser feature of systemd, this value should not be changed
            and is set to be read only.
          '';
        };

        nginx = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Whether to configure nginx for fedimintd
            '';
          };
          fqdn = mkOption {
            type = types.str;
            example = "api.myfedimint.com";
            description = "Public domain of the API address of the reverse proxy/tls terminator.";
          };
          path_ui = mkOption {
            type = types.str;
            example = "/";
            default = "/";
            description = "Path to host the built-in UI on and forward to the daemon's api port";
          };
          path_ws = mkOption {
            type = types.str;
            example = "/";
            default = "/ws/";
            description = "Path to host the API on and forward to the daemon's api port";
          };
          config = mkOption {
            type = types.submodule (
              recursiveUpdate (import ../web-servers/nginx/vhost-options.nix {
                inherit config lib;
              }) { }
            );
            default = { };
            description = "Overrides to the nginx vhost section for api";
          };
        };
      };
    };
in
{
  options = {
    services.fedimintd = mkOption {
      type = types.attrsOf (types.submodule fedimintdOpts);
      default = { };
      description = "Specification of one or more fedimintd instances.";
    };
  };

  config =
    let
      eachFedimintd = filterAttrs (fedimintdName: cfg: cfg.enable) config.services.fedimintd;
      eachFedimintdNginx = filterAttrs (fedimintdName: cfg: cfg.nginx.enable) eachFedimintd;
    in
    mkIf (eachFedimintd != { }) {

      assertions =
        concatLists (
          mapAttrsToList (fedimintdName: cfg: [
            {
              assertion =
                (cfg.bitcoin.bitcoindUrl == null)
                || (cfg.bitcoin.bitcoindUser != null && cfg.bitcoin.bitcoindSecretFile != null);
              message = "Fedimintd instance '${fedimintdName}' requires bitcoindUser and bitcoindSecretFile when bitcoindUrl is set.";
            }
            {
              assertion = cfg.bitcoin.bitcoindUrl != null || cfg.bitcoin.esploraUrl != null;
              message = "Fedimintd instance '${fedimintdName}' requires bitcoindUrl or esploraUrl.";
            }
            {
              assertion =
                !cfg.api_iroh.enable
                || (cfg.api_iroh.bind == cfg.api_ws.bind && cfg.api_iroh.port == cfg.api_ws.port);
              message = "Fedimintd instance '${fedimintdName}' requires api_iroh.bind and api_iroh.port to match api_ws because Fedimint 0.10 shares one API listener.";
            }
            {
              assertion = !cfg.api_iroh.openFirewall || cfg.api_iroh.enable;
              message = "Fedimintd instance '${fedimintdName}' cannot open the Iroh firewall port when api_iroh is disabled.";
            }
            {
              assertion = cfg.api_iroh.enable || (cfg.p2p.url != null && cfg.api_ws.url != null);
              message = "Fedimintd instance '${fedimintdName}' requires p2p.url and api_ws.url when api_iroh is disabled for TCP transport.";
            }
            {
              assertion = !(cfg.environment ? FM_BIND_METRICS);
              message = "Fedimintd instance '${fedimintdName}' must use metrics.bind and metrics.port instead of environment.FM_BIND_METRICS.";
            }
          ]) eachFedimintd
        )
        ++ [
          {
            assertion =
              builtins.length (lib.unique (mapAttrsToList (fedimintdName: cfg: cfg.metrics.port) eachFedimintd))
              == builtins.length (builtins.attrNames eachFedimintd);
            message = "Enabled Fedimintd instances require unique metrics.port values: ${
              lib.concatStringsSep ", " (
                mapAttrsToList (fedimintdName: cfg: "${fedimintdName} (${toString cfg.metrics.port})") eachFedimintd
              )
            }.";
          }
        ];

      networking.firewall.allowedTCPPorts = concatLists (
        mapAttrsToList (
          fedimintdName: cfg:
          (
            lib.optional cfg.api_ws.openFirewall cfg.api_ws.port
            ++ lib.optional (!cfg.api_iroh.enable && cfg.p2p.openFirewall) cfg.p2p.port
            ++ lib.optional cfg.ui.openFirewall cfg.ui.port
            ++ lib.optional cfg.metrics.openFirewall cfg.metrics.port
          )
        ) eachFedimintd
      );

      networking.firewall.allowedUDPPorts = concatLists (
        mapAttrsToList (
          fedimintdName: cfg:
          (
            lib.optional (cfg.api_iroh.enable && cfg.api_iroh.openFirewall) cfg.api_iroh.port
            ++ lib.optional (cfg.api_iroh.enable && cfg.p2p.openFirewall) cfg.p2p.port
          )
        ) eachFedimintd
      );

      systemd.services = mapAttrs' (
        fedimintdName: cfg:
        (nameValuePair "fedimintd-${fedimintdName}" {
          description = "Fedimint Server";
          documentation = [ "https://github.com/fedimint/fedimint/" ];
          wantedBy = [ "multi-user.target" ];
          environment = lib.mkMerge [
            {
              FM_BIND_P2P = "${cfg.p2p.bind}:${toString cfg.p2p.port}";
              FM_BIND_API = "${cfg.api_ws.bind}:${toString cfg.api_ws.port}";
              FM_BIND_UI = "${cfg.ui.bind}:${toString cfg.ui.port}";
              FM_DATA_DIR = cfg.dataDir;
              FM_BITCOIN_NETWORK = cfg.bitcoin.network;
            }

            (lib.optionalAttrs cfg.api_iroh.enable {
              FM_ENABLE_IROH = "true";
            })

            (lib.optionalAttrs (cfg.bitcoin.bitcoindUrl != null) {
              FM_BITCOIND_URL = cfg.bitcoin.bitcoindUrl;
              FM_BITCOIND_URL_PASSWORD_FILE = cfg.bitcoin.bitcoindSecretFile;
              FM_BITCOIND_USERNAME = cfg.bitcoin.bitcoindUser;
            })

            (lib.optionalAttrs (cfg.bitcoin.esploraUrl != null) {
              FM_ESPLORA_URL = cfg.bitcoin.esploraUrl;
            })

            (lib.optionalAttrs (cfg.p2p.url != null) {
              FM_P2P_URL = cfg.p2p.url;
            })

            (lib.optionalAttrs (cfg.api_ws.url != null) {
              FM_API_URL = cfg.api_ws.url;
            })

            (builtins.removeAttrs cfg.environment [ "FM_BIND_METRICS" ])

            {
              FM_BIND_METRICS = "${cfg.metrics.bind}:${toString cfg.metrics.port}";
            }
          ];
          serviceConfig = {
            DynamicUser = true;

            StateDirectory = "fedimintd-${fedimintdName}";
            StateDirectoryMode = "0700";
            ExecStart = "${cfg.package}/bin/fedimintd";

            Restart = "always";
            RestartSec = 10;
            UMask = "007";
            LimitNOFILE = "100000";

            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateMounts = true;
            PrivateTmp = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectSystem = "full";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_NETLINK"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
          };
          unitConfig = {
            StartLimitBurst = 5;
          };
        })
      ) eachFedimintd;

      services.nginx.virtualHosts = mapAttrs' (
        fedimintdName: cfg:
        (nameValuePair cfg.nginx.fqdn (
          lib.mkMerge [
            cfg.nginx.config

            {
              # Note: we want by default to enable OpenSSL, but it seems anything 100 and above is
              # overridden by default value from vhost-options.nix
              enableACME = mkOverride 99 true;
              forceSSL = mkOverride 99 true;
              locations.${cfg.nginx.path_ws} = {
                proxyPass = "http://127.0.0.1:${toString cfg.api_ws.port}/";
                proxyWebsockets = true;
                extraConfig = ''
                  proxy_pass_header Authorization;
                '';
              };
              locations.${cfg.nginx.path_ui} = {
                proxyPass = "http://127.0.0.1:${toString cfg.ui.port}/";
                extraConfig = ''
                  proxy_pass_header Authorization;
                '';
              };
            }
          ]
        ))
      ) eachFedimintdNginx;
    };

  meta.maintainers = with lib.maintainers; [ dpc ];
}
