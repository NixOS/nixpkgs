{ config, lib, pkgs, ... }:

# TODO: support non-postgresql

with lib;

let
  cfg = config.services.redmine;

  ruby = pkgs.ruby;

  databaseYml = ''
    production:
      adapter: postgresql
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
      scm_stderr_log_file: ${cfg.stateDir}/redmine_scm_stderr.log

      ${cfg.extraConfig}
  '';

  unpackTheme = unpack "theme";
  unpackPlugin = unpack "plugin";
  unpack = id: (name: source:
    pkgs.stdenv.mkDerivation {
      name = "redmine-${id}-${name}";
      buildInputs = [ pkgs.unzip ];
      buildCommand = ''
        mkdir -p $out
        cd $out
        unpackFile ${source}
      '';
    });

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
        default = "/var/redmine";
        description = "The state directory, logs and plugins are stored here";
      };

      extraConfig = mkOption {
        type = types.str;
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

    users.extraUsers = [
      { name = "redmine";
        group = "redmine";
        uid = config.ids.uids.redmine;
      } ];

    users.extraGroups = [
      { name = "redmine";
        gid = config.ids.gids.redmine;
      } ];

    systemd.services.redmine = {
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      environment.RAILS_ENV = "production";
      environment.RAILS_ETC = "${cfg.stateDir}/config";
      environment.RAILS_LOG = "${cfg.stateDir}/log";
      environment.RAILS_VAR = "${cfg.stateDir}/var";
      environment.RAILS_CACHE = "${cfg.stateDir}/cache";
      environment.RAILS_PLUGINS = "${cfg.stateDir}/plugins";
      environment.RAILS_PUBLIC = "${cfg.stateDir}/public";
      environment.RAILS_TMP = "${cfg.stateDir}/tmp";
      environment.SCHEMA = "${cfg.stateDir}/cache/schema.db";
      environment.HOME = "${pkgs.redmine}/share/redmine";
      environment.REDMINE_LANG = "en";
      environment.GEM_HOME = "${pkgs.redmine}/share/redmine/vendor/bundle/ruby/1.9.1";
      environment.GEM_PATH = "${pkgs.bundler}/${pkgs.bundler.ruby.gemPath}";
      path = with pkgs; [
        imagemagickBig
        subversion
        mercurial
        cvs
        config.services.postgresql.package
        bazaar
        gitAndTools.git
        # once we build binaries for darc enable it
        #darcs
      ];
      preStart = ''
        # TODO: use env vars
        for i in plugins public/plugin_assets db files log config cache var/files tmp; do
          mkdir -p ${cfg.stateDir}/$i
        done

        chown -R redmine:redmine ${cfg.stateDir}
        chmod -R 755 ${cfg.stateDir}

        rm -rf ${cfg.stateDir}/public/*
        cp -R ${pkgs.redmine}/share/redmine/public/* ${cfg.stateDir}/public/
        for theme in ${concatStringsSep " " (mapAttrsToList unpackTheme cfg.themes)}; do
          ln -fs $theme/* ${cfg.stateDir}/public/themes/
        done

        rm -rf ${cfg.stateDir}/plugins/*
        for plugin in ${concatStringsSep " " (mapAttrsToList unpackPlugin cfg.plugins)}; do
          ln -fs $plugin/* ${cfg.stateDir}/plugins/''${plugin##*-redmine-plugin-}
        done

        ln -fs ${pkgs.writeText "database.yml" databaseYml} ${cfg.stateDir}/config/database.yml
        ln -fs ${pkgs.writeText "configuration.yml" configurationYml} ${cfg.stateDir}/config/configuration.yml

        if [ "${cfg.databaseHost}" = "127.0.0.1" ]; then
          if ! test -e "${cfg.stateDir}/db-created"; then
            psql postgres -c "CREATE ROLE redmine WITH LOGIN NOCREATEDB NOCREATEROLE NOCREATEUSER ENCRYPTED PASSWORD '${cfg.databasePassword}'"
            ${config.services.postgresql.package}/bin/createdb --owner redmine redmine || true
            touch "${cfg.stateDir}/db-created"
          fi
        fi

        cd ${pkgs.redmine}/share/redmine/
        ${ruby}/bin/rake db:migrate
        ${ruby}/bin/rake redmine:plugins:migrate
        ${ruby}/bin/rake redmine:load_default_data
        ${ruby}/bin/rake generate_secret_token
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = "redmine";
        Group = "redmine";
        TimeoutSec = "300";
        WorkingDirectory = "${pkgs.redmine}/share/redmine";
        ExecStart="${ruby}/bin/ruby ${pkgs.redmine}/share/redmine/script/rails server webrick -e production -P ${cfg.stateDir}/redmine.pid";
      };

    };

  };

}
