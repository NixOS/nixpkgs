{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;

  cfg = config.services.filesender;
  fpm = config.services.phpfpm.pools.filesender;

  logDir = "/var/log/filesender";
  stateDir = "/var/lib/filesender";

  format = pkgs.formats.php { finalVariable = "config"; };
  formatPrivate = pkgs.formats.php { };

  configFile = format.generate "config.php" cfg.settings;
  configFilePrivate = formatPrivate.generate "config_private.php" {
    auth_sp_oidc_client_id = cfg.auth.oidc.clientID;
    auth_sp_oidc_client_secret = formatPrivate.lib.mkRaw ''
      trim(file_get_contents("${cfg.auth.oidc.clientSecretFile}"))
    '';
  };

  filesenderConfigDirectory = pkgs.runCommand "filesender-config" { } ''
    mkdir $out
    cp ${configFile} $out/config.php

    ${lib.optionalString (cfg.auth.backend == "oidc") ''
      cp ${configFilePrivate} $out/config_private.php
    ''}
  '';
in
{
  meta = {
    doc = ./filesender.md;
    teams = with lib.teams; [ ngi ];
  };

  options.services.filesender = {
    enable = mkEnableOption "FileSender";
    package = mkPackageOption pkgs "filesender" { };
    user = mkOption {
      description = "User under which filesender runs.";
      type = types.str;
      default = "filesender";
    };
    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Create the PostgreSQL database and database user locally.
        '';
      };
      hostname = mkOption {
        type = types.str;
        default = "/run/postgresql";
        description = "Database hostname.";
      };
      port = mkOption {
        type = types.port;
        default = 5432;
        description = "Database port.";
      };
      name = mkOption {
        type = types.str;
        default = "filesender";
        description = "Database name.";
      };
      user = mkOption {
        type = types.str;
        default = "filesender";
        description = "Database user.";
      };
      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/filesender-dbpassword";
        description = ''
          A file containing the password corresponding to
          [](#opt-services.filesender.database.user).
        '';
      };
    };
    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
        options = {
          site_url = mkOption {
            type = types.str;
            description = ''
              Site URL. Used in emails, to build URLs for logging in, logging
              out, build URL for upload endpoint for web workers, to include
              scripts etc.
            '';
          };
          admin = mkOption {
            type = types.commas;
            description = ''
              UIDs (as per the configured saml_uid_attribute) of FileSender administrators.
              Accounts with these UIDs can access the Admin page through the web UI.
            '';
          };
          admin_email = mkOption {
            type = types.commas;
            description = ''
              Email address of FileSender administrator(s).
              Emails regarding disk full etc. are sent here.
              You should use a role-address here.
            '';
          };
          storage_filesystem_path = mkOption {
            type = types.nullOr types.str;
            description = ''
              FileSender storage root.

              When using a storage-type filesystem, this is the absolute path
              to the file system where uploaded files are stored until they
              expire.
            '';
          };
          log_facilities = mkOption {
            type = format.type;
            default = [ { type = "error_log"; } ];
            description = ''
              Defines where FileSender logging is sent.

              You can sent logging to a file, to syslog or to the default PHP
              log facility (as configured through your webserver's PHP module).

              The directive takes an array of one or more logging targets.
              Logging can be sent to multiple targets simultaneously, each a
              list containing the name of the logging target and a number of
              attributes which vary per log target.
            '';
          };
        };
      };
      default = { };
      description = ''
        Configuration options used by FileSender.

        See [](https://docs.filesender.org/filesender/v3.0/admin/configuration/)
        for available options.
      '';
    };
    configureNginx = mkOption {
      type = types.bool;
      default = true;
      description = "Configure nginx as a reverse proxy for FileSender.";
    };
    localDomain = mkOption {
      type = types.str;
      example = "filesender.example.org";
      description = "The domain serving your FileSender instance.";
    };
    poolSettings = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = "32";
        "pm.start_servers" = "2";
        "pm.min_spare_servers" = "2";
        "pm.max_spare_servers" = "4";
        "pm.max_requests" = "500";
      };
      description = ''
        Options for FileSender's PHP pool.

        See the documentation on `php-fpm.conf` for details on configuration
        directives.
      '';
    };
    auth = {
      backend = lib.mkOption {
        type = lib.types.enum [
          "fake"
          "header"
          "oidc"
          "saml"
          "shibboleth"
        ];
        default = "oidc";
        description = ''
          FileSender authentication backend.

          Note that `saml` requires an external SimpleSAMLphp installation, which
          is not provided by this module and `fake` is for testing only.
        '';
      };

      # https://docs.filesender.org/filesender/v3.0/admin/configuration/#:~:text=Authentication%3A%20SP%5Ffake
      fake = {
        authenticated = mkOption {
          internal = true;
          type = types.bool;
          default = true;
          description = "Whether the fake user is authenticated.";
        };
        name = mkOption {
          internal = true;
          type = types.str;
          default = "User";
          description = "Fake user name.";
        };
        uid = mkOption {
          internal = true;
          type = types.str;
          default = "user";
          description = "Fake user UID.";
        };
        email = mkOption {
          internal = true;
          type = types.str;
          default = "user@example.org";
          description = "Fake user email.";
        };
      };

      # https://docs.filesender.org/filesender/v3.0/admin/configuration/#:~:text=Authentication%3A%20OpenIDConnectClient
      oidc = {
        issuer = mkOption {
          type = types.str;
          default = "";
          example = "https://login.example.com/realms/yourrealm";
          description = "OIDC issuer URL.";
        };
        clientID = mkOption {
          type = types.str;
          default = "";
          description = "OIDC client ID.";
        };
        clientSecretFile = mkOption {
          type = types.nullOr types.externalPath;
          default = null;
          example = "/run/keys/filesender-oidc-client-secret";
          description = ''
            File containing the OIDC client secret.

            Use a runtime path such as /run/keys/... so the secret is not copied
            into the Nix store.
          '';
        };
        idpAttribute = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            IdP identification for audit/statistics.
          '';
        };
        scopes = mkOption {
          type = types.listOf types.str;
          default = [
            "openid"
            "profile"
            "email"
          ];
          description = ''
            OIDC scopes to request during authentication.
            This allows customization of the information requested from the
            identity provider.
          '';
        };
        uidAttribute = mkOption {
          type = types.str;
          default = "sub";
          description = ''
            Name of the claim that contains the user's unique identifier.
          '';
        };
        emailAttribute = mkOption {
          type = types.str;
          default = "email";
          description = ''
            Name of the claim that contains the user's email address.
          '';
        };
        nameAttribute = mkOption {
          type = types.str;
          default = "name";
          description = ''
            Name of the claim that contains the user's full name.
          '';
        };
        groupsClaim = mkOption {
          type = types.str;
          default = "groups";
          description = ''
            Name of the claim that contains the user's groups.
          '';
        };
        requiredGroups = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            List of group names that users must belong to in order to access
            FileSender.
          '';
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.auth.backend != "oidc"
          || (
            cfg.auth.oidc.issuer != "" && cfg.auth.oidc.clientID != "" && cfg.auth.oidc.clientSecretFile != null
          );
        message = ''
          services.filesender.oidc.issuer, clientID and clientSecretFile are
          required when services.filesender.settings.auth_sp_type = "oidc".
        '';
      }
    ];

    services.phpfpm = {
      pools.filesender = {
        user = cfg.user;
        group = config.services.nginx.group;
        phpEnv = {
          FILESENDER_CONFIG_DIR = toString filesenderConfigDirectory;
          FILESENDER_LOG_DIR = logDir;
        };
        settings = {
          "listen.owner" = config.services.nginx.user;
          "listen.group" = config.services.nginx.group;
        }
        // cfg.poolSettings;
      };
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      virtualHosts.${cfg.localDomain} = {
        root = "${cfg.package}/www";
        extraConfig = ''
          index index.php;
        '';
        locations = {
          "/".extraConfig = ''
            try_files $uri $uri/ /index.php?args;
          '';
          "~ [^/]\\.php(/|$)" = {
            extraConfig = ''
              fastcgi_split_path_info  ^(.+\.php)(/.+)$;
              fastcgi_pass  unix:${fpm.socket};
              include ${pkgs.nginx}/conf/fastcgi.conf;
              fastcgi_intercept_errors on;
              fastcgi_param PATH_INFO       $fastcgi_path_info;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            '';
          };
          "~ /\\.".extraConfig = "deny all;";
        };
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.filesender.settings = lib.mkMerge [
      (lib.mkIf cfg.database.createLocally {
        db_host = "/run/postgresql";
        db_port = "5432";
        db_password = "."; # FileSender requires it even when on UNIX socket auth.
      })
      (lib.mkIf (!cfg.database.createLocally) {
        db_host = cfg.database.hostname;
        db_port = toString cfg.database.port;
        db_password = format.lib.mkRaw "file_get_contents('${cfg.database.passwordFile}')";
      })
      (lib.mkIf (cfg.auth.backend == "oidc") {
        # Without this, the session is started only after the auth check, so a
        # successful OIDC callback is invisible to subsequent requests.
        # See: https://docs.filesender.org/filesender/v3.0/admin/configuration/#auth_sp_force_session_start_first
        auth_sp_force_session_start_first = true;

        auth_sp_oidc_issuer = cfg.auth.oidc.issuer;
        auth_sp_oidc_scopes = cfg.auth.oidc.scopes;
        auth_sp_oidc_uid_attribute = cfg.auth.oidc.uidAttribute;
        auth_sp_oidc_email_attribute = cfg.auth.oidc.emailAttribute;
        auth_sp_oidc_name_attribute = cfg.auth.oidc.nameAttribute;
        auth_sp_oidc_groups_claim = cfg.auth.oidc.groupsClaim;
      })
      (lib.mkIf (cfg.auth.backend == "oidc" && cfg.auth.oidc.requiredGroups != [ ]) {
        auth_sp_oidc_required_groups = cfg.auth.oidc.requiredGroups;
      })
      (lib.mkIf (cfg.auth.backend == "oidc" && cfg.auth.oidc.idpAttribute != null) {
        auth_sp_oidc_idp_attribute = cfg.auth.oidc.idpAttribute;
      })
      {
        site_url = lib.mkDefault "https://${cfg.localDomain}";
        db_type = "pgsql";
        db_username = cfg.database.user;
        db_database = cfg.database.name;

        tmp_path = lib.mkDefault "/var/lib/filesender/tmp";
        storage_filesystem_path = lib.mkDefault "/var/lib/filesender/files";
        storage_filesystem_shred_path = lib.mkDefault "/var/lib/filesender/shredfiles";

        auth_sp_type = cfg.auth.backend;
        auth_remote_user_default_domain = lib.mkDefault cfg.localDomain;
      }
    ];

    systemd.services.filesender-initdb = {
      description = "Init filesender DB";

      wantedBy = [
        "multi-user.target"
      ];
      before = [
        "phpfpm-filesender.service"
      ];
      after = lib.optional cfg.database.createLocally "postgresql.target";
      requires = lib.optional cfg.database.createLocally "postgresql.target";

      restartIfChanged = true;

      serviceConfig = {
        Environment = [
          "FILESENDER_CONFIG_DIR=${toString filesenderConfigDirectory}"
          "FILESENDER_LOG_DIR=${logDir}"
        ];
        Type = "oneshot";
        Group = config.services.nginx.group;
        User = "filesender";
        ExecStart = "${fpm.phpPackage}/bin/php ${cfg.package}/scripts/upgrade/database.php";
      };
    };

    users.extraUsers.filesender = lib.mkIf (cfg.user == "filesender") {
      home = stateDir;
      group = config.services.nginx.group;
      createHome = true;
      isSystemUser = true;
    };

    systemd.tmpfiles.settings = {
      "10-filesender" =
        let
          settings = {
            mode = "0750";
            user = cfg.user;
            group = config.services.nginx.group;
          };
        in
        {
          "${logDir}".d = settings;
          "${stateDir}".d = settings;
          "${stateDir}/files".d = settings;
          "${stateDir}/tmp".d = settings;
        };
    };
  };
}
