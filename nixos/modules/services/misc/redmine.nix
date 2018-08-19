{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.redmine;

  databaseYml = ''
    production:
      adapter: mysql2 # postgresql
      database: ${cfg.databaseName}
      host: ${cfg.databaseHost}
      password: ${cfg.databasePassword}
      username: ${cfg.databaseUsername}
      encoding: utf8
  '';

  configurationYml = ''
    default:
      # Absolute path to the directory where attachments are stored.
      # The default is the 'files' directory in your Redmine instance.
      # Your Redmine instance needs to have write permission on this
      # directory.
      # Examples:
      # attachments_storage_path: /var/redmine/files
      # attachments_storage_path: D:/redmine/files
      attachments_storage_path: ${cfg.stateDir}/files

      # Absolute path to the SCM commands errors (stderr) log file.
      # The default is to log in the 'log' directory of your Redmine instance.
      # Example:
      # scm_stderr_log_file: /var/log/redmine_scm_stderr.log
      scm_stderr_log_file: ${cfg.stateDir}/log/redmine_scm_stderr.log

      ${cfg.extraConfig}
  '';

in {

  options = {
    services.redmine = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the redmine service.
        '';
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/redmine";
        description = "The state directory, logs and plugins are stored here";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra configuration in configuration.yml";
      };

      themes = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Set of themes";
      };

      plugins = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Set of plugins";
      };

      #databaseType = mkOption {
      #  type = types.str;
      #  default = "postgresql";
      #  description = "Type of database";
      #};

      databaseHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Database hostname";
      };

      databasePassword = mkOption {
        type = types.str;
        default = "";
        description = "Database user password";
      };

      databaseName = mkOption {
        type = types.str;
        default = "redmine";
        description = "Database name";
      };

      databaseUsername = mkOption {
        type = types.str;
        default = "redmine";
        description = "Database user";
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.databasePassword != "";
        message = "services.redmine.databasePassword must be set";
      }
    ];

    users.users = [
      { name = "redmine";
        group = "redmine";
        uid = config.ids.uids.redmine;
      } ];

    users.groups = [
      { name = "redmine";
        gid = config.ids.gids.redmine;
      } ];

    systemd.services.redmine = {
      after = [ "network.target" "mysql.service" ]; # postgresql.service
      wantedBy = [ "multi-user.target" ];
      environment.RAILS_ENV = "production";
      environment.RAILS_CACHE = "${cfg.stateDir}/cache";
      environment.SCHEMA = "${cfg.stateDir}/cache/schema.db";
      environment.HOME = "${pkgs.redmine}/share/redmine";
      environment.REDMINE_LANG = "en";
      path = with pkgs; [
        imagemagickBig
        subversion
        mercurial
        cvs
        # config.services.postgresql.package
        libmysql
        bazaar
        gitAndTools.git
        darcs
      ];
      preStart = ''
        rm -rf ${cfg.stateDir}/config

        mkdir -p ${cfg.stateDir}/cache
        mkdir -p ${cfg.stateDir}/config
        mkdir -p ${cfg.stateDir}/files
        mkdir -p ${cfg.stateDir}/log
        mkdir -p ${cfg.stateDir}/plugins
        mkdir -p ${cfg.stateDir}/tmp

        mkdir -p /run/redmine
        ln -fs ${cfg.stateDir}/files /run/redmine/files
        ln -fs ${cfg.stateDir}/log /run/redmine/log
        ln -fs ${cfg.stateDir}/plugins /run/redmine/plugins
        ln -fs ${cfg.stateDir}/tmp /run/redmine/tmp

        cp -r ${pkgs.redmine}/share/redmine/config.dist/* ${cfg.stateDir}/config/
        ln -fs ${cfg.stateDir}/config /run/redmine/config

        ln -fs ${pkgs.writeText "configuration.yml" configurationYml} ${cfg.stateDir}/config/configuration.yml
        ln -fs ${pkgs.writeText "database.yml" databaseYml} ${cfg.stateDir}/config/database.yml

        chown -R redmine:redmine ${cfg.stateDir}
        chmod -R ug+rwX,o-rwx+x ${cfg.stateDir}/

        ${pkgs.redmine}/share/redmine/bin/bundle exec rake generate_secret_token
        ${pkgs.redmine}/share/redmine/bin/bundle exec rake db:migrate
        ${pkgs.redmine}/share/redmine/bin/bundle exec rake redmine:load_default_data
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = "redmine";
        Group = "redmine";
        TimeoutSec = "300";
        WorkingDirectory = "${pkgs.redmine}/share/redmine";
        ExecStart="${pkgs.redmine}/share/redmine/bin/bundle exec rails server webrick -e production -P ${cfg.stateDir}/redmine.pid --binding=0.0.0.0";
      };

    };

  };

}
