{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    filterAttrs
    flatten
    mapAttrs'
    mapAttrsToList
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    nameValuePair
    recursiveUpdate
    types
    ;

  eachFedimintd = filterAttrs (fedimintdName: cfg: cfg.enable) config.services.fedimintd;
  eachFedimintdNginx = filterAttrs (fedimintdName: cfg: cfg.nginx.enable) eachFedimintd;

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

        user = mkOption {
          type = types.str;
          default = "fedimintd-${name}";
          description = "The user as which to run fedimintd.";
        };

        group = mkOption {
          type = types.str;
          default = config.user;
          description = "The group as which to run fedimintd.";
        };

        environment = mkOption {
          type = types.attrsOf types.str;
          description = "Extra Environment variables to pass to the fedimintd.";
          default = {
            RUST_BACKTRACE = "1";
          };
          example = {
            RUST_LOG = "info,fm=debug";
            RUST_BACKTRACE = "1";
          };
        };

        p2p = {
          openFirewall = mkOption {
            type = types.bool;
            default = true;
            description = "Opens port in firewall for fedimintd's p2p port";
          };
          port = mkOption {
            type = types.port;
            default = 8173;
            description = "Port to bind on for p2p connections from peers";
          };
          bind = mkOption {
            type = types.str;
            default = "0.0.0.0";
            description = "Address to bind on for p2p connections from peers";
          };
          fqdn = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "p2p.myfedimint.com";
            description = "Public domain for p2p connections from peers";
          };
          url = mkOption {
            type = types.nullOr types.str;
            default = if config.p2p.fqdn != null then "fedimint://${config.p2p.fqdn}" else null;
            example = "fedimint://p2p.myfedimint.com";
            description = ''
              Public address for p2p connections from peers

              Typically you want to set `fqdn` instead.
            '';
          };
        };
        api = {
          openFirewall = mkOption {
            type = types.bool;
            default = false;
            description = "Opens port in firewall for fedimintd's api port";
          };
          port = mkOption {
            type = types.port;
            default = 8174;
            description = "Port to bind on for API connections relied by the reverse proxy/tls terminator.";
          };
          bind = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Address to bind on for API connections relied by the reverse proxy/tls terminator.";
          };
          fqdn = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "api.myfedimint.com";
            description = "Public domain of the API address of the reverse proxy/tls terminator.";
          };
          url = mkOption {
            type = types.nullOr types.str;
            default = if config.api.fqdn != null then "wss://${config.api.fqdn}" else null;
            description = ''
              Public URL of the API address of the reverse proxy/tls terminator. Usually starting with `wss://`.

              Typically you want to override `fqdn` instead.
            '';
          };
        };
        bitcoin = {
          network = mkOption {
            type = types.str;
            default = "signet";
            example = "bitcoin";
            description = "Bitcoin network to participate in.";
          };
          rpc = {
            url = mkOption {
              type = types.str;
              default = "http://127.0.0.1:38332";
              example = "signet";
              description = "Bitcoin node (bitcoind/electrum/esplora) address to connect to";
            };

            kind = mkOption {
              type = types.str;
              default = "bitcoind";
              example = "electrum";
              description = "Kind of a bitcoin node.";
            };

            secretFile = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                If set the URL specified in `bitcoin.rpc.url` will get the content of this file added
                as an URL password, so `http://user@example.com` will turn into `http://user:SOMESECRET@example.com`.

                Example:

                `/etc/nix-bitcoin-secrets/bitcoin-rpcpassword-public` (for nix-bitcoin default)
              '';
            };
          };
        };

        consensus.finalityDelay = mkOption {
          type = types.number;
          default = 10;
          description = "Consensus peg-in finality delay.";
        };

        dataDir = mkOption {
          type = types.str;
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
              Wether to configure nginx for fedimintd
            '';
          };
          config = mkOption {
            type = types.submodule (
              recursiveUpdate (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) {
                options.serverName = {
                  default = "fedimintd-${name}";
                  defaultText = "fedimintd-\${name}";
                };
              }
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

  config = mkIf (eachFedimintd != { }) {

    assertions = flatten (
      mapAttrsToList (fedimintdName: cfg: [
        {
          assertion = cfg.p2p.url != null;
          message = ''
            `services.fedimintd.${fedimintdName}.p2p.url` must be set to address reachable by other peers.

            Example: `fedimint://p2p.mymint.org`.
          '';
        }
        {
          assertion = cfg.api.url != null;
          message = ''
            `services.fedimintd.${fedimintdName}.api.url` must be set to address reachable by the clients, with TLS terminated by external service (typically nginx), and relayed to the fedimintd bind address.

            Example: `wss://api.mymint.org`.
          '';
        }
      ]) eachFedimintd
    );

    networking.firewall.allowedTCPPorts = flatten (
      mapAttrsToList (
        fedimintdName: cfg:
        (lib.optional cfg.api.openFirewall cfg.api.port ++ lib.optional cfg.p2p.openFirewall cfg.p2p.port)
      ) eachFedimintd
    );

    systemd.services = mapAttrs' (
      fedimintdName: cfg:
      (nameValuePair "fedimintd-${fedimintdName}" (
        let
          startScript = pkgs.writeShellScript "fedimintd-start" (
            (
              if cfg.bitcoin.rpc.secretFile != null then
                ''
                  secret=$(${pkgs.coreutils}/bin/head -n 1 "${cfg.bitcoin.rpc.secretFile}")
                  prefix="''${FM_BITCOIN_RPC_URL%*@*}"  # Everything before the last '@'
                  suffix="''${FM_BITCOIN_RPC_URL##*@}"  # Everything after the last '@'
                  FM_BITCOIN_RPC_URL="''${prefix}:''${secret}@''${suffix}"
                ''
              else
                ""
            )
            + ''
              exec ${cfg.package}/bin/fedimintd
            ''
          );
        in
        {
          description = "Fedimint Server";
          documentation = [ "https://github.com/fedimint/fedimint/" ];
          wantedBy = [ "multi-user.target" ];
          environment = lib.mkMerge [
            {
              FM_BIND_P2P = "${cfg.p2p.bind}:${toString cfg.p2p.port}";
              FM_BIND_API = "${cfg.api.bind}:${toString cfg.api.port}";
              FM_P2P_URL = cfg.p2p.url;
              FM_API_URL = cfg.api.url;
              FM_DATA_DIR = cfg.dataDir;
              FM_BITCOIN_NETWORK = cfg.bitcoin.network;
              FM_BITCOIN_RPC_URL = cfg.bitcoin.rpc.url;
              FM_BITCOIN_RPC_KIND = cfg.bitcoin.rpc.kind;
            }
            cfg.environment
          ];
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;

            StateDirectory = "fedimintd-${fedimintdName}";
            StateDirectoryMode = "0700";
            ExecStart = startScript;

            Restart = "always";
            RestartSec = 10;
            StartLimitBurst = 5;
            UMask = "007";
            LimitNOFILE = "100000";

            LockPersonality = true;
            MemoryDenyWriteExecute = "true";
            NoNewPrivileges = "true";
            PrivateDevices = "true";
            PrivateMounts = true;
            PrivateTmp = "true";
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
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
          };
        }
      ))
    ) eachFedimintd;

    users.users = mapAttrs' (
      fedimintdName: cfg:
      (nameValuePair "fedimintd-${fedimintdName}" {
        name = cfg.user;
        group = cfg.group;
        description = "Fedimint daemon user";
        home = cfg.dataDir;
        isSystemUser = true;
      })
    ) eachFedimintd;

    users.groups = mapAttrs' (fedimintdName: cfg: (nameValuePair "${cfg.group}" { })) eachFedimintd;

    services.nginx.virtualHosts = mapAttrs' (
      fedimintdName: cfg:
      (nameValuePair cfg.api.fqdn (
        lib.mkMerge [
          cfg.nginx.config

          {
            enableACME = mkDefault true;
            forceSSL = mkDefault true;
            # Currently Fedimint API only support JsonRPC on `/ws/` endpoint, so no need to handle `/`
            locations."/ws/" = {
              proxyPass = "http://127.0.0.1:${builtins.toString cfg.api.port}/";
              proxyWebsockets = true;
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
