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
            description = "Opens port in firewall for fedimintd's p2p port (both TCP and UDP)";
          };
          port = mkOption {
            type = types.port;
            default = 8173;
            description = "Port to bind on for p2p connections from peers (both TCP and UDP)";
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
          openFirewall = mkOption {
            type = types.bool;
            default = true;
            description = "Opens UDP port in firewall for fedimintd's API Iroh endpoint";
          };
          port = mkOption {
            type = types.port;
            default = 8174;
            description = "UDP Port to bind Iroh endpoint for API connections";
          };
          bind = mkOption {
            type = types.str;
            default = "0.0.0.0";
            description = "Address to bind on for Iroh endpoint for API connections";
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
            description = "Bitcoin node (bitcoind/electrum/esplora) address to connect to";
          };

          bitcoindUser = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "bitcoin";
            description = "Bitcoind RPC user";
          };

          bitcoindPassword = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Bitcoind RPC password";
          };

          bitcoindSecretFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              If set the URL specified in `bitcoin.bitcoindUrl` will get the content of
              this file added as an URL password, so `http://user@example.com` will turn
              into `http://user:SOMESECRET@example.com`.

              Example:

              `/etc/nix-bitcoin-secrets/bitcoin-rpcpassword-public` (for nix-bitcoin default)
            '';
          };

          esploraUrl = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "https://mempool.space/signet/api";
            description = "Bitcoin node (bitcoind/electrum/esplora) address to connect to";
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

      assertions = [
        {
          assertion = lib.all (
            cfg:
            (cfg.bitcoin.bitcoindUrl != null)
            -> (cfg.bitcoin.bitcoindUser != null && cfg.bitcoin.bitcoindPassword != null)
          ) (lib.mapAttrsToList (name: cfg: cfg) eachFedimintd);
          message = "If bitcoindUrl is set, both bitcoindUser and bitcoindPassword must also be set. Embedded credentials in the bitcoindUrl are not supported anymore, please remove them.";
        }
        {
          assertion = lib.all (cfg: (cfg.bitcoin.bitcoindUrl != null || cfg.bitcoin.esploraUrl != null)) (
            lib.mapAttrsToList (name: cfg: cfg) eachFedimintd
          );
          message = "Either bitcoindUrl or esploraUrl must be set for each fedimintd instance";
        }
      ];

      networking.firewall.allowedTCPPorts = concatLists (
        mapAttrsToList (
          fedimintdName: cfg:
          (
            lib.optional cfg.api_ws.openFirewall cfg.api_ws.port
            ++ lib.optional cfg.p2p.openFirewall cfg.p2p.port
            ++ lib.optional cfg.ui.openFirewall cfg.ui.port
          )
        ) eachFedimintd
      );

      networking.firewall.allowedUDPPorts = concatLists (
        mapAttrsToList (
          fedimintdName: cfg:
          (
            lib.optional cfg.api_iroh.openFirewall cfg.api_iroh.port
            ++ lib.optional cfg.p2p.openFirewall cfg.p2p.port
          )
        ) eachFedimintd
      );

      systemd.services = mapAttrs' (
        fedimintdName: cfg:
        (nameValuePair "fedimintd-${fedimintdName}" (
          let
            startScript = pkgs.writeShellScriptBin "fedimintd" ''
              exec ${cfg.package}/bin/fedimintd
            '';
          in
          {
            description = "Fedimint Server";
            documentation = [ "https://github.com/fedimint/fedimint/" ];
            wantedBy = [ "multi-user.target" ];
            environment = lib.mkMerge [
              {
                FM_BIND_P2P = "${cfg.p2p.bind}:${toString cfg.p2p.port}";
                FM_BIND_API_WS = "${cfg.api_ws.bind}:${toString cfg.api_ws.port}";
                FM_BIND_API_IROH = "${cfg.api_iroh.bind}:${toString cfg.api_iroh.port}";
                FM_BIND_UI = "${cfg.ui.bind}:${toString cfg.ui.port}";
                FM_DATA_DIR = cfg.dataDir;
                FM_BITCOIN_NETWORK = cfg.bitcoin.network;
                FM_BITCOIND_URL = cfg.bitcoin.bitcoindUrl;
                FM_ESPLORA_URL = cfg.bitcoin.esploraUrl;
                FM_BITCOIND_URL_PASSWORD_FILE = cfg.bitcoin.bitcoindSecretFile;
                FM_BITCOIND_USERNAME = cfg.bitcoin.bitcoindUser;
                FM_BITCOIND_PASSWORD = cfg.bitcoin.bitcoindPassword;
              }

              (lib.optionalAttrs (cfg.p2p.url != null) {
                FM_P2P_URL = cfg.p2p.url;
              })

              (lib.optionalAttrs (cfg.api_ws.url != null) {
                FM_API_URL = cfg.api_ws.url;
              })

              cfg.environment
            ];
            serviceConfig = {
              DynamicUser = true;

              StateDirectory = "fedimintd-${fedimintdName}";
              StateDirectoryMode = "0700";
              ExecStart = "${startScript}/bin/fedimintd";

              Restart = "always";
              RestartSec = 10;
              StartLimitBurst = 5;
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
              SocketBindAllow = [
                "tcp:${toString cfg.p2p.port}"
                "udp:${toString cfg.p2p.port}"
                "tcp:${toString cfg.api_ws.port}"
                "tcp:${toString cfg.ui.port}"
                "udp:${toString cfg.api_iroh.port}"
              ];
              SystemCallArchitectures = "native";
              SystemCallFilter = [
                "@system-service"
                "~@privileged"
              ];
            };
          }
        ))
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
