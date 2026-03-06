{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.relay-server;
  format = pkgs.formats.toml { };

  configFile = format.generate "relay.toml" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [ sweenu ];

  options.services.relay-server = {
    enable = lib.mkEnableOption "Relay Server, a self-hosted collaboration server for Relay.md";

    package = lib.mkPackageOption pkgs "relay-server" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;

        options = {
          server = {
            url = lib.mkOption {
              type = lib.types.str;
              example = "http://relay-server.my-network.internal:8080";
              default = "http://localhost:${builtins.toString cfg.settings.server.port}";
              defaultText = "http://localhost:8080";
              description = ''
                The external URL where the relay server is accessible.
                This should match the URL you configure in the Relay Obsidian plugin.
              '';
            };

            host = lib.mkOption {
              type = lib.types.str;
              default = "0.0.0.0";
              description = "Address to bind to.";
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 8080;
              description = "Port to listen on.";
            };
          };

          store = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = {
              type = "filesystem";
              path = "/var/lib/relay-server/data";
            };
            example = lib.literalExpression ''
              {
                type = "aws";
                bucket = "my-bucket";
                region = "us-east-1";
              }
            '';
            description = ''
              Storage backend configuration.
              Supports `filesystem`, `aws` (S3), `cloudflare` (R2), and other S3-compatible stores.
            '';
          };

          auth = lib.mkOption {
            type = lib.types.listOf (
              lib.types.submodule {
                options = {
                  key_id = lib.mkOption {
                    type = lib.types.str;
                    description = "The key identifier.";
                  };
                  public_key = lib.mkOption {
                    type = lib.types.str;
                    description = "The base64-encoded public key.";
                  };
                };
              }
            );
            default = [
              {
                key_id = "relay_2025_10_22";
                public_key = "/6OgBTHaRdWLogewMdyE+7AxnI0/HP3WGqRs/bYBlFg=";
              }
              {
                key_id = "relay_2025_10_23";
                public_key = "fbm9JLHrwPpST5HAYORTQR/i1VbZ1kdp2ZEy0XpMbf0=";
              }
            ];
            description = ''
              Authentication keys for the Relay.md control plane.
              The default keys are the official Relay.md public keys.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration for relay-server in TOML format.
        See <https://github.com/No-Instructions/relay-server/blob/main/crates/relay.toml.example> for available options.
      '';
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Environment variables to set for the relay-server service.
        Note: Do not use this for secrets; use {option}`environmentFile` instead.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to an environment file containing secrets.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.relay-server = {
      description = "Relay Server for Relay.md";
      documentation = [ "https://github.com/No-Instructions/relay-server" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      inherit (cfg) environment;

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} serve --config ${configFile}";
        StateDirectory = "relay-server";
        DynamicUser = true;
        Restart = "on-failure";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        # Hardening
        AmbientCapabilities = [ "" ];
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
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
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}
