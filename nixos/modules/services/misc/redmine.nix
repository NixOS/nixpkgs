{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption types;
  inherit (lib) concatStringsSep literalExample mapAttrsToList;
  inherit (lib) optional optionalAttrs optionalString singleton versionAtLeast;

  cfg = config.services.redmine;

  bundle = "${cfg.package}/share/redmine/bin/bundle";

  databaseYml = pkgs.writeText "database.yml" ''
    production:
      adapter: ${cfg.database.type}
      database: ${cfg.database.name}
      host: ${if (cfg.database.type == "postgresql" && cfg.database.socket != null) then cfg.database.socket else cfg.database.host}
      port: ${toString cfg.database.port}
      username: ${cfg.database.user}
      password: #dbpass#
      ${optionalString (cfg.database.type == "mysql2" && cfg.database.socket != null) "socket: ${cfg.database.socket}"}
  '';

  configurationYml = pkgs.writeText "configuration.yml" ''
    default:
      scm_subversion_command: ${pkgs.subversion}/bin/svn
      scm_mercurial_command: ${pkgs.mercurial}/bin/hg
      scm_git_command: ${pkgs.gitAndTools.git}/bin/git
      scm_cvs_command: ${pkgs.cvs}/bin/cvs
      scm_bazaar_command: ${pkgs.bazaar}/bin/bzr
      scm_darcs_command: ${pkgs.darcs}/bin/darcs

    ${cfg.extraConfig}
  '';

  additionalEnvironment = pkgs.writeText "additional_environment.rb" ''
    config.logger = Logger.new("${cfg.stateDir}/log/production.log", 14, 1048576)
    config.logger.level = Logger::INFO

    ${cfg.extraEnv}
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

  mysqlLocal = cfg.database.createLocally && cfg.database.type == "mysql2";
  pgsqlLocal = cfg.database.createLocally && cfg.database.type == "postgresql";

in

{
  options = {
    services.redmine = {
      enable = mkEnableOption "Redmine";

      # default to the 4.x series not forcing major version upgrade of those on the 3.x series
      package = mkOption {
        type = types.package;
        default = if versionAtLeast config.system.stateVersion "19.03"
          then pkgs.redmine_4
          else pkgs.redmine
        ;
        defaultText = "pkgs.redmine";
        description = ''
          Which Redmine package to use. This defaults to version 3.x if
          <literal>system.stateVersion &lt; 19.03</literal> and version 4.x
          otherwise.
        '';
        example = "pkgs.redmine_4.override { ruby = pkgs.ruby_2_4; }";
      };

      user = mkOption {
        type = types.str;
        default = "redmine";
        description = "User under which Redmine is ran.";
      };

      group = mkOption {
        type = types.str;
        default = "redmine";
        description = "Group under which Redmine is ran.";
      };

      port = mkOption {
        type = types.int;
        default = 3000;
        description = "Port on which Redmine is ran.";
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/redmine";
        description = "The state directory, logs and plugins are stored here.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration in configuration.yml.

          See <link xlink:href="https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration"/>
          for details.
        '';
        example = literalExample ''
          email_delivery:
            delivery_method: smtp
            smtp_settings:
              address: mail.example.com
              port: 25
        '';
      };

      extraEnv = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration in additional_environment.rb.

          See <link xlink:href="https://svn.redmine.org/redmine/trunk/config/additional_environment.rb.example"/>
          for details.
        '';
        example = literalExample ''
          config.logger.level = Logger::DEBUG
        '';
      };

      themes = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Set of themes.";
        example = literalExample ''
          {
            dkuk-redmine_alex_skin = builtins.fetchurl {
              url = https://bitbucket.org/dkuk/redmine_alex_skin/get/1842ef675ef3.zip;
              sha256 = "0hrin9lzyi50k4w2bd2b30vrf1i4fi1c0gyas5801wn8i7kpm9yl";
            };
          }
        '';
      };

      plugins = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Set of plugins.";
        example = literalExample ''
          {
            redmine_env_auth = builtins.fetchurl {
              url = https://github.com/Intera/redmine_env_auth/archive/0.6.zip;
              sha256 = "0yyr1yjd8gvvh832wdc8m3xfnhhxzk2pk3gm2psg5w9jdvd6skak";
            };
          }
        '';
      };

      database = {
        type = mkOption {
          type = types.enum [ "mysql2" "postgresql" ];
          example = "postgresql";
          default = "mysql2";
          description = "Database engine to use.";
        };

        host = mkOption {
          type = types.str;
          default = "localhost";
          description = "Database host address.";
        };

        port = mkOption {
          type = types.int;
          default = if cfg.database.type == "postgresql" then 5432 else 3306;
          defaultText = "3306";
          description = "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "redmine";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "redmine";
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
          example = "/run/keys/redmine-dbpassword";
          description = ''
            A file containing the password corresponding to
            <option>database.user</option>.
          '';
        };

        socket = mkOption {
          type = types.nullOr types.path;
          default =
            if mysqlLocal then "/run/mysqld/mysqld.sock"
            else if pgsqlLocal then "/run/postgresql"
            else null;
          defaultText = "/run/mysqld/mysqld.sock";
          example = "/run/mysqld/mysqld.sock";
          description = "Path to the unix socket file to use for authentication.";
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = "Create the database and database user locally.";
        };
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.passwordFile != null || cfg.database.password != "" || cfg.database.socket != null;
        message = "one of services.redmine.database.socket, services.redmine.database.passwordFile, or services.redmine.database.password must be set";
      }
      { assertion = cfg.database.createLocally -> cfg.database.user == cfg.user;
        message = "services.redmine.database.user must be set to ${cfg.user} if services.redmine.database.createLocally is set true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.socket != null;
        message = "services.redmine.database.socket must be set if services.redmine.database.createLocally is set to true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.host == "localhost";
        message = "services.redmine.database.host must be set to localhost if services.redmine.database.createLocally is set to true";
      }
    ];

    services.mysql = mkIf mysqlLocal {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.postgresql = mkIf pgsqlLocal {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES"; };
        }
      ];
    };

    # create symlinks for the basic directory layout the redmine package expects
    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/cache' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/config' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/files' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/log' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/plugins' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/public' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/public/plugin_assets' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/public/themes' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/tmp' 0750 ${cfg.user} ${cfg.group} - -"

      "d /run/redmine - - - - -"
      "d /run/redmine/public - - - - -"
      "L+ /run/redmine/config - - - - ${cfg.stateDir}/config"
      "L+ /run/redmine/files - - - - ${cfg.stateDir}/files"
      "L+ /run/redmine/log - - - - ${cfg.stateDir}/log"
      "L+ /run/redmine/plugins - - - - ${cfg.stateDir}/plugins"
      "L+ /run/redmine/public/plugin_assets - - - - ${cfg.stateDir}/public/plugin_assets"
      "L+ /run/redmine/public/themes - - - - ${cfg.stateDir}/public/themes"
      "L+ /run/redmine/tmp - - - - ${cfg.stateDir}/tmp"
    ];

    systemd.services.redmine = {
      after = [ "network.target" ] ++ optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";
      wantedBy = [ "multi-user.target" ];
      environment.RAILS_ENV = "production";
      environment.RAILS_CACHE = "${cfg.stateDir}/cache";
      environment.REDMINE_LANG = "en";
      environment.SCHEMA = "${cfg.stateDir}/cache/schema.db";
      path = with pkgs; [
        imagemagick
        bazaar
        cvs
        darcs
        gitAndTools.git
        mercurial
        subversion
      ];
      preStart = ''
        rm -rf "${cfg.stateDir}/plugins/"*
        rm -rf "${cfg.stateDir}/public/themes/"*

        # start with a fresh config directory
        # the config directory is copied instead of linked as some mutable data is stored in there
        find "${cfg.stateDir}/config" ! -name "secret_token.rb" -type f -exec rm -f {} +
        cp -r ${cfg.package}/share/redmine/config.dist/* "${cfg.stateDir}/config/"

        chmod -R u+w "${cfg.stateDir}/config"

        # link in the application configuration
        ln -fs ${configurationYml} "${cfg.stateDir}/config/configuration.yml"

        # link in the additional environment configuration
        ln -fs ${additionalEnvironment} "${cfg.stateDir}/config/additional_environment.rb"


        # link in all user specified themes
        for theme in ${concatStringsSep " " (mapAttrsToList unpackTheme cfg.themes)}; do
          ln -fs $theme/* "${cfg.stateDir}/public/themes"
        done

        # link in redmine provided themes
        ln -sf ${cfg.package}/share/redmine/public/themes.dist/* "${cfg.stateDir}/public/themes/"


        # link in all user specified plugins
        for plugin in ${concatStringsSep " " (mapAttrsToList unpackPlugin cfg.plugins)}; do
          ln -fs $plugin/* "${cfg.stateDir}/plugins/''${plugin##*-redmine-plugin-}"
        done


        # handle database.passwordFile & permissions
        DBPASS=$(head -n1 ${cfg.database.passwordFile})
        cp -f ${databaseYml} "${cfg.stateDir}/config/database.yml"
        sed -e "s,#dbpass#,$DBPASS,g" -i "${cfg.stateDir}/config/database.yml"
        chmod 440 "${cfg.stateDir}/config/database.yml"


        # generate a secret token if required
        if ! test -e "${cfg.stateDir}/config/initializers/secret_token.rb"; then
          ${bundle} exec rake generate_secret_token
          chmod 440 "${cfg.stateDir}/config/initializers/secret_token.rb"
        fi

        # execute redmine required commands prior to starting the application
        ${bundle} exec rake db:migrate
        ${bundle} exec rake redmine:plugins:migrate
        ${bundle} exec rake redmine:load_default_data
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        WorkingDirectory = "${cfg.package}/share/redmine";
        ExecStart="${bundle} exec rails server webrick -e production -p ${toString cfg.port} -P '${cfg.stateDir}/redmine.pid'";
      };

    };

    users.users = optionalAttrs (cfg.user == "redmine") (singleton
      { name = "redmine";
        group = cfg.group;
        home = cfg.stateDir;
        uid = config.ids.uids.redmine;
      });

    users.groups = optionalAttrs (cfg.group == "redmine") (singleton
      { name = "redmine";
        gid = config.ids.gids.redmine;
      });

    warnings = optional (cfg.database.password != "")
      ''config.services.redmine.database.password will be stored as plaintext
      in the Nix store. Use database.passwordFile instead.'';

    # Create database passwordFile default when password is configured.
    services.redmine.database.passwordFile =
      (mkDefault (toString (pkgs.writeTextFile {
        name = "redmine-database-password";
        text = cfg.database.password;
      })));

  };

}
