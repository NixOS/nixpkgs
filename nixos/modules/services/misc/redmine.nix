{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.redmine;
  format = pkgs.formats.yaml { };
  bundle = "${cfg.package}/share/redmine/bin/bundle";

  databaseSettings = {
    production = {
      adapter = cfg.database.type;
      database =
        if cfg.database.type == "sqlite3" then "${cfg.stateDir}/database.sqlite3" else cfg.database.name;
    }
    // lib.optionalAttrs (cfg.database.type != "sqlite3") {
      host =
        if (cfg.database.type == "postgresql" && cfg.database.socket != null) then
          cfg.database.socket
        else
          cfg.database.host;
      port = cfg.database.port;
      username = cfg.database.user;
    }
    // lib.optionalAttrs (cfg.database.type != "sqlite3" && cfg.database.passwordFile != null) {
      password = "#dbpass#";
    }
    // lib.optionalAttrs (cfg.database.type == "mysql2" && cfg.database.socket != null) {
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
    (lib.mkRemovedOptionModule [
      "services"
      "redmine"
      "extraConfig"
    ] "Use services.redmine.settings instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "redmine"
      "database"
      "password"
    ] "Use services.redmine.database.passwordFile instead.")
  ];

  # interface
  options = {
    services.redmine = {
      enable = lib.mkEnableOption "Redmine, a project management web application";

      package = lib.mkPackageOption pkgs "redmine" {
        example = "redmine.override { ruby = pkgs.ruby_3_2; }";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "redmine";
        description = "User under which Redmine is ran.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "redmine";
        description = "Group under which Redmine is ran.";
      };

      address = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "IP address Redmine should bind to.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Port on which Redmine is ran.";
      };

      stateDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/redmine";
        description = "The state directory, logs and plugins are stored here.";
      };

      settings = lib.mkOption {
        type = format.type;
        default = { };
        description = ''
          Redmine configuration ({file}`configuration.yml`). Refer to
          <https://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration>
          for details.
        '';
        example = lib.literalExpression ''
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

      extraEnv = lib.mkOption {
        type = lib.types.lines;
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

      themes = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        description = "Set of themes.";
        example = lib.literalExpression ''
          {
            dkuk-redmine_alex_skin = builtins.fetchurl {
              url = "https://bitbucket.org/dkuk/redmine_alex_skin/get/1842ef675ef3.zip";
              sha256 = "0hrin9lzyi50k4w2bd2b30vrf1i4fi1c0gyas5801wn8i7kpm9yl";
            };
          }
        '';
      };

      plugins = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        description = "Set of plugins.";
        example = lib.literalExpression ''
          {
            redmine_env_auth = builtins.fetchurl {
              url = "https://github.com/Intera/redmine_env_auth/archive/0.6.zip";
              sha256 = "0yyr1yjd8gvvh832wdc8m3xfnhhxzk2pk3gm2psg5w9jdvd6skak";
            };
          }
        '';
      };

      database = {
        type = lib.mkOption {
          type = lib.types.enum [
            "mysql2"
            "postgresql"
            "sqlite3"
          ];
          example = "postgresql";
          default = "mysql2";
          description = "Database engine to use.";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = "Database host address.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = if cfg.database.type == "postgresql" then 5432 else 3306;
          defaultText = lib.literalExpression "3306";
          description = "Database host port.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "redmine";
          description = "Database name.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "redmine";
          description = "Database user.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/redmine-dbpassword";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        socket = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default =
            if mysqlLocal then
              "/run/mysqld/mysqld.sock"
            else if pgsqlLocal then
              "/run/postgresql"
            else
              null;
          defaultText = lib.literalExpression "/run/mysqld/mysqld.sock";
          example = "/run/mysqld/mysqld.sock";
          description = "Path to the unix socket file to use for authentication.";
        };

        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Create the database and database user locally.";
        };
      };

      components = {
        subversion = lib.mkEnableOption "Subversion integration.";

        mercurial = lib.mkEnableOption "Mercurial integration.";

        git = lib.mkEnableOption "git integration.";

        cvs = lib.mkEnableOption "cvs integration.";

        breezy = lib.mkEnableOption "bazaar integration.";

        imagemagick = lib.mkEnableOption "exporting Gant diagrams as PNG.";

        ghostscript = lib.mkEnableOption "exporting Gant diagrams as PDF.";

        minimagick_font_path = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "MiniMagick font path";
          example = "/run/current-system/sw/share/X11/fonts/LiberationSans-Regular.ttf";
        };
      };
    };
  };

  # implementation
  config = lib.mkIf cfg.enable {
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
        scm_subversion_command = lib.optionalString cfg.components.subversion "${pkgs.subversion}/bin/svn";
        scm_mercurial_command = lib.optionalString cfg.components.mercurial "${pkgs.mercurial}/bin/hg";
        scm_git_command = lib.optionalString cfg.components.git "${pkgs.git}/bin/git";
        scm_cvs_command = lib.optionalString cfg.components.cvs "${pkgs.cvs}/bin/cvs";
        scm_bazaar_command = lib.optionalString cfg.components.breezy "${pkgs.breezy}/bin/bzr";
        imagemagick_convert_command = lib.optionalString cfg.components.imagemagick "${pkgs.imagemagick}/bin/convert";
        gs_command = lib.optionalString cfg.components.ghostscript "${pkgs.ghostscript}/bin/gs";
        minimagick_font_path = "${cfg.components.minimagick_font_path}";
      };
    };

    services.redmine.extraEnv = lib.mkBefore ''
      config.logger = Logger.new("${cfg.stateDir}/log/production.log", 14, 1048576)
      config.logger.level = Logger::INFO
    '';

    services.mysql = lib.mkIf mysqlLocal {
      enable = true;
      package = lib.mkDefault pkgs.mariadb;
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

    services.postgresql = lib.mkIf pgsqlLocal {
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
      "d '${cfg.stateDir}/public/assets' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/public/plugin_assets' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/themes' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/tmp' 0750 ${cfg.user} ${cfg.group} - -"

      "d /run/redmine/public - - - - -"
      "L+ /run/redmine/config - - - - ${cfg.stateDir}/config"
      "L+ /run/redmine/files - - - - ${cfg.stateDir}/files"
      "L+ /run/redmine/log - - - - ${cfg.stateDir}/log"
      "L+ /run/redmine/plugins - - - - ${cfg.stateDir}/plugins"
      "L+ /run/redmine/public/assets - - - - ${cfg.stateDir}/public/assets"
      "L+ /run/redmine/public/plugin_assets - - - - ${cfg.stateDir}/public/plugin_assets"
      "L+ /run/redmine/themes - - - - ${cfg.stateDir}/themes"
      "L+ /run/redmine/tmp - - - - ${cfg.stateDir}/tmp"
    ];

    systemd.services.redmine = {
      after = [
        "network.target"
      ]
      ++ lib.optional mysqlLocal "mysql.service"
      ++ lib.optional pgsqlLocal "postgresql.target";
      wantedBy = [ "multi-user.target" ];
      environment.RAILS_ENV = "production";
      environment.RAILS_CACHE = "${cfg.stateDir}/cache";
      environment.REDMINE_LANG = "en";
      environment.SCHEMA = "${cfg.stateDir}/cache/schema.db";
      path =
        with pkgs;
        [
        ]
        ++ lib.optional cfg.components.subversion subversion
        ++ lib.optional cfg.components.mercurial mercurial
        ++ lib.optional cfg.components.git git
        ++ lib.optional cfg.components.cvs cvs
        ++ lib.optional cfg.components.breezy breezy
        ++ lib.optional cfg.components.imagemagick imagemagick
        ++ lib.optional cfg.components.ghostscript ghostscript;

      preStart = ''
        rm -rf "${cfg.stateDir}/plugins/"*
        rm -rf "${cfg.stateDir}/themes/"*

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
        for theme in ${lib.concatStringsSep " " (lib.mapAttrsToList unpackTheme cfg.themes)}; do
          ln -fs $theme/* "${cfg.stateDir}/themes"
        done

        # link in redmine provided themes
        ln -sf ${cfg.package}/share/redmine/themes.dist/* "${cfg.stateDir}/themes/"


        # link in all user specified plugins
        for plugin in ${lib.concatStringsSep " " (lib.mapAttrsToList unpackPlugin cfg.plugins)}; do
          ln -fs $plugin/* "${cfg.stateDir}/plugins/''${plugin##*-redmine-plugin-}"
        done


        # handle database.passwordFile & permissions
        cp -f ${databaseYml} "${cfg.stateDir}/config/database.yml"

        ${lib.optionalString ((cfg.database.type != "sqlite3") && (cfg.database.passwordFile != null)) ''
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
        ${bundle} exec rake assets:precompile
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        WorkingDirectory = "${cfg.package}/share/redmine";
        ExecStart = "${bundle} exec rails server -u webrick -e production -b ${toString cfg.address} -p ${toString cfg.port} -P '${cfg.stateDir}/redmine.pid'";
        RuntimeDirectory = "redmine";
        RuntimeDirectoryMode = "0750";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
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
        ProtectSystem = "strict";
        ReadWritePaths = [
          cfg.stateDir
        ];
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

    users.users = lib.optionalAttrs (cfg.user == "redmine") {
      redmine = {
        group = cfg.group;
        home = cfg.stateDir;
        uid = config.ids.uids.redmine;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "redmine") {
      redmine.gid = config.ids.gids.redmine;
    };
  };

  meta.maintainers = with lib.maintainers; [ felixsinger ];
}
