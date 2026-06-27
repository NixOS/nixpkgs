{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.wallos;

  # PHP environment with all required Wallos extensions.
  phpEnv = cfg.phpPackage.buildEnv {
    extensions =
      { enabled, all }:
      enabled
      ++ (with all; [
        curl
        dom
        gd
        imagick
        intl
        openssl
        pdo
        pdo_sqlite
        sqlite3
        zip
        mbstring
      ]);
    extraConfig = ''
      date.timezone = "${cfg.timezone}"
      upload_max_filesize = ${cfg.maxUploadSize}
      post_max_size = ${cfg.maxUploadSize}
      memory_limit = 256M
    '';
  };

  # Runtime webroot under /run (ephemeral, rebuilt on every start).
  runtimeDir = "/run/wallos/root";

  # State directories under /var/lib/wallos.
  stateDir = cfg.dataDir;
  dbDir = "${stateDir}/db";
  logosDir = "${stateDir}/logos";
  avatarsDir = "${logosDir}/avatars";
  tmpDir = "${stateDir}/tmp";

  serviceHardening = {
    CapabilityBoundingSet = "";
    LockPersonality = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProtectSystem = "strict";
    ProcSubset = "pid";
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    UMask = "0022";
    ReadWritePaths = [
      stateDir
      cfg.logDir
      "/run/wallos"
    ];
  };

  # Cron scripts from upstream, run via systemd timers.
  cronScripts = [
    {
      name = "updatenextpayment";
      script = "endpoints/cronjobs/updatenextpayment.php";
      calendar = "01:00";
    }
    {
      name = "updateexchange";
      script = "endpoints/cronjobs/updateexchange.php";
      calendar = "02:00";
    }
    {
      name = "sendcancellationnotifications";
      script = "endpoints/cronjobs/sendcancellationnotifications.php";
      calendar = "08:00";
    }
    {
      name = "sendnotifications";
      script = "endpoints/cronjobs/sendnotifications.php";
      calendar = "09:00";
    }
    {
      name = "sendverificationemails";
      script = "endpoints/cronjobs/sendverificationemails.php";
      calendar = "*-*-* *:0/2:00";
    }
    {
      name = "sendresetpasswordemails";
      script = "endpoints/cronjobs/sendresetpasswordemails.php";
      calendar = "*-*-* *:0/2:00";
    }
    {
      name = "checkforupdates";
      script = "endpoints/cronjobs/checkforupdates.php";
      calendar = "*-*-* *:0/6:00";
    }
    {
      name = "storetotalyearlycost";
      script = "endpoints/cronjobs/storetotalyearlycost.php";
      calendar = "Mon *-*-* 01:30:00";
    }
    {
      name = "cleanupresettokens";
      script = "endpoints/cronjobs/cleanupresettokens.php";
      calendar = "03:00";
    }
    {
      name = "generaterecommendations-weekly";
      script = "endpoints/cronjobs/generaterecommendations.php";
      args = "weekly";
      calendar = "Mon *-*-* 03:30:00";
    }
    {
      name = "generaterecommendations-monthly";
      script = "endpoints/cronjobs/generaterecommendations.php";
      args = "monthly";
      calendar = "*-*-01 04:00:00";
    }
  ];

  timerDefaults = lib.listToAttrs (
    map (
      job:
      lib.nameValuePair job.name {
        enable = true;
        onCalendar = job.calendar;
      }
    ) cronScripts
  );

  configuredCronScripts = map (job: job // { calendar = cfg.timers.${job.name}.onCalendar; }) (
    lib.filter (job: cfg.timers.${job.name}.enable) cronScripts
  );

  # Helper to build the runtime webroot.
  mkWebroot = pkgs.writeShellApplication {
    name = "wallos-mkwebroot";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      # Create runtime webroot.
      rm -rf ${runtimeDir}
      mkdir -p ${runtimeDir}

      # Copy immutable app files, including dot-directories such as .tmp.
      cp -r ${cfg.package}/share/wallos/. ${runtimeDir}/

      # The Nix store source is read-only; make the runtime copy mutable before
      # pruning paths while running without CAP_DAC_OVERRIDE.
      chmod -R u+w ${runtimeDir}

      # Replace upstream writable paths with links to persistent state.
      rm -rf ${runtimeDir}/db
      rm -rf ${runtimeDir}/images/uploads/logos
      rm -rf ${runtimeDir}/.tmp
      mkdir -p ${runtimeDir}/images/uploads

      # Clean up stale symlinks left by older module versions.
      [ -L ${logosDir}/avatars ] && rm -f ${logosDir}/avatars

      ln -sfn ${dbDir} ${runtimeDir}/db
      ln -sfn ${logosDir} ${runtimeDir}/images/uploads/logos
      ln -sfn ${tmpDir} ${runtimeDir}/.tmp
    '';
  };

  # Database creation and migration script.
  dbInit = pkgs.writeShellApplication {
    name = "wallos-db-init";
    runtimeInputs = [
      phpEnv
      pkgs.coreutils
    ];
    text = ''
      export TZ=${cfg.timezone}
      cd ${runtimeDir}

      # Create database if it does not exist.
      php endpoints/cronjobs/createdatabase.php

      # Run migrations.
      php endpoints/db/migrate.php
    '';
  };

  # Admin settings bootstrap script.
  adminSettingsScript = pkgs.writeShellApplication {
    name = "wallos-admin-settings-init";
    runtimeInputs = [ pkgs.python3 ];
    text = ''
      python3 - <<'PY'
      import json
      import sqlite3
      from pathlib import Path

      db = Path("${dbDir}/wallos.db")
      if not db.is_file():
          print("wallos-admin-settings-init: database not found, skipping admin settings bootstrap")
          raise SystemExit(0)

      smtp_password = ${
        if cfg.admin.smtp.password == null then "None" else builtins.toJSON cfg.admin.smtp.password
      }
      smtp_password_file = ${
        if cfg.admin.smtp.passwordFile == null then
          "None"
        else
          builtins.toJSON (toString cfg.admin.smtp.passwordFile)
      }
      settings = json.loads(${
        builtins.toJSON (
          builtins.toJSON {
            registrations_open = cfg.admin.registrationsOpen;
            max_users = cfg.admin.maxUsers;
            require_email_verification = cfg.admin.requireEmailVerification;
            server_url = cfg.admin.serverUrl;
            login_disabled = cfg.admin.disableLogin;
            smtp_address = cfg.admin.smtp.address;
            smtp_port = cfg.admin.smtp.port;
            encryption = cfg.admin.smtp.encryption;
            smtp_username = cfg.admin.smtp.username;
            from_email = cfg.admin.smtp.fromEmail;
            local_webhook_notifications_allowlist = lib.concatStringsSep "," cfg.admin.localWebhookAllowlist;
            update_notification = cfg.admin.updateNotification;
          }
        )
      })

      def read_secret(path):
          return Path(path).read_text(encoding="utf-8").rstrip("\r\n")

      if smtp_password is not None:
          settings["smtp_password"] = smtp_password
      elif smtp_password_file is not None:
          settings["smtp_password"] = read_secret(smtp_password_file)
      else:
          settings["smtp_password"] = ""

      settings = {
          key: int(value) if isinstance(value, bool) else value
          for key, value in settings.items()
      }

      required_admin_columns = {
          "registrations_open": "BOOLEAN DEFAULT 0",
          "max_users": "INTEGER DEFAULT 0",
          "require_email_verification": "BOOLEAN DEFAULT 0",
          "server_url": "TEXT",
          "smtp_address": "TEXT",
          "smtp_port": "INTEGER DEFAULT 587",
          "smtp_username": "TEXT",
          "smtp_password": "TEXT",
          "from_email": "TEXT",
          "encryption": "TEXT DEFAULT \"tls\"",
          "login_disabled": "BOOLEAN DEFAULT 0",
          "update_notification": "BOOLEAN DEFAULT 0",
          "local_webhook_notifications_allowlist": "TEXT DEFAULT \"\"",
      }

      conn = sqlite3.connect(db)
      try:
          conn.execute("""
            CREATE TABLE IF NOT EXISTS admin (
              id INTEGER PRIMARY KEY,
              registrations_open BOOLEAN DEFAULT 0,
              max_users INTEGER DEFAULT 0,
              require_email_verification BOOLEAN DEFAULT 0,
              server_url TEXT,
              smtp_address TEXT,
              smtp_port INTEGER DEFAULT 587,
              smtp_username TEXT,
              smtp_password TEXT,
              from_email TEXT,
              encryption TEXT DEFAULT "tls",
              login_disabled BOOLEAN DEFAULT 0,
              update_notification BOOLEAN DEFAULT 0,
              local_webhook_notifications_allowlist TEXT DEFAULT ""
            )
          """)
          existing_admin_columns = {
              row[1]
              for row in conn.execute("PRAGMA table_info(admin)")
          }
          for column, definition in required_admin_columns.items():
              if column not in existing_admin_columns:
                  conn.execute(f"ALTER TABLE admin ADD COLUMN {column} {definition}")

          conn.execute("INSERT OR IGNORE INTO admin (id) VALUES (1)")
          conn.execute("""
            UPDATE admin SET
              registrations_open = ?,
              max_users = ?,
              require_email_verification = ?,
              server_url = ?,
              login_disabled = ?,
              smtp_address = ?,
              smtp_port = ?,
              encryption = ?,
              smtp_username = ?,
              smtp_password = ?,
              from_email = ?,
              local_webhook_notifications_allowlist = ?,
              update_notification = ?
            WHERE id = 1
          """, (
              settings["registrations_open"],
              settings["max_users"],
              settings["require_email_verification"],
              settings["server_url"],
              settings["login_disabled"],
              settings["smtp_address"],
              settings["smtp_port"],
              settings["encryption"],
              settings["smtp_username"],
              settings["smtp_password"],
              settings["from_email"],
              settings["local_webhook_notifications_allowlist"],
              settings["update_notification"],
          ))
          conn.commit()
      finally:
          conn.close()
      PY
    '';
  };

  # OIDC bootstrap script.
  oidcScript = pkgs.writeShellApplication {
    name = "wallos-oidc-init";
    runtimeInputs = [ pkgs.python3 ];
    text = ''
      python3 - <<'PY'
      import json
      import sqlite3
      from pathlib import Path

      db = Path("${dbDir}/wallos.db")
      if not db.is_file():
          print("wallos-oidc-init: database not found, skipping OIDC bootstrap")
          raise SystemExit(0)

      client_id = ${if cfg.oidc.clientId == null then "None" else builtins.toJSON cfg.oidc.clientId}
      client_id_file = ${
        if cfg.oidc.clientIdFile == null then "None" else builtins.toJSON (toString cfg.oidc.clientIdFile)
      }
      client_secret = ${
        if cfg.oidc.clientSecret == null then "None" else builtins.toJSON cfg.oidc.clientSecret
      }
      client_secret_file = ${
        if cfg.oidc.clientSecretFile == null then
          "None"
        else
          builtins.toJSON (toString cfg.oidc.clientSecretFile)
      }
      public_settings = json.loads(${
        builtins.toJSON (
          builtins.toJSON {
            name = cfg.oidc.providerName;
            authorization_url = cfg.oidc.authorizeUrl;
            token_url = cfg.oidc.tokenUrl;
            user_info_url = cfg.oidc.userInfoUrl;
            redirect_url = cfg.oidc.redirectUrl;
            logout_url = cfg.oidc.logoutUrl;
            user_identifier_field = cfg.oidc.userIdentifierField;
            scopes = lib.concatStringsSep " " cfg.oidc.scopes;
            auth_style = cfg.oidc.authStyle;
            auto_create_user = cfg.oidc.autoCreateUser;
            password_login_disabled = cfg.oidc.passwordLoginDisabled;
          }
        )
      })

      def read_secret(path):
          return Path(path).read_text(encoding="utf-8").rstrip("\r\n")

      def configured_value(inline_value, file_path):
          if inline_value is not None:
              return inline_value
          if file_path is not None:
              return read_secret(file_path)
          return None

      client_id_value = configured_value(client_id, client_id_file)
      client_secret_value = configured_value(client_secret, client_secret_file)
      if client_id_value is None:
          raise SystemExit("wallos-oidc-init: client_id is required")
      if client_secret_value is None:
          raise SystemExit("wallos-oidc-init: client_secret is required")

      settings = {
          key: int(value) if isinstance(value, bool) else value
          for key, value in public_settings.items()
      }
      settings["client_id"] = client_id_value
      settings["client_secret"] = client_secret_value

      required_oauth_columns = {
          "name": "TEXT NOT NULL DEFAULT \"\"",
          "client_id": "TEXT NOT NULL DEFAULT \"\"",
          "client_secret": "TEXT NOT NULL DEFAULT \"\"",
          "authorization_url": "TEXT NOT NULL DEFAULT \"\"",
          "token_url": "TEXT NOT NULL DEFAULT \"\"",
          "user_info_url": "TEXT NOT NULL DEFAULT \"\"",
          "redirect_url": "TEXT NOT NULL DEFAULT \"\"",
          "logout_url": "TEXT",
          "user_identifier_field": "TEXT NOT NULL DEFAULT \"sub\"",
          "scopes": "TEXT NOT NULL DEFAULT \"openid email profile\"",
          "auth_style": "TEXT DEFAULT \"auto\"",
          "auto_create_user": "INTEGER DEFAULT 0",
          "password_login_disabled": "INTEGER DEFAULT 0",
      }

      conn = sqlite3.connect(db)
      try:
          admin_columns = {
              row[1]
              for row in conn.execute("PRAGMA table_info(admin)")
          }
          if "oidc_oauth_enabled" not in admin_columns:
              conn.execute("ALTER TABLE admin ADD COLUMN oidc_oauth_enabled INTEGER DEFAULT 0")

          conn.execute("""
            CREATE TABLE IF NOT EXISTS oauth_settings (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL DEFAULT "",
              client_id TEXT NOT NULL DEFAULT "",
              client_secret TEXT NOT NULL DEFAULT "",
              authorization_url TEXT NOT NULL DEFAULT "",
              token_url TEXT NOT NULL DEFAULT "",
              user_info_url TEXT NOT NULL DEFAULT "",
              redirect_url TEXT NOT NULL DEFAULT "",
              logout_url TEXT,
              user_identifier_field TEXT NOT NULL DEFAULT "sub",
              scopes TEXT NOT NULL DEFAULT "openid email profile",
              auth_style TEXT DEFAULT "auto",
              auto_create_user INTEGER DEFAULT 0,
              password_login_disabled INTEGER DEFAULT 0
            )
          """)
          existing_oauth_columns = {
              row[1]
              for row in conn.execute("PRAGMA table_info(oauth_settings)")
          }
          for column, definition in required_oauth_columns.items():
              if column not in existing_oauth_columns:
                  conn.execute(f"ALTER TABLE oauth_settings ADD COLUMN {column} {definition}")

          conn.execute("DELETE FROM oauth_settings")
          conn.execute("""
            INSERT INTO oauth_settings (
              id,
              name,
              client_id,
              client_secret,
              authorization_url,
              token_url,
              user_info_url,
              redirect_url,
              logout_url,
              user_identifier_field,
              scopes,
              auth_style,
              auto_create_user,
              password_login_disabled
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
          """, (
              1,
              settings["name"],
              settings["client_id"],
              settings["client_secret"],
              settings["authorization_url"],
              settings["token_url"],
              settings["user_info_url"],
              settings["redirect_url"],
              settings["logout_url"],
              settings["user_identifier_field"],
              settings["scopes"],
              settings["auth_style"],
              settings["auto_create_user"],
              settings["password_login_disabled"],
          ))
          conn.execute("UPDATE admin SET oidc_oauth_enabled = 1")
          conn.commit()
      finally:
          conn.close()
      PY
    '';
  };

in
{
  options.services.wallos = {
    enable = lib.mkEnableOption "Wallos subscription tracker";

    package = lib.mkPackageOption pkgs "wallos" { };

    phpPackage = lib.mkPackageOption pkgs "php83" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "wallos";
      description = "User account under which Wallos runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "wallos";
      description = "Group under which Wallos runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/wallos";
      description = "Directory for persistent Wallos state (database, uploads).";
    };

    logDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/log/wallos";
      description = "Directory for Wallos logs.";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      default = if config.time.timeZone != null then config.time.timeZone else "UTC";
      defaultText = lib.literalExpression ''if config.time.timeZone != null then config.time.timeZone else "UTC"'';
      description = "Timezone for PHP and cron jobs.";
    };

    maxUploadSize = lib.mkOption {
      type = lib.types.str;
      default = "10M";
      description = "Maximum upload file size for PHP.";
    };

    virtualHost = lib.mkOption {
      type = lib.types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
      default = { };
      description = "Nginx virtual host configuration for Wallos.";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address on which nginx listens for Wallos.";
    };
    virtualHostName = lib.mkOption {
      type = lib.types.str;
      default = "wallos";
      description = "Server name for the nginx virtual host.";
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 80;
      description = "Port on which nginx listens for Wallos.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the Wallos nginx listen port in the firewall.";
    };

    phpPoolSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        "pm" = "dynamic";
        "pm.max_children" = "15";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "1";
        "pm.max_spare_servers" = "3";
        "pm.max_requests" = "500";
      };
      description = "Extra PHP-FPM pool settings for Wallos.";
    };

    timers = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to enable this Wallos maintenance timer.";
            };
            onCalendar = lib.mkOption {
              type = lib.types.str;
              description = "systemd OnCalendar expression for this Wallos maintenance timer.";
            };
          };
        }
      );
      default = timerDefaults;
      description = "Wallos maintenance timers translated from upstream cron jobs.";
    };

    admin = {
      maxUsers = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 0;
        description = "Maximum number of Wallos users. Set to 0 for unlimited.";
      };

      registrationsOpen = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Wallos user registration is enabled.";
      };

      requireEmailVerification = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Wallos requires email verification for new users.";
      };

      serverUrl = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Public Wallos server URL used for email links and related admin settings.";
      };

      disableLogin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Wallos password login is disabled.";
      };

      updateNotification = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Wallos shows update notifications on the dashboard.";
      };

      smtp = {
        address = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "SMTP server address.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 587;
          description = "SMTP server port.";
        };

        encryption = lib.mkOption {
          type = lib.types.enum [
            "none"
            "tls"
            "ssl"
          ];
          default = "tls";
          description = "SMTP encryption mode.";
        };

        username = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "SMTP username.";
        };

        password = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "SMTP password. Prefer passwordFile to avoid storing this secret in the Nix store.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to a file containing the SMTP password.";
        };

        fromEmail = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Optional From email address for Wallos SMTP mail.";
        };
      };

      localWebhookAllowlist = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Hostnames or IP addresses allowed for local webhook notifications despite SSRF protection.";
      };
    };

    oidc = {
      enable = lib.mkEnableOption "OIDC authentication for Wallos";

      providerName = lib.mkOption {
        type = lib.types.str;
        default = "OIDC";
        description = "Display name for the OIDC provider on the Wallos login page.";
      };

      clientId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "OIDC client ID. Prefer clientIdFile if you do not want this value in the Nix store.";
      };

      clientIdFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the OIDC client ID.";
      };

      clientSecret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "OIDC client secret. Prefer clientSecretFile to avoid storing this secret in the Nix store.";
      };

      clientSecretFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the OIDC client secret.";
      };

      authorizeUrl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "OIDC authorization endpoint URL.";
      };

      tokenUrl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "OIDC token endpoint URL.";
      };

      userInfoUrl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "OIDC userinfo endpoint URL.";
      };

      redirectUrl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "OIDC redirect URL (must match provider config).";
      };

      logoutUrl = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "OIDC logout endpoint URL.";
      };

      userIdentifierField = lib.mkOption {
        type = lib.types.str;
        default = "sub";
        description = "Field in the userinfo response to use as the unique user identifier.";
      };

      scopes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "openid"
          "email"
          "profile"
        ];
        description = "OIDC scopes requested during authorization.";
      };
      authStyle = lib.mkOption {
        type = lib.types.str;
        default = "auto";
        description = "OIDC token authentication style stored in Wallos.";
      };

      autoCreateUser = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Wallos should create users automatically after successful OIDC authentication.";
      };

      passwordLoginDisabled = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether Wallos should disable password login when OIDC is enabled.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.oidc.clientId != null && cfg.oidc.clientIdFile != null);
        message = "services.wallos.oidc.clientId and clientIdFile are mutually exclusive.";
      }
      {
        assertion = !(cfg.oidc.clientSecret != null && cfg.oidc.clientSecretFile != null);
        message = "services.wallos.oidc.clientSecret and clientSecretFile are mutually exclusive.";
      }
      {
        assertion = !cfg.oidc.enable || cfg.oidc.clientId != null || cfg.oidc.clientIdFile != null;
        message = "services.wallos.oidc requires clientId or clientIdFile when enabled.";
      }
      {
        assertion = !cfg.oidc.enable || cfg.oidc.clientSecret != null || cfg.oidc.clientSecretFile != null;
        message = "services.wallos.oidc requires clientSecret or clientSecretFile when enabled.";
      }
      {
        assertion =
          !cfg.oidc.enable
          || (
            cfg.oidc.authorizeUrl != null
            && cfg.oidc.tokenUrl != null
            && cfg.oidc.userInfoUrl != null
            && cfg.oidc.redirectUrl != null
          );
        message = "services.wallos.oidc requires authorizeUrl, tokenUrl, userInfoUrl, and redirectUrl when enabled.";
      }
      {
        assertion = !(cfg.admin.smtp.password != null && cfg.admin.smtp.passwordFile != null);
        message = "services.wallos.admin.smtp.password and passwordFile are mutually exclusive.";
      }
      {
        assertion = !cfg.admin.requireEmailVerification || cfg.admin.smtp.address != "";
        message = "services.wallos.admin.requireEmailVerification requires services.wallos.admin.smtp.address.";
      }
      {
        assertion = !(cfg.admin.disableLogin && cfg.admin.registrationsOpen);
        message = "services.wallos.admin.disableLogin cannot be used while registrationsOpen is true.";
      }
    ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    # PHP-FPM pool.
    services.phpfpm.pools.wallos = {
      user = cfg.user;
      group = cfg.group;
      phpPackage = phpEnv;
      settings = {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
        "listen.mode" = "0600";
      }
      // cfg.phpPoolSettings;
    };

    # Nginx virtual host.
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.virtualHostName} = cfg.virtualHost // {
        listen = [
          {
            addr = cfg.listenAddress;
            port = cfg.listenPort;
          }
        ];
        root = runtimeDir;
        locations = (cfg.virtualHost.locations or { }) // {
          "= /" = {
            index = "index.php";
          };
          "~ \\.php$" = {
            extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools.wallos.socket};
              fastcgi_index index.php;
              fastcgi_param SCRIPT_FILENAME ${runtimeDir}$fastcgi_script_name;
              include ${pkgs.nginx}/conf/fastcgi_params;
            '';
          };
          "~ \\.db$" = {
            priority = 900;
            extraConfig = ''
              deny all;
              return 403;
            '';
          };
          "~* images/uploads/logos/.*\\.php$" = {
            priority = 900;
            extraConfig = ''
              deny all;
              return 403;
            '';
          };
          "~* \\.tmp/.*\\.php$" = {
            priority = 900;
            extraConfig = ''
              deny all;
              return 403;
            '';
          };
        };
      };
    };

    # Systemd services: init, cron jobs, and ordering.
    systemd.services = lib.mkMerge [
      {
        wallos-init = {
          description = "Wallos runtime webroot and database initialization";
          wantedBy = [ "multi-user.target" ];
          before = [
            "phpfpm-wallos.service"
            "nginx.service"
          ];
          serviceConfig = serviceHardening // {
            Type = "oneshot";
            RemainAfterExit = true;
            User = cfg.user;
            Group = cfg.group;
            RuntimeDirectory = "wallos";
            RuntimeDirectoryMode = "0755";
            ExecStart = lib.getExe mkWebroot;
            ExecStartPost = [
              (lib.getExe dbInit)
              (lib.getExe adminSettingsScript)
            ]
            ++ lib.optional cfg.oidc.enable (lib.getExe oidcScript);
          };
        };
        phpfpm-wallos = {
          after = [ "wallos-init.service" ];
          requires = [ "wallos-init.service" ];
          serviceConfig.ReadWritePaths = serviceHardening.ReadWritePaths ++ [ "/run/phpfpm" ];
        };
        nginx = {
          after = [ "wallos-init.service" ];
          wants = [ "wallos-init.service" ];
        };
      }
      (lib.listToAttrs (
        map (
          job:
          lib.nameValuePair "wallos-cron-${job.name}" {
            description = "Wallos cron job: ${job.name}";
            serviceConfig = serviceHardening // {
              Type = "oneshot";
              User = cfg.user;
              Group = cfg.group;
              WorkingDirectory = runtimeDir;
              ExecStart = "${phpEnv}/bin/php ${job.script} ${job.args or ""}";
            };
          }
        ) configuredCronScripts
      ))
    ];

    systemd.timers = lib.listToAttrs (
      map (
        job:
        lib.nameValuePair "wallos-cron-${job.name}" {
          description = "Timer for Wallos cron job: ${job.name}";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = job.calendar;
            Persistent = true;
          };
        }
      ) configuredCronScripts
    );

    # Activation script ensures persistent directories exist with correct
    # permissions on every deploy. Tmpfiles handles boot-time creation.
    system.activationScripts.wallos = lib.stringAfter [ "users" "groups" ] ''
      ${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDir} ${logosDir} ${avatarsDir} ${dbDir} ${tmpDir} ${cfg.logDir}
      ${pkgs.coreutils}/bin/chmod 0755 ${cfg.dataDir} ${logosDir} ${avatarsDir}
      ${pkgs.coreutils}/bin/chmod 0750 ${dbDir} ${tmpDir} ${cfg.logDir}
      ${pkgs.coreutils}/bin/chown ${cfg.user}:${cfg.group} ${cfg.dataDir} ${logosDir} ${avatarsDir} ${dbDir} ${tmpDir} ${cfg.logDir}
      # Clean up stale avatars symlink from older module versions.
      if [ -L ${logosDir}/avatars ]; then
        ${pkgs.coreutils}/bin/rm -f ${logosDir}/avatars
      fi
    '';

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.listenPort ];

    # Ensure state directories exist on boot.
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} -"
      "d ${dbDir} 0750 ${cfg.user} ${cfg.group} -"
      "d ${logosDir} 0755 ${cfg.user} ${cfg.group} -"
      "d ${avatarsDir} 0755 ${cfg.user} ${cfg.group} -"
      "d ${tmpDir} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.logDir} 0750 ${cfg.user} ${cfg.group} -"
    ];
  };

  meta.maintainers = with lib.maintainers; [
    iokernel
  ];
}
