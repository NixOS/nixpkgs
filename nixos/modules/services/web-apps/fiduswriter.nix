{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.fiduswriter;
  stateDir = "/var/lib/fiduswriter";

  fidusSrc = "${cfg.package}/${pkgs.python3.sitePackages}/fiduswriter";
  srcWithConfig = pkgs.symlinkJoin {
    name = "fiduswriter-with-test-config";
    paths = [ fidusSrc ];
    postBuild = ''
      cp ${../../../tests/fiduswriter/configuration-test.py} $out/configuration.py
    '';
  };
in

{
  options = {
    services.fiduswriter = {
      enable = mkEnableOption "fiduswriter";
      package = lib.mkPackageOption pkgs "fiduswriter" { };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Fidus Writer address";
      };

      port = mkOption {
        type = types.port;
        default = 8000;
        description = "Fidus Writer port";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.fiduswriter = {
      description = "Fidus Writer Collaborative Editor";

      path = [
        cfg.package
      ];

      environment = {
        PROJECT_PATH = stateDir;
        PYTHONPATH = "${cfg.package.env.PYTHONPATH}";
        SRC_PATH = "${srcWithConfig}";

        GRANIAN_HOST = cfg.address;
        GRANIAN_PORT = toString cfg.port;

        STATIC_ROOT = "${cfg.package.passthru.frontend}/static-collected";
      };

      serviceConfig = {
        DynamicUser = true;
        User = "fiduswriter";
        Group = "fiduswriter";

        StateDirectory = "fiduswriter";
        ExecStart = "${cfg.package}/bin/fiduswriter-start";

        Restart = "on-failure";
        RestartSec = "5s";
      };

      preStart = ''
        ln -sf "${cfg.package.passthru.frontend}/static-collected" ${stateDir}/static-collected
        ln -sf "${cfg.package.passthru.frontend}/static-transpile" ${stateDir}/static-transpile
        ln -sf "${cfg.package.passthru.frontend}/static-libs" ${stateDir}/static-libs

        # init db
        fiduswriter migrate
        fiduswriter createsuperuser \
          --username=admin \
          --email=admin@example.com \
          --password=secret \
          --noinput
      '';

      wantedBy = [
        "multi-user.target"
      ];
      after = [
        "network.target"
        "postgresql.service"
        "redis.service"
      ];
      wants = [
        "redis.service"
      ];
    };

    # TODO:
    # - toggle local?
    # - options?
    services.postgresql = {
      enable = true;
      ensureDatabases = [
        "fiduswriter"
      ];
      ensureUsers = [
        {
          name = "fiduswriter";
          ensureDBOwnership = true;
        }
      ];
    };

    # TODO:
    # - toggle local?
    # - options?
    services.redis.servers."" = {
      enable = true;
    };

    # TODO: firewall options
  };
}
