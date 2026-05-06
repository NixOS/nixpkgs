{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.passbolt-api;

  passbolt = cfg.package;
  php = passbolt.passthru.phpPackage;

  phpString =
    value:
    "'${
      lib.replaceStrings
        [
          "\\"
          "'"
        ]
        [
          "\\\\"
          "\\'"
        ]
        value
    }'";
  phpBool = value: if value then "true" else "false";

  setupCredentials =
    lib.optional (cfg.database.passwordFile != null) "db-password:${cfg.database.passwordFile}"
    ++ lib.optional (cfg.email.usernameFile != null) "email-username:${cfg.email.usernameFile}"
    ++ lib.optional (cfg.email.passwordFile != null) "email-password:${cfg.email.passwordFile}";
in
{
  options.services.passbolt-api = {
    enable = lib.mkEnableOption "Passbolt API, an open source password manager for teams";

    package =
      lib.mkPackageOption pkgs "passbolt-api" { }
      // lib.mkOption {
        apply = package: package.override { inherit (cfg) dataDir; };
      };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/passbolt";
      description = ''
        Directory used for Passbolt runtime state, including generated config,
        logs, temporary files, JWT keys, GPG keys, and migrations.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "passbolt";
      description = "User account under which Passbolt runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "passbolt";
      description = "Group under which Passbolt runs.";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.fqdnOrHostName;
      defaultText = lib.literalExpression "config.networking.fqdnOrHostName";
      example = "passbolt.example.com";
      description = "Hostname served by nginx when nginx integration is enabled.";
    };

    publicUrl = lib.mkOption {
      type = lib.types.str;
      default = "http://${cfg.hostName}";
      defaultText = lib.literalExpression ''"http://''${config.services.passbolt-api.hostName}"'';
      example = "https://passbolt.example.com";
      description = "Public URL used by Passbolt when generating links.";
    };

    secureCookies = lib.mkOption {
      type = lib.types.bool;
      default = lib.hasPrefix "https://" cfg.publicUrl;
      defaultText = lib.literalExpression ''lib.hasPrefix "https://" config.services.passbolt-api.publicUrl'';
      description = "Whether Passbolt should mark cookies as secure.";
    };

    forceSSL = lib.mkOption {
      type = lib.types.bool;
      default = lib.hasPrefix "https://" cfg.publicUrl;
      defaultText = lib.literalExpression ''lib.hasPrefix "https://" config.services.passbolt-api.publicUrl'';
      description = "Whether Passbolt should force SSL.";
    };

    serverKeyEmail = lib.mkOption {
      type = lib.types.str;
      default = "passbolt@example.com";
      example = "passbolt@example.com";
      description = "Email address embedded in the generated Passbolt server GPG key.";
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Create a local MariaDB database and user for Passbolt.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Database host.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "passbolt";
        description = "Database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "passbolt";
        description = "Database user.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/passbolt-db-password";
        description = ''
          File containing the database password. The file is loaded using
          systemd credentials by the setup service.
        '';
      };
    };

    email = {
      from = lib.mkOption {
        type = lib.types.str;
        default = "passbolt@example.com";
        example = "passbolt@example.com";
        description = "Sender email address used by Passbolt.";
      };

      fromName = lib.mkOption {
        type = lib.types.str;
        default = "Passbolt";
        description = "Sender display name used by Passbolt.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        example = "smtp.example.com";
        description = "SMTP host.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 25;
        example = 587;
        description = "SMTP port.";
      };

      tls = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use STARTTLS for SMTP.";
      };

      username = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "SMTP username. Use usernameFile for secret material.";
      };

      usernameFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/passbolt-smtp-username";
        description = "File containing the SMTP username.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/passbolt-smtp-password";
        description = "File containing the SMTP password.";
      };
    };

    nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Configure nginx to serve Passbolt.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports 80 and 443 in the firewall.";
      };

      virtualHostConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        example = {
          forceSSL = true;
          enableACME = true;
        };
        description = ''
          Extra configuration merged into
          {option}`services.nginx.virtualHosts.<hostName>`.
        '';
      };
    };

    poolSettings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 4;
        "pm.start_servers" = 1;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 2;
        "pm.max_requests" = 200;
      };
      description = "PHP-FPM pool settings for Passbolt.";
    };

    emailQueue = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Send queued Passbolt emails periodically.";
      };

      interval = lib.mkOption {
        type = lib.types.str;
        default = "1min";
        example = "5min";
        description = "Interval between email queue sender runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
    };

    services.mysql = lib.mkIf cfg.database.createLocally {
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
      settings.mysqld = {
        bind-address = lib.mkDefault "127.0.0.1";
        character-set-server = lib.mkDefault "utf8mb4";
        collation-server = lib.mkDefault "utf8mb4_unicode_ci";
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/config 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/config/Migrations 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/config/gpg 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/config/jwt 0550 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/tmp 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/logs 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.dataDir}/.gnupg 0700 ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.passbolt-api-setup = {
      description = "Initialise Passbolt runtime state";
      wantedBy = [ "multi-user.target" ];
      before = [
        "phpfpm-passbolt-api.service"
      ]
      ++ lib.optional cfg.nginx.enable "nginx.service";
      after = lib.optional cfg.database.createLocally "mysql.service";
      requires = lib.optional cfg.database.createLocally "mysql.service";
      path = [
        pkgs.coreutils
        pkgs.gawk
        pkgs.gnugrep
        pkgs.gnupg
        pkgs.openssl
      ]
      ++ lib.optional cfg.database.createLocally pkgs.mariadb;
      environment = {
        HOME = cfg.dataDir;
        GNUPGHOME = "${cfg.dataDir}/.gnupg";
      };
      restartTriggers = [ passbolt ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "${passbolt}";
        RemainAfterExit = true;
        LoadCredential = setupCredentials;
      };
      script = ''
        set -euo pipefail
        umask 077

        php_quote() {
          ${lib.getExe php} -r 'echo var_export(stream_get_contents(STDIN), true);'
        }

        mkdir -p \
          ${cfg.dataDir}/config/gpg \
          ${cfg.dataDir}/config/jwt \
          ${cfg.dataDir}/config/Migrations \
          ${cfg.dataDir}/tmp \
          ${cfg.dataDir}/logs \
          ${cfg.dataDir}/.gnupg
        chmod 700 ${cfg.dataDir}/.gnupg

        cp -n ${passbolt}/config/Migrations.dist/* ${cfg.dataDir}/config/Migrations/

        if [ ! -s ${cfg.dataDir}/config/gpg/serverkey_private.asc ]; then
          cat > ${cfg.dataDir}/gpg-batch <<'EOF'
        %no-protection
        Key-Type: RSA
        Key-Length: 3072
        Key-Usage: sign,encrypt
        Name-Real: Passbolt
        Name-Email: ${cfg.serverKeyEmail}
        Expire-Date: 0
        %commit
        EOF
          gpg --batch --homedir ${cfg.dataDir}/.gnupg --gen-key ${cfg.dataDir}/gpg-batch
          rm -f ${cfg.dataDir}/gpg-batch
        fi

        fingerprint="$(
          gpg --homedir ${cfg.dataDir}/.gnupg --with-colons --list-secret-keys ${lib.escapeShellArg cfg.serverKeyEmail} \
            | awk -F: '/^fpr:/ { print $10; exit }'
        )"
        if [ -z "$fingerprint" ]; then
          echo "Could not determine Passbolt GPG key fingerprint" >&2
          exit 1
        fi

        gpg --homedir ${cfg.dataDir}/.gnupg --armor --export "$fingerprint" > ${cfg.dataDir}/config/gpg/serverkey.asc
        gpg --homedir ${cfg.dataDir}/.gnupg --armor --export-secret-keys "$fingerprint" > ${cfg.dataDir}/config/gpg/serverkey_private.asc
        chmod 640 ${cfg.dataDir}/config/gpg/serverkey.asc ${cfg.dataDir}/config/gpg/serverkey_private.asc

        if [ ! -s ${cfg.dataDir}/config/jwt/jwt.key ]; then
          openssl genrsa -out ${cfg.dataDir}/config/jwt/jwt.key 4096
          openssl rsa -in ${cfg.dataDir}/config/jwt/jwt.key -pubout -out ${cfg.dataDir}/config/jwt/jwt.pem
          chmod 640 ${cfg.dataDir}/config/jwt/jwt.key ${cfg.dataDir}/config/jwt/jwt.pem
        fi
        chmod 550 ${cfg.dataDir}/config/jwt

        salt_file=${cfg.dataDir}/config/salt
        if [ ! -s "$salt_file" ]; then
          openssl rand -hex 32 > "$salt_file"
        fi
        salt="$(cat "$salt_file")"

        db_password=""
        ${lib.optionalString (cfg.database.passwordFile != null) ''
          db_password="$(cat "$CREDENTIALS_DIRECTORY/db-password")"
        ''}

        email_username=${
          lib.escapeShellArg (lib.optionalString (cfg.email.username != null) cfg.email.username)
        }
        ${lib.optionalString (cfg.email.usernameFile != null) ''
          email_username="$(cat "$CREDENTIALS_DIRECTORY/email-username")"
        ''}

        email_password=""
        ${lib.optionalString (cfg.email.passwordFile != null) ''
          email_password="$(cat "$CREDENTIALS_DIRECTORY/email-password")"
        ''}

        db_password_php="$(printf '%s' "$db_password" | php_quote)"
        email_username_php="$(printf '%s' "$email_username" | php_quote)"
        email_password_php="$(printf '%s' "$email_password" | php_quote)"

        cat > ${cfg.dataDir}/config/passbolt.php <<EOF
        <?php
        return [
            'debug' => false,
            'App' => [
                'fullBaseUrl' => ${phpString cfg.publicUrl},
            ],
            'Security' => [
                'salt' => '$salt',
            ],
            'Datasources' => [
                'default' => [
                    'host' => ${phpString cfg.database.host},
                    'username' => ${phpString cfg.database.user},
                    'password' => $db_password_php,
                    'database' => ${phpString cfg.database.name},
                    'encoding' => 'utf8mb4',
                ],
            ],
            'EmailTransport' => [
                'default' => [
                    'host' => ${phpString cfg.email.host},
                    'port' => ${toString cfg.email.port},
                    'timeout' => 30,
                    'username' => $email_username_php,
                    'password' => $email_password_php,
                    'tls' => ${phpBool cfg.email.tls},
                ],
            ],
            'Email' => [
                'default' => [
                    'transport' => 'default',
                    'from' => [${phpString cfg.email.from} => ${phpString cfg.email.fromName}],
                ],
            ],
            'passbolt' => [
                'gpg' => [
                    'keyring' => '${cfg.dataDir}/.gnupg',
                    'putenv' => true,
                    'serverKey' => [
                        'fingerprint' => '$fingerprint',
                        'public' => '${cfg.dataDir}/config/gpg/serverkey.asc',
                        'private' => '${cfg.dataDir}/config/gpg/serverkey_private.asc',
                    ],
                ],
                'security' => [
                    'cookies' => [
                        'secure' => ${phpBool cfg.secureCookies},
                    ],
                ],
                'ssl' => [
                    'force' => ${phpBool cfg.forceSSL},
                ],
            ],
        ];
        EOF
        chmod 640 ${cfg.dataDir}/config/passbolt.php

        if [ ! -e ${cfg.dataDir}/.installed ]; then
          ${passbolt}/bin/cake passbolt install --no-admin --force
          touch ${cfg.dataDir}/.installed
        else
          ${passbolt}/bin/cake migrations migrate
        fi
      '';
    };

    services.phpfpm.pools.passbolt-api = {
      user = cfg.user;
      group = cfg.group;
      phpPackage = php;
      phpEnv = {
        HOME = cfg.dataDir;
        GNUPGHOME = "${cfg.dataDir}/.gnupg";
      };
      phpOptions = ''
        upload_max_filesize = 10M
        post_max_size = 10M
        memory_limit = 256M
      '';
      settings = {
        "listen.owner" = lib.mkDefault (if cfg.nginx.enable then config.services.nginx.user else cfg.user);
        "listen.group" = lib.mkDefault (
          if cfg.nginx.enable then config.services.nginx.group else cfg.group
        );
      }
      // cfg.poolSettings;
    };

    systemd.services.phpfpm-passbolt-api = {
      after = [ "passbolt-api-setup.service" ];
      requires = [ "passbolt-api-setup.service" ];
    };

    systemd.services.passbolt-api-email-queue = lib.mkIf cfg.emailQueue.enable {
      description = "Send queued Passbolt emails";
      after = [
        "passbolt-api-setup.service"
        "network-online.target"
      ]
      ++ lib.optional cfg.database.createLocally "mysql.service";
      requires = [ "passbolt-api-setup.service" ];
      wants = [ "network-online.target" ];
      environment = {
        HOME = cfg.dataDir;
        GNUPGHOME = "${cfg.dataDir}/.gnupg";
      };
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "${passbolt}";
      };
      script = ''
        ${passbolt}/bin/cake email_queue.sender --limit 50 --quiet
      '';
    };

    systemd.timers.passbolt-api-email-queue = lib.mkIf cfg.emailQueue.enable {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = cfg.emailQueue.interval;
        Unit = "passbolt-api-email-queue.service";
      };
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts.${cfg.hostName} = lib.mkMerge [
        cfg.nginx.virtualHostConfig
        {
          root = "${passbolt}/webroot";
          locations."/" = {
            tryFiles = "$uri /index.php?$query_string";
          };
          locations."~ \\.php$" = {
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params;
              fastcgi_pass unix:${config.services.phpfpm.pools.passbolt-api.socket};
              fastcgi_param SCRIPT_FILENAME ${passbolt}/webroot$fastcgi_script_name;
              fastcgi_param DOCUMENT_ROOT ${passbolt}/webroot;
            '';
          };
          locations."~ ^/(\\.ht|config|src|tests|tmp|vendor)/" = {
            return = 404;
          };
        }
      ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.nginx.openFirewall [
      80
      443
    ];

    environment.systemPackages = [ passbolt ];
  };
}
