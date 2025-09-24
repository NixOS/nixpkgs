{
  config,
  lib,
  pkgs,
  ...
}:

let

  inherit (lib)
    mkDefault
    mkEnableOption
    mkForce
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    ;
  inherit (lib)
    literalExpression
    mapAttrs
    optional
    optionalString
    types
    ;

  cfg = config.services.limesurvey;
  fpm = config.services.phpfpm.pools.limesurvey;

  user = "limesurvey";
  group = config.services.httpd.group;
  stateDir = "/var/lib/limesurvey";

  configType =
    with types;
    oneOf [
      (attrsOf configType)
      str
      int
      bool
    ]
    // {
      description = "limesurvey config type (str, int, bool or attribute set thereof)";
    };

  limesurveyConfig = pkgs.writeText "config.php" ''
    <?php
      return \array_merge(
        \json_decode('${builtins.toJSON cfg.config}', true),
        [
          'config' => [
            'encryptionnonce' => \trim(\file_get_contents(\getenv('CREDENTIALS_DIRECTORY') . DIRECTORY_SEPARATOR . 'encryption_nonce')),
            'encryptionsecretboxkey' => \trim(\file_get_contents(\getenv('CREDENTIALS_DIRECTORY') . DIRECTORY_SEPARATOR . 'encryption_key')),
          ]
        ]
      );
    ?>
  '';

  mysqlLocal = cfg.database.createLocally && cfg.database.type == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.database.type == "pgsql";

