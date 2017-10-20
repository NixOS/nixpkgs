{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitea;
  configFile = pkgs.writeText "app.ini" ''
    APP_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod

    [database]
    DB_TYPE = ${cfg.database.type}
    HOST = ${cfg.database.host}:${toString cfg.database.port}
    NAME = ${cfg.database.name}
    USER = ${cfg.database.user}
    PASSWD = #dbpass#
    PATH = ${cfg.database.path}

    [repository]
    ROOT = ${cfg.repositoryRoot}

    [server]
    DOMAIN = ${cfg.domain}
    HTTP_ADDR = ${cfg.httpAddress}
    HTTP_PORT = ${toString cfg.httpPort}
    ROOT_URL = ${cfg.rootUrl}
    STATIC_ROOT_PATH = ${cfg.staticRootPath}

    [session]
    COOKIE_NAME = session
    COOKIE_SECURE = ${boolToString cfg.cookieSecure}

    [security]
    SECRET_KEY = #secretkey#
    INSTALL_LOCK = true

    ${cfg.extraConfig}
  '';
in

{
  options = {
    services.gitea = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Enable Gitea Service.";
      };

      useWizard = mkOption {
        default = false;
        type = types.bool;
        description = "Do not generate a configuration and use gitea' installation wizard instead. The first registered user will be administrator.";
      };

      stateDir = mkOption {
        default = "/var/lib/gitea";
        type = types.str;
        description = "gitea data directory.";
      };

      user = mkOption {
        type = types.str;
        default = "gitea";
        description = "User account under which gitea runs.";
      };

      database = {
        type = mkOption {
          type = types.enum [ "sqlite3" "mysql" "postgres" ];
          example = "mysql";
          default = "sqlite3";
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
          default = "gitea";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "gitea";
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
          example = "/run/keys/gitea-dbpassword";
          description = ''
            A file containing the password corresponding to
            <option>database.user</option>.
          '';
        };

        path = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/gitea.db";
          description = "Path to the sqlite3 database file.";
        };
      };

      appName = mkOption {
        type = types.str;
        default = "gitea: Gitea Service";
        description = "Application name.";
      };

      repositoryRoot = mkOption {
        type = types.str;
        default = "${cfg.stateDir}/repositories";
        description = "Path to the git repositories.";
      };

      domain = mkOption {
        type = types.str;
        default = "localhost";
        description = "Domain name of your server.";
      };

      rootUrl = mkOption {
        type = types.str;
        default = "http://localhost:3000/";
        description = "Full public URL of gitea server.";
      };

      httpAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "HTTP listen address.";
      };

      httpPort = mkOption {
        type = types.int;
        default = 3000;
        description = "HTTP listen port.";
      };

      cookieSecure = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Marks session cookies as "secure" as a hint for browsers to only send
          them via HTTPS. This option is recommend, if gitea is being served over HTTPS.
        '';
      };

      staticRootPath = mkOption {
        type = types.str;
        default = "${pkgs.gitea.data}";
        example = "/var/lib/gitea/data";
        description = "Upper level of template and static files path.";
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Configuration lines appended to the generated gitea configuration file.";
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.gitea = {
      description = "gitea";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.gitea.bin ];

      preStart = let
        runConfig = "${cfg.stateDir}/custom/conf/app.ini";
        secretKey = "${cfg.stateDir}/custom/conf/secret_key";
      in ''
        mkdir -p ${cfg.stateDir}

        # copy custom configuration and generate a random secret key if needed
        ${optionalString (cfg.useWizard == false) ''
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
          chmod 640 ${runConfig} ${secretKey}
        ''}

        mkdir -p ${cfg.repositoryRoot}
        # update all hooks' binary paths
        HOOKS=$(find ${cfg.repositoryRoot} -mindepth 4 -maxdepth 4 -type f -wholename "*git/hooks/*")
        if [ "$HOOKS" ]
        then
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/gitea,${pkgs.gitea.bin}/bin/gitea,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/env,${pkgs.coreutils}/bin/env,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/bash,${pkgs.bash}/bin/bash,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/perl,${pkgs.perl}/bin/perl,g' $HOOKS
        fi
        if [ ! -d ${cfg.stateDir}/conf/locale ]
        then
          mkdir -p ${cfg.stateDir}/conf
          cp -r ${pkgs.gitea.out}/locale ${cfg.stateDir}/conf/locale
        fi
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${pkgs.gitea.bin}/bin/gitea web";
        Restart = "always";
      };

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        GITEA_WORK_DIR = cfg.stateDir;
      };
    };

    users = mkIf (cfg.user == "gitea") {
      extraUsers.gitea = {
        description = "Gitea Service";
        home = cfg.stateDir;
        createHome = true;
      };
    };

    warnings = optional (cfg.database.password != "")
      ''config.services.gitea.database.password will be stored as plaintext
        in the Nix store. Use database.passwordFile instead.'';

    # Create database passwordFile default when password is configured.
    services.gitea.database.passwordFile =
      (mkDefault (toString (pkgs.writeTextFile {
        name = "gitea-database-password";
        text = cfg.database.password;
      })));
  };
}
