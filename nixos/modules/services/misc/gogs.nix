{ config, lib, options, pkgs, ... }:
let
  cfg = config.services.gogs;
  opt = options.services.gogs;
  configFile = pkgs.writeText "app.ini" ''
    BRAND_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod

    [database]
    TYPE = ${cfg.database.type}
    HOST = ${cfg.database.host}:${toString cfg.database.port}
    NAME = ${cfg.database.name}
    USER = ${cfg.database.user}
    PASSWORD = #dbpass#
    PATH = ${cfg.database.path}

    [repository]
    ROOT = ${cfg.repositoryRoot}

    [server]
    DOMAIN = ${cfg.domain}
    HTTP_ADDR = ${cfg.httpAddress}
    HTTP_PORT = ${toString cfg.httpPort}
    EXTERNAL_URL = ${cfg.rootUrl}

    [session]
    COOKIE_NAME = session
    COOKIE_SECURE = ${lib.boolToString cfg.cookieSecure}

    [security]
    SECRET_KEY = #secretkey#
    INSTALL_LOCK = true

    [log]
    ROOT_PATH = ${cfg.stateDir}/log

    ${cfg.extraConfig}
  '';
in

{
  options = {
    services.gogs = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Enable Go Git Service.";
      };

      useWizard = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Do not generate a configuration and use Gogs' installation wizard instead. The first registered user will be administrator.";
      };

      stateDir = lib.mkOption {
        default = "/var/lib/gogs";
        type = lib.types.str;
        description = "Gogs data directory.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "gogs";
        description = "User account under which Gogs runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "gogs";
        description = "Group account under which Gogs runs.";
      };

      database = {
        type = lib.mkOption {
          type = lib.types.enum [ "sqlite3" "mysql" "postgres" ];
          example = "mysql";
          default = "sqlite3";
          description = "Database engine to use.";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Database host address.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 3306;
          description = "Database host port.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "gogs";
          description = "Database name.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "gogs";
          description = "Database user.";
        };

        password = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = ''
            The password corresponding to {option}`database.user`.
            Warning: this is stored in cleartext in the Nix store!
            Use {option}`database.passwordFile` instead.
          '';
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/gogs-dbpassword";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        path = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.stateDir}/data/gogs.db";
          defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/data/gogs.db"'';
          description = "Path to the sqlite3 database file.";
        };
      };

      appName = lib.mkOption {
        type = lib.types.str;
        default = "Gogs: Go Git Service";
        description = "Application name.";
      };

      repositoryRoot = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.stateDir}/repositories";
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/repositories"'';
        description = "Path to the git repositories.";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Domain name of your server.";
      };

      rootUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:3000/";
        description = "Full public URL of Gogs server.";
      };

      httpAddress = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "HTTP listen address.";
      };

      httpPort = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "HTTP listen port.";
      };

      cookieSecure = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Marks session cookies as "secure" as a hint for browsers to only send
          them via HTTPS. This option is recommend, if Gogs is being served over HTTPS.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Configuration lines appended to the generated Gogs configuration file.";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.services.gogs = {
      description = "Gogs (Go Git Service)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.gogs ];

      preStart = let
        runConfig = "${cfg.stateDir}/custom/conf/app.ini";
        secretKey = "${cfg.stateDir}/custom/conf/secret_key";
      in ''
        mkdir -p ${cfg.stateDir}

        # copy custom configuration and generate a random secret key if needed
        ${lib.optionalString (cfg.useWizard == false) ''
          mkdir -p ${cfg.stateDir}/custom/conf
          cp -f ${configFile} ${runConfig}

          if [ ! -e ${secretKey} ]; then
              head -c 16 /dev/urandom | base64 > ${secretKey}
          fi

          KEY=$(head -n1 ${secretKey})
          DBPASS=$(head -n1 ${cfg.database.passwordFile})
          sed -e "s,#secretkey#,$KEY,g" \
              -e "s,#dbpass#,$DBPASS,g" \
              -i ${runConfig}
        ''}

        mkdir -p ${cfg.repositoryRoot}
        # update all hooks' binary paths
        HOOKS=$(find ${cfg.repositoryRoot} -mindepth 4 -maxdepth 4 -type f -wholename "*git/hooks/*")
        if [ "$HOOKS" ]
        then
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/gogs,${pkgs.gogs}/bin/gogs,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/env,${pkgs.coreutils}/bin/env,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/bash,${pkgs.bash}/bin/bash,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/perl,${pkgs.perl}/bin/perl,g' $HOOKS
        fi
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${pkgs.gogs}/bin/gogs web";
        Restart = "always";
        UMask = "0027";
      };

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        GOGS_WORK_DIR = cfg.stateDir;
      };
    };

    users = lib.mkIf (cfg.user == "gogs") {
      users.gogs = {
        description = "Go Git Service";
        uid = config.ids.uids.gogs;
        group = "gogs";
        home = cfg.stateDir;
        createHome = true;
        shell = pkgs.bash;
      };
      groups.gogs.gid = config.ids.gids.gogs;
    };

    warnings = lib.optional (cfg.database.password != "")
      ''config.services.gogs.database.password will be stored as plaintext
        in the Nix store. Use database.passwordFile instead.'';

    # Create database passwordFile default when password is configured.
    services.gogs.database.passwordFile =
      (lib.mkDefault (toString (pkgs.writeTextFile {
        name = "gogs-database-password";
        text = cfg.database.password;
      })));
  };
}
