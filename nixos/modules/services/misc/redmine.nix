{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.redmine;

  bundle = "${pkgs.redmine}/share/redmine/bin/bundle";

  databaseYml = pkgs.writeText "database.yml" ''
    production:
      adapter: ${cfg.database.type}
      database: ${cfg.database.name}
      host: ${cfg.database.host}
      port: ${toString cfg.database.port}
      username: ${cfg.database.user}
      password: #dbpass#
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

in

{
  options = {
    services.redmine = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Redmine service.";
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

          See https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration
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
          default = "127.0.0.1";
          description = "Database host address.";
        };

        port = mkOption {
          type = types.int;
          default = 3306;
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
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.passwordFile != null || cfg.database.password != "";
        message = "either services.redmine.database.passwordFile or services.redmine.database.password must be set";
      }
    ];

    environment.systemPackages = [ pkgs.redmine ];

    systemd.services.redmine = {
      after = [ "network.target" (if cfg.database.type == "mysql2" then "mysql.service" else "postgresql.service") ];
      wantedBy = [ "multi-user.target" ];
      environment.HOME = "${pkgs.redmine}/share/redmine";
      environment.RAILS_ENV = "production";
      environment.RAILS_CACHE = "${cfg.stateDir}/cache";
      environment.REDMINE_LANG = "en";
      environment.SCHEMA = "${cfg.stateDir}/cache/schema.db";
      path = with pkgs; [
        imagemagickBig
        bazaar
        cvs
        darcs
        gitAndTools.git
        mercurial
        subversion
      ];
      preStart = ''
        # start with a fresh config directory every time
        rm -rf ${cfg.stateDir}/config
        cp -r ${pkgs.redmine}/share/redmine/config.dist ${cfg.stateDir}/config

        # create the basic state directory layout pkgs.redmine expects
        mkdir -p /run/redmine

        for i in config files log plugins tmp; do
          mkdir -p ${cfg.stateDir}/$i
          ln -fs ${cfg.stateDir}/$i /run/redmine/$i
        done

        # ensure cache directory exists for db:migrate command
        mkdir -p ${cfg.stateDir}/cache

        # link in the application configuration
        ln -fs ${configurationYml} ${cfg.stateDir}/config/configuration.yml

        chmod -R ug+rwX,o-rwx+x ${cfg.stateDir}/

        # handle database.passwordFile
        DBPASS=$(head -n1 ${cfg.database.passwordFile})
        cp -f ${databaseYml} ${cfg.stateDir}/config/database.yml
        sed -e "s,#dbpass#,$DBPASS,g" -i ${cfg.stateDir}/config/database.yml
        chmod 440 ${cfg.stateDir}/config/database.yml

        # generate a secret token if required
        if ! test -e "${cfg.stateDir}/config/initializers/secret_token.rb"; then
          ${bundle} exec rake generate_secret_token
          chmod 440 ${cfg.stateDir}/config/initializers/secret_token.rb
        fi

        # ensure everything is owned by ${cfg.user}
        chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir}

        ${bundle} exec rake db:migrate
        ${bundle} exec rake redmine:load_default_data
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        WorkingDirectory = "${pkgs.redmine}/share/redmine";
        ExecStart="${bundle} exec rails server webrick -e production -P ${cfg.stateDir}/redmine.pid";
      };

    };

    users.extraUsers = optionalAttrs (cfg.user == "redmine") (singleton
      { name = "redmine";
        group = cfg.group;
        home = cfg.stateDir;
        createHome = true;
        uid = config.ids.uids.redmine;
      });

    users.extraGroups = optionalAttrs (cfg.group == "redmine") (singleton
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
