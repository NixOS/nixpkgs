{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.frab;

  databaseConfig = builtins.toJSON { production = cfg.database; };

in

{
  options = {
    services.frab = {
      enable = mkEnableOption "frab";

      package = mkOption {
        default = pkgs.frab;
        defaultText = "pkgs.frab";
        type = types.package;
        description = ''
          Frab package to use.
        '';
      };

      host = mkOption {
        type = types.str;
        example = "frab.example.com";
        description = ''
          Hostname under which this frab instance can be reached.
        '';
      };

      protocol = mkOption {
        type = types.str;
        default = "https";
        example = "http";
        description = ''
          Either http or https, depending on how your Frab instance
          will be exposed to the public.
        '';
      };

      fromEmail = mkOption {
        type = types.str;
        default = "frab@localhost";
        description = ''
          Email address used by frab.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Address or hostname frab should listen on.
        '';
      };

      listenPort = mkOption {
        type = types.int;
        default = 3000;
        description = ''
          Port frab should listen on.
        '';
      };

      statePath = mkOption {
        type = types.str;
        default = "/var/lib/frab";
        description = ''
          Directory where frab keeps its state.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "frab";
        description = ''
          User to run frab.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "frab";
        description = ''
          Group to run frab.
        '';
      };

      secretKeyBase = mkOption {
        type = types.str;
        description = ''
          Your secret key is used for verifying the integrity of signed cookies.
          If you change this key, all old signed cookies will become invalid!

          Make sure the secret is at least 30 characters and all random,
          no regular words or you'll be exposed to dictionary attacks.
        '';
      };

      database = mkOption {
        type = types.attrs;
        default = {
          adapter = "sqlite3";
          database = "/var/lib/frab/db.sqlite3";
          pool = 5;
          timeout = 5000;
        };
        example = {
          adapter = "postgresql";
          database = "frab";
          host = "localhost";
          username = "frabuser";
          password = "supersecret";
          encoding = "utf8";
          pool = 5;
        };
        description = ''
          Rails database configuration for Frab as Nix attribute set.
        '';
      };

      extraEnvironment = mkOption {
        type = types.attrs;
        default = {};
        example = {
          FRAB_CURRENCY_UNIT = "€";
          FRAB_CURRENCY_FORMAT = "%n%u";
          EXCEPTION_EMAIL = "frab-owner@example.com";
          SMTP_ADDRESS = "localhost";
          SMTP_PORT = "587";
          SMTP_DOMAIN = "localdomain";
          SMTP_USER_NAME = "root";
          SMTP_PASSWORD = "toor";
          SMTP_AUTHENTICATION = "1";
          SMTP_NOTLS = "1";
        };
        description = ''
          Additional environment variables to set for frab for further
          configuration. See the frab documentation for more information.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users = [
      { name = cfg.user;
        group = cfg.group;
        home = "${cfg.statePath}";
      }
    ];

    users.groups = [ { name = cfg.group; } ];

    systemd.services.frab = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with cfg.package; [
        env
        env.wrappedRuby
        pkgs.nodejs
      ];

      environment = {
        RAILS_ENV = "production";
        RACK_ENV = "production";
        SECRET_KEY_BASE = cfg.secretKeyBase;
        FRAB_HOST = cfg.host;
        FRAB_PROTOCOL = cfg.protocol;
        FROM_EMAIL = cfg.fromEmail;
        RAILS_SERVE_STATIC_FILES = "1";
        EXECJS_RUNTIME = "Node";
        BOOTSNAP_CACHE_DIR = "${cfg.statePath}/tmp/cache";
      } // cfg.extraEnvironment;

      # FIXME(manveru): even though we create the cache dir, bootsnap fails on
      # the first try, it works after the service restarts itself the first
      # time. Would be nice if we could get faster initial startup.

      preStart = ''
        mkdir -p ${cfg.statePath}/system/attachments
        mkdir -p $BOOTSNAP_CACHE_DIR
        chown ${cfg.user}:${cfg.group} -R ${cfg.statePath}

        mkdir /run/frab -p
        ln -sf ${pkgs.writeText "frab-database.yml" databaseConfig} /run/frab/database.yml
        ln -sf ${cfg.statePath}/system /run/frab/system

        if ! test -e "${cfg.statePath}/db-setup-done"; then
          rake db:setup
          touch ${cfg.statePath}/db-setup-done
        else
          rake db:migrate
        fi
      '';

      serviceConfig = {
        PermissionsStartOnly = true;
        PrivateTmp = true;
        PrivateDevices = true;
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300s";
        Restart = "on-failure";
        RestartSec = "10s";
        WorkingDirectory = "${cfg.package}/share/frab";
        ExecStart = "${cfg.package.env}/bin/rails server --binding=${cfg.listenAddress} --port=${toString cfg.listenPort}";
      };
    };

  };
}
