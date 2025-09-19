{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.gowitness;
in
{

  options.services.gowitness = {
    enable = lib.mkEnableOption "Wether to enable gowitness.";

    package = lib.mkPackageOption pkgs "gowitness" { };

    debug = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable debug logging.
      '';
    };

    quiet = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Silence (almost all) logging.
      '';
    };

    dataPath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/gowitness";
      description = ''
        The directory where gowitness stores its data files.
      '';
    };

    screenshotPath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/gowitness/screenshots";
      description = ''
        The path where screenshots are stored.
      '';
    };

    dbUri = lib.mkOption {
      type = lib.types.str;
      default = "sqlite:///var/lib/gowitness/db.sqlite3";
      example = "postgres://user:pass@host:port/db";
      description = ''
        The database URI to use. Supports SQLite, Postgres, and MySQL.
      '';
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = ''
        The host address to bind the webserver.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 7171;
      description = ''
        The host address to bind the webserver.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open port in the firewall for the gowitness webserver.
      '';
    };

    user = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "gowitness";
      description = ''
        The gowitness service user.
      '';
    };

    group = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "gowitness";
      description = ''
        The gowitness service group.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.gowitness = {
      description = "gowitness";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "gowitness";
        WorkingDirectory = cfg.dataPath;
        Restart = "on-failure";
      };

      script = ''
        ${lib.getExe cfg.package} report server \
        --db-uri ${cfg.dbUri} \
        --host ${cfg.host} \
        --port ${toString cfg.port} \
        --screenshot-path ${cfg.screenshotPath} \
        ${if cfg.debug then "--debug-log \\" else ""}
        ${if cfg.quiet then "--quiet" else ""}
      '';
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users = lib.mkIf (cfg.user == "gowitness") {
      gowitness = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataPath;
      };
    };

    users.groups = lib.mkIf (cfg.group == "gowitness") { gowitness = { }; };
  };

  meta.maintainers = with lib.maintainers; [ codexlynx ];
}
