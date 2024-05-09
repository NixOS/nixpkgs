{ config, pkgs, lib, ... }:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf
    literalExpression
    ;

  cfg = config.services.glitchtip;

  uwsgiConfig.uwsgi = {
    type = "normal";
    plugins = [ "python3" ];
    module = "glitchtip.wsgi:application";
    env = "DJANGO_SETTINGS_MODULE=glitchtip.settings";
    master = true;
    pidfile = "/run/glitchtip/uwsgi.pid";
    log-x-forwarded-for = true;
    log-format-strftime = true;
    http-socket = ":${builtins.toString cfg.port}";
    cheaper-algo = "busyness";
    cheaper-overload = 30;
    cheaper-step = 1;
    cheaper-busyness-max = 50;
    cheaper-busyness-min = 25;
    cheaper-busyness-multiplier = 20;
    harakiri = 60;
    max-requests = 10000;
    worker-reload-mercy = 10;
    die-on-term = true;
    enable-threads = true;
    single-interpreter = true;
    post-buffering = true;
    buffer-size = 83146;
    ignore-sigpipe = true;
    ignore-write-errors = true;
    disable-write-exception = true;
    listen = 128;
    virtualenv = pkgs.python3.buildEnv.override { extraLibs = pkgs.glitchtip.pythonPackages ++ cfg.extraPythonPackages; };
  } // cfg.uwsgiExtraSettings;

  uwsgiConfigFile = pkgs.writeText "uwsgi-glitchtip.json" (builtins.toJSON uwsgiConfig);

  uwsgi = (pkgs.uwsgi.override {
    plugins = [ "python3" ];
  });

in
{
  meta.maintainers = [ lib.maintainers.soyouzpanda ];

  options = {
    services.glitchtip = {
      enable = mkEnableOption "Glitchtip";
      package = mkPackageOption pkgs "glitchtip" { };

      user = mkOption {
        type = types.str;
        default = "glitchtip";
        description = "User account under which glitchtip runs.";
      };

      group = mkOption {
        type = types.str;
        default = "glitchtip";
        description = "Group under which glitchtip runs.";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "Port used by uwsgi.";
      };

      extraPythonPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "Extra python packages.";
      };

      settings = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = ''
          Environment variables used for Glitchtip.
        '';
      };

      uwsgiExtraSettings = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = ''
          Extra settings used by uwsgi.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users = mkIf (cfg.user == "glitchtip") {
      glitchtip = {
        description = "Glithctip service";
        home = "/var/lib/glitchtip";
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "glitchtip") {
      glitchtip = { };
    };

    systemd.services.glitchtip = {
      description = "Glitchtip";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${uwsgi}/bin/uwsgi --json ${uwsgiConfigFile}";

        WorkingDirectory = pkgs.glitchtip;
        RuntimeDirectory = "glitchtip";
        StateDirectory = "glitchtip";

        User = cfg.user;
        Group = cfg.group;
      };

      environment = cfg.settings;
    };
  };
}
