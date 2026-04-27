{
  options,
  config,
  lib,
  pkgs,
  utils,
  ...
}: let
  cfg = config.services.sync-in;
  yaml = pkgs.formats.yaml {};
  drizzleJsFile = ./drizzle.js;
in {
  options.services.sync-in = {
    enable = lib.mkEnableOption "Sync-in";

    package = mkPackageOption pkgs "sync-in" {};

    user = lib.mkOption {
      type = lib.types.str;
      default = "sync-in";
      description = "User to run sync-in service";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "sync-in";
      description = "Group to run sync-in service";
    };

    server = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "Host address the server binds to.";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 8080;
        description = "Port the server listens on.";
      };
      workers = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Number of worker processes (or CPUs) to use.";
      };
      trustProxy = lib.mkOption {
        type = lib.types.str;
        default = "1";
        description = "Trust proxy setting (number of hops, boolean, or IP range).";
      };
      restartOnFailure = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically restart workers if they crash.";
      };
      publicUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:8080";
        description = "Public URL used for external access.";
      };
    };
    logger = {
      level = lib.mkOption {
        type = lib.types.enum ["trace" "debug" "info" "warn" "error" "fatal"];
        default = "info";
        description = "Logging level.";
      };
      stdout = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "If false, logs are written to files instead of stdout.";
      };
      colorize = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable colored log output.";
      };
      jsonOutput = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable JSON log output (disables colorization).";
      };
      filePath = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/sync-in";
        description = "Path to log files when stdout is disabled.";
      };
    };
    mysql = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "syncin";
        description = "Database name.";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "syncin";
        description = "Database user.";
      };
      passwordFile = lib.mkOption {
        type = lib.types.str;
        default = "/etc/sync-in/mysql.password";
        description = "File containing the database password.";
      };
      password = lib.mkOption {
        type = lib.types.enum ["__DB_PASSWORD__"];
        default = "__DB_PASSWORD__";
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Database host.";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 3306;
        description = "Database port.";
      };
      logQueries = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable SQL query logging.";
      };
      cache = {
        adapter = lib.mkOption {
          type = lib.types.enum ["mysql" "redis"];
          default = "mysql";
          description = "Cache backend adapter.";
        };
        ttl = lib.mkOption {
          type = lib.types.int;
          default = 60;
          description = "Cache TTL in seconds.";
        };
        redis = lib.mkOption {
          type = lib.types.str;
          default = "redis://127.0.0.1:6379";
          description = "Redis connection URL when using redis cache.";
        };
      };
    };
    mail = {
      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "SMTP server hostname.";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 25;
        description = "SMTP server port.";
      };
      sender = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Sender email address.";
      };
      auth = {
        user = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "SMTP authentication username.";
        };
        passFile = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "/etc/sync-in/mail.password";
          description = "File containing SMTP password.";
        };
        pass = lib.mkOption {
          type = lib.types.enum ["__MAIL_PASS__"];
          default = "__MAIL_PASS__";
        };
      };
      secure = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use SSL for SMTP connection.";
      };
      ignoreTLS = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable STARTTLS even if supported.";
      };
      rejectUnauthorized = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Reject invalid TLS certificates.";
      };
      logger = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable logger";
      };
      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set log level to debug";
      };
    };
    websocket = {
      adapter = lib.mkOption {
        type = lib.types.enum ["cluster" "url"];
        default = "cluster";
        description = "adapter: `cluster` (Node.js Workers: default) | `redis`";
      };
      corsOrigine = lib.mkOption {
        type = lib.types.nullOr (lib.types.str);
        default = "*";
        description = "Cors origin allowed";
      };
      redis = lib.mkOption {
        type = lib.types.nullOr (lib.types.str);
        default = "redis://127.0.0.1:6379";
        description = "Redis adapter url";
      };
    };
    auth = {
      provider = lib.mkOption {
        type = lib.types.enum ["mysql" "ldap" "oidc"];
        default = "mysql";
        description = "Authentication method mysql | ldap | oidc";
      };
      encryptionKey = lib.mkOption {
        type = lib.types.nullOr (lib.types.str);
        default = null;
        description = "Key used to encrypt user secret keys in the database";
      };
      cookieSameSite = lib.mkOption {
        type = lib.types.enum ["lax" "strict"];
        default = "strict";
        description = " `lax` | `strict`";
      };
      token = {
        access = {
          secretFile = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = "/etc/sync-in/access.token";
            description = "Used for token and cookie signatures";
          };
          secret = lib.mkOption {
            type = lib.types.enum ["__ACCESS_TOKEN__"];
            default = "__ACCESS_TOKEN__";
            description = "Used for token and cookie signatures";
          };
          expiration = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = "30m";
            description = "token expiration = cookie maxAge";
          };
        };
        refresh = {
          secret = lib.mkOption {
            type = lib.types.enum ["__REFRESH_TOKEN__"];
            default = "__REFRESH_TOKEN__";
            description = "Used for token and cookie signatures";
          };
          secretFile = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = "/etc/sync-in/refresh.token";
            description = "Used for token and cookie signatures";
          };
          expiration = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = "30m";
            description = "token expiration = cookie maxAge";
          };
        };
      };
      mfa = {
        enabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable TOTP authentication";
        };
        issuer = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = "Sync-in";
          description = "Name displayed in the authentication app (FreeOTP, Proton Authenticator, Aegis Authenticator etc.)";
        };
      };

      ldap = {
        servers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = ''
            e.g.: [ldap://localhost:389, ldaps://localhost:636] (array required)
            Multiple servers are tried in order until a bind/search succeeds.
          '';
        };
        tlsOptions = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = null;
          description = ''
            tlsOptions: Node.js TLS options used for the LDAP secure connection.
            Supports standard TLS options such as `ca`, `rejectUnauthorized`, etc.
            See: https://nodejs.org/api/tls.html
                 https://nodejs.org/api/tls.html#tlscreatesecurecontextoptions
            Example:
              tlsOptions:
                rejectUnauthorized: true
                ca: [/app/certs/ca.pem]
            optional
          '';
        };
        baseDN = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = null;
          description = ''
            baseDN: Distinguished name (e.g.: ou=people,dc=ldap,dc=sync-in,dc=com)
            Used as the search base for users, and for groups when adminGroup is a CN.
          '';
        };
        filter = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = null;
          description = ''
            Appended as-is to the LDAP search filter (trusted config).
            Optional
          '';
        };
        upnSuffix = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = null;
          description = ''
            upnSuffix: AD domain suffix used with `userPrincipalName` to build UPN-style logins (e.g.: user@`sync-in.com`)
            Only used when login is set to userPrincipalName.
          '';
        };
        netbiosName = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = null;
          description = ''
            netbiosName: NetBIOS domain name used with `sAMAccountName` to build legacy logins (e.g.: `SYNC_IN`\user)
            Only used when login is set to sAMAccountName.
          '';
        };
        serverBindDN = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = null;
          description = ''
            serviceBindDN: Distinguished Name for a service account used to search users/groups.
            When set, searches are performed with this account; user bind is used only to validate the password.
            e.g.: cn=syncin,ou=services,dc=ldap,dc=sync-in,dc=com
          '';
        };
        serverBindPasswordFile = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = "/etc/sync-in/ldap.secret";
          description = "File path on running system for the secret Bind LDAP Password";
        };
        serverBindPassword = lib.mkOption {
          type = lib.types.enum ["__LDAP_PASSWORD__"];
          default = "__LDAP_PASSWORD__";
          description = ''
            serviceBindPassword: Password for the service account used to search users/groups.
            Optional
          '';
        };
        attributes = {
          login = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = "uid";
            description = ''
              .
            '';
          };
          email = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = "mail";
            description = ''
              LDAP attribute that matches the login stored in the database.
              With a service bind, it is used to locate the user (then bind with the found DN).
              Without a service bind, it is used to construct the user's DN for binding (except AD: UPN/DOMAIN\\user).
              If you choose mail, local logins should be the user's email address.
              e.g.: uid | cn | mail | sAMAccountName | userPrincipalName
              default: uid
            '';
          };
        };
        options = {
          autoCreateUser = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              autoCreateUser: Automatically create a local user on first successful LDAP authentication.
              The local account is created from LDAP attributes:
              - login: from the configured LDAP login attribute (e.g.: uid, cn, sAMAccountName, userPrincipalName)
              - email: from the configured email attribute (required)
              - firstName / lastName: from givenName+sn, or displayName, or cn (fallback)
              When disabled, only existing users can authenticate via LDAP.
            '';
          };
          autoCreatePermissions = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "personal_space"
              "spaces_access"
              "spaces_admin"
              "shares_access"
              "shares_admin"
              "personal_groups_admin"
              "webdav_access"
            ];
            description = ''
              autoCreatePermissions: Permissions assigned to users automatically created via LDAP.
              Applied only at user creation time when autoCreateUser is enabled.
              Has no effect on existing users.
              A complete list of permissions is available in the documentation: https://sync-in.com/docs/admin-guide/permissions
              e.g.: [personal_space, spaces_access] (array required)
              "personal_space" - Grants access to the user's own personal space.
              "spaces_access" - Grants access to collaborative spaces the user is a member of.
              "spaces_admin" - Allows the user to create, modify, and delete collaborative spaces.
              "shares_access" - Provides access to the Shared with Me module, which gathers all items shared with the user.
              "shares_admin" - Provides access to the Shared with Others module, allowing the user to view, modify, or revoke their outgoing shares.
              "guests_admin" - Allows the user to create, modify, and delete guests. Includes managing their managers and account information (name, email, password).
              "personal_groups_admin" - Allows the user to create personal groups and add or remove members.
              "desktop_app_access" - Authorizes access via the desktop application
              "desktop_app_sync" - Grants permission to synchronize files using the desktop or CLI client.
              "webdav_access" - Allows access to files via a WebDAV client
            '';
          };
          adminGroup = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = null;
            description = ''
              adminGroup: LDAP group that grants Sync-in administrator privileges.
              Accepts either a simple CN (e.g.: "Admins") or a full DN (e.g.: "CN=Admins,OU=Groups,DC=ldap,DC=sync-in,DC=com").
              If set, users whose LDAP `memberOf` contains this CN (or whose group DN matches) are assigned the administrator role.
              If `memberOf` is missing, Sync-in can also check membership by searching `groupOfNames` groups.
              If users cannot read `groupOfNames`, use a service bind account to perform this lookup.
              If not set, existing administrator users keep their role and it cannot be removed via LDAP.
              optional
            '';
          };
          enablePaswordAuthFallback = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              enablePasswordAuthFallback: Allow local password authentication when LDAP authentication fails.
              When enabled, users can authenticate with their local password if the LDAP service is unavailable.
              Always allowed for administrator users (break-glass access)
            '';
          };
        };
      };
      oidc = {
        issuerUrl = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = null;
          description = ''
            issuerUrl: The URL of the OIDC provider's discovery endpoint
            e.g.:
            - Keycloak:  https://auth.example.com/realms/my-realm
            - Authentik: https://auth.example.com/application/o/my-app/
            - Google:    https://accounts.google.com
            - Microsoft: https://login.microsoftonline.com/<tenant-id>/v2.0
            The server will automatically discover the authorization, token, and userinfo endpoints.
            required
          '';
        };
        clientId = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = null;
          description = ''
            clientId: OAuth 2.0 Client ID obtained from your OIDC provider
          '';
        };
        clientSecretFile = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = "/etc/sync-in/oidc.secret";
          description = ''
            clientSecret: OAuth 2.0 Client Secret obtained from your OIDC provider
          '';
        };
        clientSecret = lib.mkOption {
          type = lib.types.enum ["__OIDC_PASSWORD__"];
          default = "__OIDC_PASSWORD__";
          description = ''
            .
          '';
        };
        redirectUri = lib.mkOption {
          type = lib.types.nullOr (lib.types.str);
          default = null;
          description = ''
            redirectUri: The callback URL where users are redirected after authentication
            This URL must be registered in your OIDC provider's allowed redirect URIs
            e.g.: (API callback): https://sync-in.domain.com/api/auth/oidc/callback

            To allow authentication from the desktop application, the following redirect URLs must also be registered in your OIDC provider:
              - http://127.0.0.1:49152/oidc/callback
              - http://127.0.0.1:49153/oidc/callback
              - http://127.0.0.1:49154/oidc/callback

            If your OIDC provider supports wildcards or regular expressions, you may instead register a single entry such as:
              - http://127.0.0.1/*

            required
          '';
        };
        options = {
          autoCreateUser = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              autoCreateUser: Automatically create a local user account on first successful OIDC login.
              When enabled, the user `login` is derived from OIDC claims: preferred_username, then the email local-part, with `sub` as a last-resort fallback.
              When disabled, only existing users are allowed to authenticate via OIDC.
            '';
          };
          autoCreatePermissions = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = ["personal_space" "spaces_access" "webdav_access"];
            description = ''
              autoCreatePermissions: Permissions assigned to users automatically created via OIDC.
              Applied only when autoCreateUser is enabled and only applied at user creation time.
              This option has no effect on existing users.
              A complete list of permissions is available in the documentation: https://sync-in.com/docs/admin-guide/permissions
              e.g.: [personal_space, spaces_access] (array required)
            '';
          };
          adminRoleOrGroup = lib.mkOption {
            type = lib.types.str;
            default = "admin";
            description = ''
              adminRoleOrGroup: Name of the role or group that grants Sync-in administrator access
              Users with this value will be granted administrator privileges.
              The value is matched against `roles` or `groups` claims provided by the IdP.
              Note: depending on the provider (e.g.: Keycloak), roles/groups may be exposed only in tokens
              and require proper IdP mappers to be included in the ID token or UserInfo response.
              optional
            '';
          };
          enablePasswordAuth = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              enablePasswordAuth: Allow local password-based authentication when using OIDC.
              When enabled, users may authenticate with their Sync-in password instead of OIDC.
              Local password authentication is always allowed for:
              - guest users
              - administrator users (break-glass access)
              - application scopes (app passwords)
              Regular users are allowed only when this option is enabled.
              Users must already exist locally and have a password set.
            '';
          };
          autoRedirect = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              autoRedirect: Automatically redirect users to the OIDC login flow.
              When enabled, the login page is skipped and users are sent directly to the OIDC provider.
            '';
          };
          buttonText = lib.mkOption {
            type = lib.types.str;
            default = "Continue with OpenID Connect";
            description = ''
              buttonText: Label displayed on the OIDC login button.
            '';
          };
        };
        security = {
          scope = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = "openid email profile";
            description = ''
              scope: OAuth 2.0 scopes to request (space-separated string)
              Common scopes: openid (required), email, profile, groups, roles
              default: `openid email profile`
            '';
          };
          supportPKCE = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              supportPKCE: Enable PKCE (Proof Key for Code Exchange) in the authorization code flow.
              When true, PKCE is used if supported by the OIDC provider
            '';
          };
          tokenEndpointAuthMethod = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = "client_secret_basic";
            description = ''
              OAuth 2.0 / OIDC client authentication method used at the token endpoint.
              Possible values:
              - client_secret_basic (DEFAULT): HTTP Basic auth using client_id and client_secret.
                Recommended for backend (confidential) clients.
              - client_secret_post: client_id and client_secret sent in the request body.
              - none (or undefined): no client authentication (public clients: mobile / SPA with PKCE).
              default: `client_secret_basic`
            '';
          };
          tokenSigningAlg = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = "RS256";
            description = ''
              tokenSigningAlg: Algorithm used to verify the signature of ID tokens (JWT) returned by the OpenID Connect provider.
              Common values: RS256, RS384, RS512, ES256, ES384, ES512
            '';
          };
          userInfoSigningAlg = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = null;
            description = ''
              userInfoSigningAlg: Algorithm used to request a signed UserInfo response from the OpenID Connect provider.
              When not set, the UserInfo endpoint returns a standard JSON response (not signed). This is the most common and recommended configuration.
              Common values: (empty), RS256, RS384, RS512, ES256, ES384, ES512
            '';
          };
          skipSubjectCheck = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              skipSubjectCheck: Disable verification that the `sub` claim returned by the UserInfo endpoint
              matches the `sub` claim from the ID token.
              Set to true only for non-compliant or legacy OIDC providers.
            '';
          };
        };
      };
    };
    applications = {
      files = {
        dataPath = lib.mkOption {
          type = lib.types.str;
          default = "/var/lib/sync-in";
          description = ''
            Exerything seems here.
          '';
        };
        maxUploadSize = lib.mkOption {
          type = lib.types.int;
          default = 5368709120;
          description = ''
            5368709120 (5 GB)
          '';
        };
        contentIndexing = {
          enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = ''
              Enable indexing of file contents for search (disabling this turns off full-text search)
            '';
          };
          ocr = {
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Enable OCR on PDF
              '';
            };
            languages = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = ["eng"];
              description = ''
                OCR languages used by tesseract.js
                Supports ISO 639-2/T three-letter codes: 'eng', 'spa', 'fra', 'deu', etc.
                examples: `[eng,fra]`, `[fra]`
              '';
            };
            languagesPath = lib.mkOption {
              type = lib.types.nullOr (lib.types.str);
              default = null;
              description = ''
                Offline mode: do not download OCR languages, only use local language files from the built-in OCR folder
                To download languages, use this scheme: https://cdn.jsdelivr.net/npm/@tesseract.js-data/<lang>@1.0.0/4.0.0_best_int/<lang>.traineddata.gz
              '';
            };
            offline = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Path to local OCR language files
                Used when offline mode is enabled or to override default location
                default: built-in OCR directory
              '';
            };
          };
        };

        showHiddenFiles = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Show files starting with a dot in the file explorer
          '';
        };

        onlyoffice = {
          enabled = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              enable onlyoffice integration
            '';
          };
          externalServer = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = null;
            description = ''
              If no external server is configured, the local Nginx service from the Docker Compose setup is used.
              If an external server is configured, it will be used instead.
              Note: when using an external server (e.g.: https://onlyoffice.domain.com), make sure it is accessible from the client/browser.
              default: null
            '';
          };
          secret = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = null;
            description = ''
              Secret used for jwt tokens, it must be the same on the onlyoffice server
              required
            '';
          };
          verifySSL = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              If you use https, set to `true`.
            '';
          };
        };
        collabora = {
          enabled = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              enable collabora online integration
            '';
          };
          externalServer = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
            default = null;
            description = ''
              If no external server is configured, the local Nginx service from the Docker Compose setup is used.
              If an external server is configured, it will be used instead.
              Note: when using an external server (e.g.: https://collabora.domain.com), make sure it is accessible from the client/browser.
              default: null
            '';
          };
        };
      };
      appStore.repository = lib.mkOption {
        type = lib.types.enum ["public" "local"];
        default = "public";
        description = ''
          repository: `public` | `local`
        '';
      };
    };

    admin = {
      login = lib.mkOption {
        type = lib.types.str;
        default = "admin";
        description = ''
          Initial admin login
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.str;
        default = "/etc/sync-in/admin.password";
        description = ''
          Initial admin password read from this file.
        '';
      };
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional configuration merged into the generated YAML.";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      configFile = yaml.generate "environment.yaml" (
        lib.recursiveUpdate
        {
          server = cfg.server;
          logger = cfg.logger;
          mysql = {
            url = "mysql://${cfg.mysql.user}:__DB_PASSWORD__@${cfg.mysql.host}:${builtins.toString cfg.mysql.port}/${cfg.mysql.name}";
            logQueries = cfg.mysql.logQueries;
            cache = cfg.mysql.cache;
          };
          websocket = cfg.websocket;
          mail = cfg.mail;
          auth = cfg.auth;
          applications = cfg.applications;
        }
        cfg.extraSettings
      );
    in {
      services.mysql.enable = true;
      # services.redis.servers."syncin" = {
      #   enable = lib.mkIf (cfg.) true ;
      #   port = cfg.redis.port;
      #   bind = cfg.redis.host;
      # };

      systemd.tmpfiles.rules = [
        "d /etc/sync-in 0750 ${cfg.user} ${cfg.group}"
        "f ${cfg.mysql.passwordFile} 0600 ${cfg.user} ${cfg.group}"
        "f ${cfg.admin.passwordFile} 0600 ${cfg.user} ${cfg.group}"
        "f ${cfg.mail.auth.passFile} 0600 ${cfg.user} ${cfg.group}"
        "f ${cfg.auth.ldap.serverBindPasswordFile} 0600 ${cfg.user} ${cfg.group}"
        "f ${cfg.auth.token.access.secretFile} 0600 ${cfg.user} ${cfg.group}"
        "f ${cfg.auth.token.refresh.secretFile} 0600 ${cfg.user} ${cfg.group}"
        "f ${cfg.auth.oidc.clientSecretFile} 0600 ${cfg.user} ${cfg.group}"
      ];

      # environment.etc.sync-in = {

      # };

      # users.users.sync-in = {
      #   isSystemUser = true;
      #   home = cfg.applications.files.dataPath;
      #   createHome = true;
      #   group = cfg.group;
      # };

      # users.users."${cfg.user}" = {
      #   isSystemUser = true;
      #   # home = cfg.applications.files.dataPath;
      #   # createHome = true;
      #   group = cfg.group;
      # };

      # users.groups."${cfg.group}" = {};

      systemd.services.sync-in = {
        description = "Sync-in";
        wantedBy = ["multi-user.target"];
        after = ["network.target" "mysql.service"];
        # after = ["network.target" "mysql.service" "redis.service"];

        preStart = ''
          set -e
          cd ${cfg.applications.files.dataPath}

          DB_PASS=$(cat ${cfg.mysql.passwordFile})
          DB_USER=${cfg.mysql.user}
          DB_NAME=${cfg.mysql.name}
          DB_HOST=${cfg.mysql.host}
          DB_PORT=${builtins.toString cfg.mysql.port}
          DB_USER=${cfg.mysql.user}
          ADMIN_PASS=$(cat ${cfg.admin.passwordFile})
          MAIL_PASS=$(cat ${cfg.mail.auth.passFile})
          LDAP_PASS=$(cat ${cfg.auth.ldap.serverBindPasswordFile})
          OIDC_PASS=$(cat ${cfg.auth.oidc.clientSecretFile})
          ACCESS_TOKEN=$(cat ${cfg.auth.token.access.secretFile})
          REFRESH_TOKEN=$(cat ${cfg.auth.token.refresh.secretFile})

          # if [ -n "${builtins.toString cfg.auth.ldap.serverBindPasswordFile or ""}" ]; then
          #   LDAP_PASS=$(cat ${builtins.toString cfg.auth.ldap.serverBindPasswordFile})
          # fi

          cp ${configFile} ${cfg.applications.files.dataPath}/environment.yaml
          chmod ug+w ${cfg.applications.files.dataPath}/environment.yaml

          # substituteInPlace environment.yaml \
          #   --replace "__DB_PASSWORD__" "$DB_PASS" \
          #   --replace "__LDAP_PASSWORD__" "$LDAP_PASS"

          sed -i "s|__DB_PASSWORD__|$DB_PASS|g" ${cfg.applications.files.dataPath}/environment.yaml
          sed -i "s|__LDAP_PASSWORD__|$LDAP_PASS|g" ${cfg.applications.files.dataPath}/environment.yaml

          sed -i "s|__MAIL_PASS__|$MAIL_PASS|g" ${cfg.applications.files.dataPath}/environment.yaml
          sed -i "s|__LDAP_PASSWORD__|$LDAP_PASS|g" ${cfg.applications.files.dataPath}/environment.yaml
          sed -i "s|__OIDC_PASSWORD__|$OIDC_PASS|g" ${cfg.applications.files.dataPath}/environment.yaml
          sed -i "s|__ACCESS_TOKEN__|$ACCESS_TOKEN|g" ${cfg.applications.files.dataPath}/environment.yaml
          sed -i "s|__REFRESH_TOKEN__|$REFRESH_TOKEN|g" ${cfg.applications.files.dataPath}/environment.yaml
          sed -i -E '/ecretFile:|asswordFile:|assFile:|: null$/d' ${cfg.applications.files.dataPath}/environment.yaml

          cp ${drizzleJsFile} ${cfg.applications.files.dataPath}/drizzle.js
          chown ${cfg.user}:${cfg.group} ${cfg.applications.files.dataPath}/drizzle.js

          sed -i "s|\./release/sync-in-server/server/|${cfg.package}/lib/release/sync-in-server/server/|g" ${cfg.applications.files.dataPath}/drizzle.js
          sed -i "s|__PASSWORD__|$DB_PASS|g" ${cfg.applications.files.dataPath}/drizzle.js
          sed -i "s|__USER__|$DB_USER|g" ${cfg.applications.files.dataPath}/drizzle.js
          sed -i "s|__HOST__|$DB_HOST|g" ${cfg.applications.files.dataPath}/drizzle.js
          sed -i "s|__PORT__|$DB_PORT|g" ${cfg.applications.files.dataPath}/drizzle.js
          sed -i "s|__NAME__|$DB_NAME|g" ${cfg.applications.files.dataPath}/drizzle.js


          if [ ! -f .initialized ]; then
            ${cfg.package}/bin/sync-in init
            touch .initialized
          fi

          ${pkgs.mariadb}/bin/mariadb <<EOF
          CREATE DATABASE IF NOT EXISTS ${cfg.mysql.name};
          CREATE USER IF NOT EXISTS '${cfg.mysql.user}'@'${cfg.mysql.host}' IDENTIFIED BY '$DB_PASS';
          GRANT ALL PRIVILEGES ON ${cfg.mysql.name}.* TO '${cfg.mysql.user}'@'${cfg.mysql.host}';
          FLUSH PRIVILEGES;
          EOF

          sed "s|/etc/sync-in/drizzle.js|${cfg.applications.files.dataPath}/drizzle.js|g" ${cfg.package}/bin/sync-in-migrate-db >  ${cfg.applications.files.dataPath}/sync-in-migrate-db
          chown ug+x sync-in-migrate-db

          ${cfg.applications.files.dataPath}/sync-in-migrate-db

          if [ ! -f .admin_created ]; then
            ${cfg.package}/bin/sync-in create-user \
              --role admin \
              --login "${cfg.admin.login}" \
              --password "$ADMIN_PASS"

            touch .admin_created
          fi
        '';

        serviceConfig = {
          ExecStart = "${pkgs.nodejs_24}/bin/node ${cfg.package}/lib/release/sync-in-server/sync-in-server.js start";
          # ExecStart = "${cfg.package}/bin/sync-in-start";
          Restart = "always";
          User = "${cfg.user}";
          Group = "${cfg.group}";
          Environment = "NODE_PATH=${pkgs.nodejs_24}/lib/node_modules:${cfg.package}/lib/node_modules";
          WorkingDirectory = cfg.applications.files.dataPath;
        };
      };
    }
  );
}
