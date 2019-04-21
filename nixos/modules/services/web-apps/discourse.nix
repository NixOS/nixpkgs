{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.discourse;

  bundle = "${cfg.package}/share/discourse/bin/bundle";

in

{
  options = {
    services.discourse = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Discourse service.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.discourse;
        defaultText = "pkgs.discourse";
        description = ''
          Which Discourse package to use.
        '';
        example = "pkgs.discourse.override { ruby = pkgs.ruby_2_5; }";
      };

      port = mkOption {
        type = types.int;
        default = 3000;
        description = "Port on which Discourse is ran.";
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/discourse";
        description = "The state directory, logs and plugins are stored here.";
      };

      database = {

        host = mkOption {
          type = types.str;
          default = (if cfg.database.socket != null then "localhost" else "127.0.0.1");
          description = "Database host address.";
        };

        port = mkOption {
          type = types.int;
          default = 5432;
          description = "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "discourse";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "discourse";
          description = "Database user.";
        };

        password = mkOption {
          type = types.str;
          default = "";
          description = ''
            The password corresponding to <option>database.user</option>.
            Warning: this is stored in cleartext in the Nix store!
            Use <option>database.passwordFile</option> instead.
          '';
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/discourse-dbpassword";
          description = ''
            A file containing the password corresponding to
            <option>database.user</option>.
          '';
        };

        socket = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/postgresql";
          description = "Path to the unix socket file to use for authentication.";
        };
      };

    };
  };

  config = mkIf cfg.enable {

    systemd.services.discourse = {
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      environment.RAILS_ENV = "production";
      environment.RAILS_CACHE = "${cfg.stateDir}/cache";

      serviceConfig = {
        Type = "simple";
        # User = cfg.user;
        # Group = cfg.group;
        TimeoutSec = "300";
        WorkingDirectory = "${cfg.package}/share/discourse";
        ExecStart="${bundle} exec rails server webrick -e production -p ${toString cfg.port} -P '${cfg.stateDir}/discourse.pid'";
      };

    };
  };

}
