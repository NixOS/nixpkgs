{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkBefore
    mkDefault
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    mkRemovedOptionModule
    types
    ;
  inherit (lib) concatStringsSep literalExpression mapAttrsToList;
  inherit (lib) optional optionalAttrs optionalString;

  cfg = config.services.redmine;
  format = pkgs.formats.yaml { };
  bundle = "${cfg.package}/share/redmine/bin/bundle";

  databaseSettings = {
    production =
      {
        adapter = cfg.database.type;
        database =
          if cfg.database.type == "sqlite3" then "${cfg.stateDir}/database.sqlite3" else cfg.database.name;
      }
      // optionalAttrs (cfg.database.type != "sqlite3") {
        host =
          if (cfg.database.type == "postgresql" && cfg.database.socket != null) then
            cfg.database.socket
          else
            cfg.database.host;
        port = cfg.database.port;
        username = cfg.database.user;
      }
      // optionalAttrs (cfg.database.type != "sqlite3" && cfg.database.passwordFile != null) {
        password = "#dbpass#";
      }
      // optionalAttrs (cfg.database.type == "mysql2" && cfg.database.socket != null) {
        socket = cfg.database.socket;
      };
  };

  databaseYml = format.generate "database.yml" databaseSettings;

  configurationYml = format.generate "configuration.yml" cfg.settings;
  additionalEnvironment = pkgs.writeText "additional_environment.rb" cfg.extraEnv;

  unpackTheme = unpack "theme";
  unpackPlugin = unpack "plugin";
  unpack =
    id:
    (
      name: source:
      pkgs.stdenv.mkDerivation {
        name = "redmine-${id}-${name}";
        nativeBuildInputs = [ pkgs.unzip ];
        buildCommand = ''
          mkdir -p $out
          cd $out
          unpackFile ${source}
        '';
      }
    );

  mysqlLocal = cfg.database.createLocally && cfg.database.type == "mysql2";
  pgsqlLocal = cfg.database.createLocally && cfg.database.type == "postgresql";

