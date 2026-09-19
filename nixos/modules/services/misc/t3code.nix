{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.services.t3code;
  t3 = lib.getExe' cfg.package "t3";
  commandLine = lib.cli.toCommandLine (optionName: {
    option = "--${optionName}";
    sep = " ";
    explicitBool = false;
  }) cfg.settings;
in
{
  options = {
    services.t3code = {
      enable = lib.mkEnableOption "T3 Code server";
      package = lib.mkPackageOption pkgs "t3code" { };
      settings = lib.mkOption {
        type = types.submodule {
          freeformType = types.attrs;

          options = {
            mode = lib.mkOption {
              type = types.enum [
                "web"
                "desktop"
              ];
              default = "web";
              description = ''
                Runtime mode of the T3 Code server.

                `web` is intended for a long-running, network-visible
                server; `desktop` is loopback-only with fixed
                defaults.
              '';
            };

            host = lib.mkOption {
              type = types.nullOr types.str;
              default = "localhost";
              example = "[::]";
              description = ''
                The host interface or hostname that the T3 Code server
                HTTP/WebSocket interface listens on.

                `null` binds to all interfaces, which is the `web`
                mode default. Both IPv4 and IPv6 addresses are
                accepted.
              '';
            };

            port = lib.mkOption {
              type = types.port;
              default = 3773;
              example = 8080;
              description = ''
                The port that the T3 Code server listens on.
              '';
            };

            state-dir = lib.mkOption {
              type = types.str;
              default = "/var/lib/t3code";
              example = "/var/lib/t3code";
              description = ''
                State directory for the database, logs, and
                keybindings configuration.
              '';
            };

            no-browser = lib.mkOption {
              type = types.bool;
              default = true;
              description = ''
                Disable automatic browser opening on startup.

                Enabled by default so that a systemd service does not
                attempt to open a browser.
              '';
            };

            auth-token = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Authentication token required for WebSocket
                connections.

                When set, clients must provide this token to establish
                connections.
              '';
            };
          };
        };

        default = { };
        example = {
          port = 8080;
          dev-url = "http://localhost:5173";
        };

        description = ''
          Options passed to the T3 Code server as command-line
          arguments.

          The typed options above become the `--mode`, `--host`,
          `--port`, `--state-dir`, `--no-browser`, and `--auth-token`
          flags. Any other attribute is passed through as an extra
          flag, e.g.  `dev-url = "http://localhost:5173"` becomes
          `--dev-url http://localhost:5173`.

          See <https://t3.codes> for the full list of supported
          options.
        '';
      };

      environment = lib.mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          T3CODE_LOG_WS_EVENTS = "true";
        };
        description = ''
          Extra environment variables for the T3 Code server.

          Command-line flags in `settings` take precedence over these
          variables when both are set.
        '';
      };

      environmentFile = lib.mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/lib/secrets/t3codeSecrets";
        description = ''
          Environment file to be passed to the systemd service.

          Useful for passing secrets, such as the auth token, to the service
          without making them world-readable in the Nix store.
        '';
      };

      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for the T3 Code server.

          This adds `services.t3code.settings.port` to
          `networking.firewall.allowedTCPPorts`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.t3code = {
      description = "T3 Code web server for coding agents";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        HOME = cfg.settings.state-dir;
      }
      // cfg.environment;

      serviceConfig = {
        Type = "exec";
        DynamicUser = true;
        ExecStart = toString [
          t3
          commandLine
        ];
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = cfg.settings.state-dir;
        StateDirectory = "t3code";
        ReadWritePaths = [ cfg.settings.state-dir ];

        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateUsers = true;
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

    environment.systemPackages = [ cfg.package ];

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.port ]; };
  };

  meta.maintainers = with lib.maintainers; [ onny ];
}
