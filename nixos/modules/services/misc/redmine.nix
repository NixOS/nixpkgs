{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.redmine;

  bundle = pkgs.writeShellScriptBin "bundle" ''
    export PATH="${config.systemd.services.redmine.path}"
    export RAILS_ENV="production"

    # move the schema from read-only db/ to writable cache/
    export SCHEMA="${cfg.stateDir}/cache/schema.db"

    cd ${cfg.stateDir}
    #export HOME="${cfg.stateDir}"
    #export REDMINE_LANG="en"
    #export RAILS_CACHE="${cfg.stateDir}/cache"
    #export RAILS_ETC="${cfg.stateDir}/config"
    #export RAILS_LOG="${cfg.stateDir}/log"
    #export RAILS_VAR="${cfg.stateDir}/var"
    #export RAILS_PLUGINS="${cfg.stateDir}/plugins"
    #export RAILS_PUBLIC="${cfg.stateDir}/public"
    #export RAILS_TMP="${cfg.stateDir}/tmp"

    # continue with wrapped bundle (setting the BUNDLE_* variables)
    exec ${cfg.package}/share/redmine/bin/bundle "$@"
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

      package = mkOption {
        type = types.package;
        default = pkgs.redmine;
        description = "Redmine package to use.";
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

      config = lib.mkOption {
        type = types.attrsOf types.lines;
        description = ''
          This option defines the Redmine config/.
          The attribute name defines the name of the file in config/,
          and the attribute value defines the content of the file.
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

    environment.systemPackages = [ cfg.package ];

    systemd.services.redmine = {
      after = [ "network.target" (if cfg.database.type == "mysql2" then "mysql.service" else "postgresql.service") ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        imagemagickBig
        bazaar
        cvs
        darcs
        gitAndTools.git
        mercurial
        subversion
        coreutils
        findutils
        gnused
      ];
      preStart = ''
        set -x
        install -D -d -o ${cfg.user} -g ${cfg.group} -m 771 ${cfg.stateDir}

        # preserve existing secret token
        if test -e ${cfg.stateDir}/config/initializers/secret_token.rb; then
          secret_token="$(cat ${cfg.stateDir}/config/initializers/secret_token.rb)"
        else
          secret_token=
        fi

        # clear everything which is not stateful, including config/
        find ${cfg.stateDir} -mindepth 1 -maxdepth 1 \
         -not '(' -name cache -or -name files -or -name log ')' \
         -execdir rm -rf {} +

        # link what's needed to run rake in ${cfg.stateDir},
        # notably the plugins' tasks (see: bundle exec rake --tasks)
        find ${cfg.package}/share/redmine -mindepth 1 -maxdepth 1 \
         -not '(' -name cache -or -name files -or -name log \
              -or -name config -or -name public -or -name tmp ')' \
         -exec ln -fns -t ${cfg.stateDir} {} +

        # create writable dirs
        install -D -d -o ${cfg.user} -g ${cfg.group} -m 770 \
         ${cfg.stateDir}/cache \
         ${cfg.stateDir}/public \
         ${cfg.stateDir}/public/plugin_assets \
         ${cfg.stateDir}/tmp

        # fills public/, keeping public/plugin_assets/ writable
        find ${cfg.package}/share/redmine/public -mindepth 1 -maxdepth 1 \
         -not '(' -name plugin_assets ')' \
         -exec ln -fns -t ${cfg.stateDir}/public {} +

        # expose wrapped bundle for manual maintenance
        ln -fns ${bundle}/bin/bundle ${cfg.stateDir}/bundle

        # fills config/
        cp -r ${cfg.package}/share/redmine/config ${cfg.stateDir}/config
        ${lib.concatStrings (lib.mapAttrsToList
          (name: content: ''
            mkdir -p "$(dirname "${cfg.stateDir}/config/${name}")"
            ln -fns ${pkgs.writeText name content} ${cfg.stateDir}/config/${name}
          '')
          cfg.config)}

        # restore or generate the secret token
        if test -n "$secret_token"; then
          cat >${cfg.stateDir}/config/initializers/secret_token.rb <<EOF
          $secret_token
        EOF
        else
          ${bundle}/bin/bundle exec rake generate_secret_token
        fi
        chmod 440 ${cfg.stateDir}/config/initializers/secret_token.rb

        # handle database.passwordFile
        DBPASS=$(head -n1 ${cfg.database.passwordFile})
        database_yml=$(sed -e "s,#dbpass#,$DBPASS,g" ${cfg.stateDir}/config/database.yml)
        rm -f ${cfg.stateDir}/config/database.yml
        cat >${cfg.stateDir}/config/database.yml <<EOF
        $database_yml
        EOF
        chmod 440 ${cfg.stateDir}/config/database.yml

        # ensure everything is owned by ${cfg.user}
        chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir}
        chmod -R ug+rwX,o-rwx ${cfg.stateDir}

        ${bundle}/bin/bundle exec rake db:migrate
        ${bundle}/bin/bundle exec rake redmine:load_default_data
        ${bundle}/bin/bundle exec rake redmine:plugins:migrate
      '';

      serviceConfig = {
        PermissionsStartOnly = true; # preStart must be run as root
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        WorkingDirectory = "${cfg.package}/share/redmine";
        ExecStart = "${bundle}/bin/bundle exec rails server webrick -e production -P ${cfg.stateDir}/redmine.pid";
      };

    };

    users.extraUsers = optionalAttrs (cfg.user == "redmine") (singleton
      { name = "redmine";
        group = cfg.group;
        home = cfg.stateDir;
        createHome = true;
        uid = config.ids.uids.redmine;
        useDefaultShell = true;
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

    # Here and not in options' default= to be able to override
    # individual attribute (eg. "configuration.yml") with lib.mkForce
    # but keep the unchanged attributes (eg. "database.yml").
    services.redmine.config = {
      "database.yml" = ''
        production:
          adapter: ${cfg.database.type}
          database: ${cfg.database.name}
          host: ${cfg.database.host}
          port: ${toString cfg.database.port}
          username: ${cfg.database.user}
          password: #dbpass#
      '';
      "configuration.yml" = ''
        default:
          scm_subversion_command: ${pkgs.subversion}/bin/svn
          scm_mercurial_command: ${pkgs.mercurial}/bin/hg
          scm_git_command: ${pkgs.gitAndTools.git}/bin/git
          scm_cvs_command: ${pkgs.cvs}/bin/cvs
          scm_bazaar_command: ${pkgs.bazaar}/bin/bzr
          scm_darcs_command: ${pkgs.darcs}/bin/darcs
      '';
    };

  };

}
