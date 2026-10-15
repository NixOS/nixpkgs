{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.pulsarr;
in
{
  options.services.pulsarr = {
    enable = lib.mkEnableOption "Pulsarr, a Plex watchlist tracker for the Arr stack";

    package = lib.mkPackageOption pkgs "pulsarr" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/pulsarr";
      description = ''
        Directory containing Pulsarr's configuration, database, and logs.
        Passed as the upstream `dataDir` environment variable.
        The directory is created with the configured user and group.
        An existing `.env` file in this directory is read by Pulsarr.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "pulsarr";
      description = "User account under which Pulsarr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "pulsarr";
      description = "Group under which Pulsarr runs.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the firewall port for the Pulsarr web interface.";
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/pulsarr" ];
      description = ''
        Environment files containing secret configuration, such as `dbPassword`.
        Use Pulsarr's upstream environment variable names, in `name=value` format.
        These files are read at runtime and override values in `settings`.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.str
            lib.types.bool
            lib.types.int
          ]
        );
        options.listenPort = lib.mkOption {
          type = lib.types.port;
          default = 3003;
          description = ''
            Port on which Pulsarr listens. The upstream `port` setting is
            separate and controls the external port used for webhook URLs.
          '';
        };
      };
      default = { };
      example = {
        listenPort = 3004;
        baseUrl = "https://pulsarr.example.org";
        port = 443;
        cookieSecured = true;
      };
      description = ''
        Pulsarr configuration using the upstream environment variable names.
        See <https://jamcalli.github.io/Pulsarr/docs/installation/configuration>.
        Environment variables override web UI settings on restart.
        Set the state directory with `services.pulsarr.dataDir`.

        These values are stored in the world-readable Nix store.
        Use `environmentFiles` for secrets.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-pulsarr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.pulsarr = {
      description = "Pulsarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        if [ ! -e ${lib.escapeShellArg "${cfg.dataDir}/.env"} ]; then
          install -m 0640 ${cfg.package}/share/pulsarr/.env.example ${lib.escapeShellArg "${cfg.dataDir}/.env"}
        fi
      '';
      environment =
        lib.mapAttrs (
          _: value: if lib.isBool value then lib.boolToString value else toString value
        ) cfg.settings
        // {
          dataDir = cfg.dataDir;
        };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = 5;

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir ];
      };
      unitConfig.RequiresMountsFor = [ cfg.dataDir ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.listenPort ];

    users.users = lib.mkIf (cfg.user == "pulsarr") {
      pulsarr = {
        inherit (cfg) group;
        isSystemUser = true;
        home = cfg.dataDir;
      };
    };

    users.groups = lib.mkIf (cfg.group == "pulsarr") {
      pulsarr = { };
    };
  };

  meta = {
    maintainers = [ lib.maintainers.jblik ];
    doc = ./pulsarr.md;
  };
}
