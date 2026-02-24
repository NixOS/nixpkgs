{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    hasPrefix
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.postfix-tlspol;

  format = pkgs.formats.yaml_1_2 { };
  configFile = format.generate "postfix-tlspol.yaml" cfg.settings;
in

{
  meta.maintainers = pkgs.postfix-tlspol.meta.maintainers;

  options.services.postfix-tlspol = {
    enable = mkEnableOption "postfix-tlspol";

    package = mkPackageOption pkgs "postfix-tlspol" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
        options = {
          server = {
            address = mkOption {
              type = types.str;
              default = "unix:/run/postfix-tlspol/tlspol.sock";
              example = "127.0.0.1:8642";
              description = ''
                Path or address/port where postfix-tlspol binds its socket to.
              '';
            };

            socket-permissions = mkOption {
              type = types.str;
              default = "0660";
              readOnly = true;
              description = ''
                Permissions to the UNIX socket, if configured.

                ::: {.note}
                Due to hardening on the systemd unit the socket can never be created world readable/writable.
                :::
              '';
              apply = value: (builtins.fromTOML "v=0o${value}").v;
            };

            log-level = mkOption {
              type = types.enum [
                "debug"
                "info"
                "warn"
                "error"
              ];
              default = "info";
              example = "warn";
              description = ''
                Log level
              '';
            };

            prefetch = mkOption {
              type = types.bool;
              default = true;
              example = false;
              description = ''
                Whether to prefetch DNS records when the TTL of a cached record is about to expire.
              '';
            };

            cache-file = mkOption {
              type = types.path;
              default = "/var/cache/postfix-tlspol/cache.db";
              readOnly = true;
              description = ''
                Path to the cache file.
              '';
            };
          };

          dns = {
            address = mkOption {
              type = with types; nullOr str;
              default = null;
              example = "127.0.0.1:53";
              description = ''
                IP and port to your DNS resolver.

                Uses resolvers from /etc/resolv.conf if unset.

                ::: {.note}
                The configured DNS resolver must validate DNSSEC signatures.
                :::
              '';
            };
          };
        };
      };

      default = { };
      description = ''
        The postfix-tlspol configuration file as a Nix attribute set.

        See the reference documentation for possible options.
        <https://github.com/Zuplu/postfix-tlspol/blob/main/configs/config.default.yaml>
      '';
    };

    configurePostfix = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to configure the required settings to use postfix-tlspol in the local Postfix instance.
      '';
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable && config.services.postfix.enable && cfg.configurePostfix) {
      # https://github.com/Zuplu/postfix-tlspol#postfix-configuration
      services.postfix.settings.main = {
        smtp_dns_support_level = "dnssec";
        smtp_tls_security_level = "dane";
        smtp_tls_policy_maps =
          let
            address =
              if (hasPrefix "unix:" cfg.settings.server.address) then
                cfg.settings.server.address
              else
                "inet:${cfg.settings.server.address}";
          in
          [ "socketmap:${address}:QUERYwithTLSRPT" ];
      };

      systemd.services.postfix = {
        wants = [ "postfix-tlspol.service" ];
        after = [ "postfix-tlspol.service" ];
      };

      users.users.postfix.extraGroups = [ "postfix-tlspol" ];
    })

    (mkIf cfg.enable {
      environment.etc."postfix-tlspol/config.yaml".source = configFile;

      environment.systemPackages = [ cfg.package ];

      users.users.postfix-tlspol = {
        isSystemUser = true;
        group = "postfix-tlspol";
      };
      users.groups.postfix-tlspol = { };

      systemd.services.postfix-tlspol = {
        after = [
          "nss-lookup.target"
          "network-online.target"
        ];
        wants = [
          "nss-lookup.target"
          "network-online.target"
        ];
        wantedBy = [ "multi-user.target" ];

        description = "Postfix DANE/MTA-STS TLS policy socketmap service";
        documentation = [ "https://github.com/Zuplu/postfix-tlspol" ];

        restartTriggers = [ configFile ];

        # https://github.com/Zuplu/postfix-tlspol/blob/main/init/postfix-tlspol.service
        serviceConfig = {
          ExecStart = toString [
            (lib.getExe cfg.package)
            "-config"
            "/etc/postfix-tlspol/config.yaml"
          ];
          ExecReload = "${lib.getExe' pkgs.util-linux "kill"} -HUP $MAINPID";
          Restart = "always";
          RestartSec = 5;

          User = "postfix-tlspol";
          Group = "postfix-tlspol";

          CacheDirectory = "postfix-tlspol";
          CapabilityBoundingSet = [ "" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ReadOnlyPaths = [ "/etc/postfix-tlspol/config.yaml" ];
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ]
          ++ lib.optionals (lib.hasPrefix "unix:" cfg.settings.server.address) [
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged @resources"
          ];
          SystemCallErrorNumber = "EPERM";
          SecureBits = [
            "noroot"
            "noroot-locked"
          ];
          RuntimeDirectory = "postfix-tlspol";
          RuntimeDirectoryMode = "1750";
          WorkingDirectory = "/var/cache/postfix-tlspol";
          UMask = "0117";
        };
      };
    })
  ];
}