in
{
  # interface

  options.services.limesurvey = {
    enable = mkEnableOption "Limesurvey web application";

    package = mkPackageOption pkgs "limesurvey" { };

    encryptionKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      visible = false;
      description = ''
        This is a 32-byte key used to encrypt variables in the database.
        You _must_ change this from the default value.
      '';
    };

    encryptionNonce = mkOption {
      type = types.nullOr types.str;
      default = null;
      visible = false;
      description = ''
        This is a 24-byte nonce used to encrypt variables in the database.
        You _must_ change this from the default value.
      '';
    };

    encryptionKeyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        32-byte key used to encrypt variables in the database.

        Note: It should be string not a store path in order to prevent the password from being world readable
      '';
    };

    encryptionNonceFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        24-byte used to encrypt variables in the database.

        Note: It should be string not a store path in order to prevent the password from being world readable
      '';
    };

    database = {
      type = mkOption {
        type = types.enum [
          "mysql"
          "pgsql"
          "odbc"
          "mssql"
        ];
        example = "pgsql";
        default = "mysql";
        description = "Database engine to use.";
      };

      dbEngine = mkOption {
        type = types.enum [
          "MyISAM"
          "InnoDB"
        ];
        default = "InnoDB";
        description = "Database storage engine to use.";
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Database host address.";
      };

      port = mkOption {
        type = types.port;
        default = if cfg.database.type == "pgsql" then 5442 else 3306;
        defaultText = literalExpression "3306";
        description = "Database host port.";
      };

      name = mkOption {
        type = types.str;
        default = "limesurvey";
        description = "Database name.";
      };

      user = mkOption {
        type = types.str;
        default = "limesurvey";
        description = "Database user.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/limesurvey-dbpassword";
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
        description = "Path to the unix socket file to use for authentication.";
      };

      createLocally = mkOption {
        type = types.bool;
        default = cfg.database.type == "mysql";
        defaultText = literalExpression "true";
        description = ''
          Create the database and database user locally.
          This currently only applies if database type "mysql" is selected.
        '';
      };
    };

    virtualHost = mkOption {
      type = types.submodule (import ../web-servers/apache-httpd/vhost-options.nix);
      example = literalExpression ''
        {
          hostName = "survey.example.org";
          adminAddr = "webmaster@example.org";
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = ''
        Apache configuration can be done by adapting `services.httpd.virtualHosts.<name>`.
        See [](#opt-services.httpd.virtualHosts) for further information.
      '';
    };

    poolConfig = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for the LimeSurvey PHP pool. See the documentation on `php-fpm.conf`
        for details on configuration directives.
      '';
    };

    config = mkOption {
      type = configType;
      default = { };
      description = ''
        LimeSurvey configuration. Refer to
        <https://manual.limesurvey.org/Optional_settings>
        for details on supported values.
      '';
    };
  };

  # implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.type == "mysql";
        message = "services.limesurvey.createLocally is currently only supported for database type 'mysql'";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = "services.limesurvey.database.user must be set to ${user} if services.limesurvey.database.createLocally is set true";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.socket != null;
        message = "services.limesurvey.database.socket must be set if services.limesurvey.database.createLocally is set to true";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.limesurvey.database.createLocally is set to true";
      }
      {
        assertion = cfg.encryptionKey != null || cfg.encryptionKeyFile != null;
        message = ''
          You must set `services.limesurvey.encryptionKeyFile` to a file containing a 32-character uppercase hex string.

          If this message appears when updating your system, please turn off encryption
          in the LimeSurvey interface and create backups before filling the key.
        '';
      }
      {
        assertion = cfg.encryptionNonce != null || cfg.encryptionNonceFile != null;
        message = ''
          You must set `services.limesurvey.encryptionNonceFile` to a file containing a 24-character uppercase hex string.

          If this message appears when updating your system, please turn off encryption
          in the LimeSurvey interface and create backups before filling the nonce.
        '';
      }
    ];

    services.limesurvey.config = mapAttrs (name: mkDefault) {
      runtimePath = "${stateDir}/tmp/runtime";
      components = {
        db = {
          connectionString =
            "${cfg.database.type}:dbname=${cfg.database.name};host=${
              if pgsqlLocal then cfg.database.socket else cfg.database.host
            };port=${toString cfg.database.port}"
            + optionalString mysqlLocal ";socket=${cfg.database.socket}";
          username = cfg.database.user;
          password = mkIf (
            cfg.database.passwordFile != null
          ) "file_get_contents(\"${toString cfg.database.passwordFile}\");";
          tablePrefix = "limesurvey_";
        };
        assetManager.basePath = "${stateDir}/tmp/assets";
        urlManager = {
          urlFormat = "path";
          showScriptName = false;
        };
      };
      config = {
        tempdir = "${stateDir}/tmp";
        uploaddir = "${stateDir}/upload";
        force_ssl = mkIf (
          cfg.virtualHost.addSSL || cfg.virtualHost.forceSSL || cfg.virtualHost.onlySSL
        ) "on";
        config.defaultlang = "en";
      };
    };

    services.mysql = mkIf mysqlLocal {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "SELECT, CREATE, INSERT, UPDATE, DELETE, ALTER, DROP, INDEX";
          };
        }
      ];
    };

    services.phpfpm.pools.limesurvey = {
      inherit user group;
      phpPackage = pkgs.php81;
      phpEnv.DBENGINE = "${cfg.database.dbEngine}";
      phpEnv.LIMESURVEY_CONFIG = "${limesurveyConfig}";
      # App code cannot access credentials directly since the service starts
      # with the root user so we copy the credentials to a place accessible to Limesurvey
      phpEnv.CREDENTIALS_DIRECTORY = "${stateDir}/credentials";
      settings = {
        "listen.owner" = config.services.httpd.user;
        "listen.group" = config.services.httpd.group;
      }
      // cfg.poolConfig;
    };
    systemd.services.phpfpm-limesurvey.serviceConfig = {
      ExecStartPre = pkgs.writeShellScript "limesurvey-phpfpm-exec-pre" ''
        cp -f "''${CREDENTIALS_DIRECTORY}"/encryption_key "${stateDir}/credentials/encryption_key"
        chown ${user}:${group} "${stateDir}/credentials/encryption_key"
        cp -f "''${CREDENTIALS_DIRECTORY}"/encryption_nonce "${stateDir}/credentials/encryption_nonce"
        chown ${user}:${group} "${stateDir}/credentials/encryption_nonce"
      '';
      LoadCredential = [
        "encryption_key:${
          if cfg.encryptionKeyFile != null then
            cfg.encryptionKeyFile
          else
            pkgs.writeText "key" cfg.encryptionKey
        }"
        "encryption_nonce:${
          if cfg.encryptionNonceFile != null then
            cfg.encryptionNonceFile
          else
            pkgs.writeText "nonce" cfg.encryptionKey
        }"
      ];
    };

    services.httpd = {
      enable = true;
      adminAddr = mkDefault cfg.virtualHost.adminAddr;
      extraModules = [ "proxy_fcgi" ];
      virtualHosts.${cfg.virtualHost.hostName} = mkMerge [
        cfg.virtualHost
        {
          documentRoot = mkForce "${cfg.package}/share/limesurvey";
          extraConfig = ''
            Alias "/tmp" "${stateDir}/tmp"
            <Directory "${stateDir}">
              AllowOverride all
              Require all granted
              Options -Indexes +FollowSymlinks
            </Directory>

            Alias "/upload" "${stateDir}/upload"
            <Directory "${stateDir}/upload">
              AllowOverride all
              Require all granted
              Options -Indexes
            </Directory>

            <Directory "${cfg.package}/share/limesurvey">
              <FilesMatch "\.php$">
                <If "-f %{REQUEST_FILENAME}">
                  SetHandler "proxy:unix:${fpm.socket}|fcgi://localhost/"
                </If>
              </FilesMatch>

              AllowOverride all
              Options -Indexes
              DirectoryIndex index.php
            </Directory>
          '';
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 ${user} ${group} - -"
      "d ${stateDir}/tmp 0750 ${user} ${group} - -"
      "d ${stateDir}/tmp/assets 0750 ${user} ${group} - -"
      "d ${stateDir}/tmp/runtime 0750 ${user} ${group} - -"
      "d ${stateDir}/tmp/upload 0750 ${user} ${group} - -"
      "d ${stateDir}/credentials 0700 ${user} ${group} - -"
      "C ${stateDir}/upload 0750 ${user} ${group} - ${cfg.package}/share/limesurvey/upload"
    ];

    systemd.services.limesurvey-init = {
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-limesurvey.service" ];
      after = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.target";
      environment.DBENGINE = "${cfg.database.dbEngine}";
      environment.LIMESURVEY_CONFIG = limesurveyConfig;
      script = ''
        # update or install the database as required
        ${pkgs.php81}/bin/php ${cfg.package}/share/limesurvey/application/commands/console.php updatedb || \
        ${pkgs.php81}/bin/php ${cfg.package}/share/limesurvey/application/commands/console.php install admin password admin admin@example.com verbose
      '';
      serviceConfig = {
        User = user;
        Group = group;
        Type = "oneshot";
        LoadCredential = [
          "encryption_key:${
            if cfg.encryptionKeyFile != null then
              cfg.encryptionKeyFile
            else
              pkgs.writeText "key" cfg.encryptionKey
          }"
          "encryption_nonce:${
            if cfg.encryptionNonceFile != null then
              cfg.encryptionNonceFile
            else
              pkgs.writeText "nonce" cfg.encryptionKey
          }"
        ];
      };
    };

    systemd.services.httpd.after =
      optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.target";

    users.users.${user} = {
      group = group;
      isSystemUser = true;
    };

  };
}
