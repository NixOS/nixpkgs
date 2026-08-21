{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.services.cliproxyapi;
  yamlFormat = pkgs.formats.yaml { };

  generatedConfigFile = yamlFormat.generate "cliproxyapi.yaml" (
    lib.recursiveUpdate {
      inherit (cfg) port host;
      auth-dir = "/var/lib/cliproxyapi/auths";
    } cfg.settings
  );

  configFile = if cfg.configFile != null then cfg.configFile else generatedConfigFile;
in
{
  options.services.cliproxyapi = {
    enable = lib.mkEnableOption "CLI Proxy API server";

    package = lib.mkPackageOption pkgs "cliproxyapi" { };

    host = lib.mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = ''
        The host address that the CLI Proxy API daemon listens on.
      '';
    };

    port = lib.mkOption {
      type = types.port;
      default = 8317;
      description = ''
        The port that the CLI Proxy API daemon listens on.
      '';
    };

    settings = lib.mkOption {
      type = yamlFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          api-keys = [ "my-secret-key" ];
          routing = {
            strategy = "round-robin";
          };
        }
      '';
      description = ''
        Structured configuration for CLIProxyAPI as YAML.
        Secrets in `settings` are stored world-readable in the Nix store.
        For sensitive secrets, use `configFile` or `environmentFile` instead.
      '';
    };

    configFile = lib.mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/etc/cliproxyapi/config.yaml";
      description = ''
        Path to an existing configuration file. If specified, this takes precedence over `settings`.
      '';
    };

    environmentFile = lib.mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/etc/cliproxyapi/cliproxyapi.env";
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`.
      '';
    };

    localModel = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to use embedded models only and skip remote model catalog updates.
      '';
    };

    extraFlags = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--no-browser" ];
      description = ''
        Extra command-line flags to pass to the `cli-proxy-api` daemon.
      '';
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall port for CLI Proxy API.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.cliproxyapi = {
      description = "CLI Proxy API Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.HOME = "/var/lib/cliproxyapi";

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "--config"
            (toString configFile)
          ]
          ++ lib.optional cfg.localModel "--local-model"
          ++ cfg.extraFlags
        );
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        Restart = "on-failure";
        RestartSec = 5;
        DynamicUser = true;
        StateDirectory = "cliproxyapi";
        WorkingDirectory = "/var/lib/cliproxyapi";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ rachalaraj ];
}