in
{
  imports = [
    (mkRemovedOptionModule [
      "services"
      "redmine"
      "extraConfig"
    ] "Use services.redmine.settings instead.")
    (mkRemovedOptionModule [
      "services"
      "redmine"
      "database"
      "password"
    ] "Use services.redmine.database.passwordFile instead.")
  ];

  # interface
  options = {
    services.redmine = {
      enable = mkEnableOption "Redmine, a project management web application";

      package = mkPackageOption pkgs "redmine" {
        example = "redmine.override { ruby = pkgs.ruby_3_2; }";
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

      address = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "IP address Redmine should bind to.";
      };

      port = mkOption {
        type = types.port;
        default = 3000;
        description = "Port on which Redmine is ran.";
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/redmine";
        description = "The state directory, logs and plugins are stored here.";
      };

      settings = mkOption {
        type = format.type;
        default = { };
        description = ''
          Redmine configuration ({file}`configuration.yml`). Refer to
          <https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration>
          for details.
        '';
        example = literalExpression ''
          {
            email_delivery = {
              delivery_method = "smtp";
              smtp_settings = {
                address = "mail.example.com";
                port = 25;
              };
            };
          }
        '';
      };

      extraEnv = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration in additional_environment.rb.

          See <https://svn.redmine.org/redmine/trunk/config/additional_environment.rb.example>
          for details.
        '';
        example = ''
          config.logger.level = Logger::DEBUG
        '';
      };

      themes = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = "Set of themes.";
        example = literalExpression ''
          {
            dkuk-redmine_alex_skin = builtins.fetchurl {
              url = "https://bitbucket.org/dkuk/redmine_alex_skin/get/1842ef675ef3.zip";
              sha256 = "0hrin9lzyi50k4w2bd2b30vrf1i4fi1c0gyas5801wn8i7kpm9yl";
            };
          }
        '';
      };

      plugins = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = "Set of plugins.";
        example = literalExpression ''
          {
            redmine_env_auth = builtins.fetchurl {
              url = "https://github.com/Intera/redmine_env_auth/archive/0.6.zip";
              sha256 = "0yyr1yjd8gvvh832wdc8m3xfnhhxzk2pk3gm2psg5w9jdvd6skak";
            };
          }
        '';
      };

      database = {
        type = mkOption {
          type = types.enum [
            "mysql2"
            "postgresql"
            "sqlite3"
          ];
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
          type = types.port;
          default = if cfg.database.type == "postgresql" then 5432 else 3306;
          defaultText = literalExpression "3306";
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

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/redmine-dbpassword";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        socket = mkOption {
          type = types.nullOr types.path;
          default =
            if mysqlLocal then
              "/run/mysqld/mysqld.sock"
            else if pgsqlLocal then
              "/run/postgresql"
            else
              null;
          defaultText = literalExpression "/run/mysqld/mysqld.sock";
          example = "/run/mysqld/mysqld.sock";
          description = "Path to the unix socket file to use for authentication.";
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = "Create the database and database user locally.";
        };
      };

      components = {
        subversion = mkOption {
          type = types.bool;
          default = false;
          description = "Subversion integration.";
        };

        mercurial = mkOption {
          type = types.bool;
          default = false;
          description = "Mercurial integration.";
        };

        git = mkOption {
          type = types.bool;
          default = false;
          description = "git integration.";
        };

        cvs = mkOption {
          type = types.bool;
          default = false;
          description = "cvs integration.";
        };

        breezy = mkOption {
          type = types.bool;
          default = false;
          description = "bazaar integration.";
        };

        imagemagick = mkOption {
          type = types.bool;
          default = false;
          description = "Allows exporting Gant diagrams as PNG.";
        };

        ghostscript = mkOption {
          type = types.bool;
          default = false;
          description = "Allows exporting Gant diagrams as PDF.";
        };

        minimagick_font_path = mkOption {
          type = types.str;
          default = "";
          description = "MiniMagick font path";
          example = "/run/current-system/sw/share/X11/fonts/LiberationSans-Regular.ttf";
        };
      };
    };
  };

  # implementation
  config = mkIf cfg.enable {

    assertions = [
      {
        assertion =
          cfg.database.type != "sqlite3" -> cfg.database.passwordFile != null || cfg.database.socket != null;
        message = "one of services.redmine.database.socket or services.redmine.database.passwordFile must be set";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.user == cfg.user;
        message = "services.redmine.database.user must be set to ${cfg.user} if services.redmine.database.createLocally is set true";
      }
      {
        assertion = pgsqlLocal -> cfg.database.user == cfg.database.name;
        message = "services.redmine.database.user and services.redmine.database.name must be the same when using a local postgresql database";
      }
      {
        assertion =
          (cfg.database.createLocally && cfg.database.type != "sqlite3") -> cfg.database.socket != null;
        message = "services.redmine.database.socket must be set if services.redmine.database.createLocally is set to true and no sqlite database is used";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.host == "localhost";
        message = "services.redmine.database.host must be set to localhost if services.redmine.database.createLocally is set to true";
      }
      {
        assertion = cfg.components.imagemagick -> cfg.components.minimagick_font_path != "";
        message = "services.redmine.components.minimagick_font_path must be configured with a path to a font file if services.redmine.components.imagemagick is set to true.";
      }
    ];

    services.redmine.settings = {
      production = {
        scm_subversion_command = optionalString cfg.components.subversion "${pkgs.subversion}/bin/svn";
        scm_mercurial_command = optionalString cfg.components.mercurial "${pkgs.mercurial}/bin/hg";
        scm_git_command = optionalString cfg.components.git "${pkgs.git}/bin/git";
        scm_cvs_command = optionalString cfg.components.cvs "${pkgs.cvs}/bin/cvs";
        scm_bazaar_command = optionalString cfg.components.breezy "${pkgs.breezy}/bin/bzr";
        imagemagick_convert_command = optionalString cfg.components.imagemagick "${pkgs.imagemagick}/bin/convert";
        gs_command = optionalString cfg.components.ghostscript "${pkgs.ghostscript}/bin/gs";
        minimagick_font_path = "${cfg.components.minimagick_font_path}";
      };
    };

    services.redmine.extraEnv = mkBefore ''
      config.logger = Logger.new("${cfg.stateDir}/log/production.log", 14, 1048576)
      config.logger.level = Logger::INFO
    '';

    services.mysql = mkIf mysqlLocal {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.postgresql = mkIf pgsqlLocal {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
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
      after =
        [ "network.target" ]
        ++ optional mysqlLocal "mysql.service"
        ++ optional pgsqlLocal "postgresql.service";
      wantedBy = [ "multi-user.target" ];
      environment.RAILS_ENV = "production";
      environment.RAILS_CACHE = "${cfg.stateDir}/cache";
      environment.REDMINE_LANG = "en";
      environment.SCHEMA = "${cfg.stateDir}/cache/schema.db";
      path =
        with pkgs;
        [
        ]
        ++ optional cfg.components.subversion subversion
        ++ optional cfg.components.mercurial mercurial
        ++ optional cfg.components.git git
        ++ optional cfg.components.cvs cvs
        ++ optional cfg.components.breezy breezy
        ++ optional cfg.components.imagemagick imagemagick
        ++ optional cfg.components.ghostscript ghostscript;

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
        cp -f ${databaseYml} "${cfg.stateDir}/config/database.yml"

        ${optionalString ((cfg.database.type != "sqlite3") && (cfg.database.passwordFile != null)) ''
          DBPASS="$(head -n1 ${cfg.database.passwordFile})"
          sed -e "s,#dbpass#,$DBPASS,g" -i "${cfg.stateDir}/config/database.yml"
        ''}

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
        ExecStart = "${bundle} exec rails server -u webrick -e production -b ${toString cfg.address} -p ${toString cfg.port} -P '${cfg.stateDir}/redmine.pid'";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "noaccess";
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 27;
      };

    };

    users.users = optionalAttrs (cfg.user == "redmine") {
      redmine = {
        group = cfg.group;
        home = cfg.stateDir;
        uid = config.ids.uids.redmine;
      };
    };

    users.groups = optionalAttrs (cfg.group == "redmine") {
      redmine.gid = config.ids.gids.redmine;
    };

  };

  meta.maintainers = with lib.maintainers; [ felixsinger ];
}
