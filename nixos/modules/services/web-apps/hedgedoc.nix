{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hedgedoc;

  # 21.03 will not be an official release - it was instead 21.05.  This
  # versionAtLeast statement remains set to 21.03 for backwards compatibility.
  # See https://github.com/NixOS/nixpkgs/pull/108899 and
  # https://github.com/NixOS/rfcs/blob/master/rfcs/0080-nixos-release-schedule.md.
  name = if versionAtLeast config.system.stateVersion "21.03"
    then "hedgedoc"
    else "codimd";

  settingsFormat = pkgs.formats.json {};

  prettyJSON = conf:
    pkgs.runCommandLocal "hedgedoc-config.json" {
      nativeBuildInputs = [ pkgs.jq ];
    } ''
      jq '{production:del(.[]|nulls)|del(.[][]?|nulls)}' \
        < ${settingsFormat.generate "hedgedoc-ugly.json" cfg.settings} \
        > $out
    '';
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "codimd" ] [ "services" "hedgedoc" ])
    (mkRenamedOptionModule
      [ "services" "hedgedoc" "configuration" ] [ "services" "hedgedoc" "settings" ])
  ];

  options.services.hedgedoc = {
    enable = mkEnableOption "the HedgeDoc Markdown Editor";

    groups = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Groups to which the service user should be added.
      '';
    };

    workDir = mkOption {
      type = types.path;
      default = "/var/lib/${name}";
      description = lib.mdDoc ''
        Working directory for the HedgeDoc service.
      '';
    };

    settings = let options = {
      debug = mkEnableOption "debug mode";
      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "hedgedoc.org";
        description = lib.mdDoc ''
          Domain name for the HedgeDoc instance.
        '';
      };
      urlPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/url/path/to/hedgedoc";
        description = lib.mdDoc ''
          Path under which HedgeDoc is accessible.
        '';
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc ''
          Address to listen on.
        '';
      };
      port = mkOption {
        type = types.int;
        default = 3000;
        example = 80;
        description = lib.mdDoc ''
          Port to listen on.
        '';
      };
      path = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/run/hedgedoc.sock";
        description = lib.mdDoc ''
          Specify where a UNIX domain socket should be placed.
        '';
      };
      allowOrigin = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "localhost" "hedgedoc.org" ];
        description = lib.mdDoc ''
          List of domains to whitelist.
        '';
      };
      useSSL = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable to use SSL server. This will also enable
          {option}`protocolUseSSL`.
        '';
      };
      hsts = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether to enable HSTS if HTTPS is also enabled.
          '';
        };
        maxAgeSeconds = mkOption {
          type = types.int;
          default = 31536000;
          description = lib.mdDoc ''
            Max duration for clients to keep the HSTS status.
          '';
        };
        includeSubdomains = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether to include subdomains in HSTS.
          '';
        };
        preload = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether to allow preloading of the site's HSTS status.
          '';
        };
      };
      csp = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        example = literalExpression ''
          {
            enable = true;
            directives = {
              scriptSrc = "trustworthy.scripts.example.com";
            };
            upgradeInsecureRequest = "auto";
            addDefaults = true;
          }
        '';
        description = lib.mdDoc ''
          Specify the Content Security Policy which is passed to Helmet.
          For configuration details see <https://helmetjs.github.io/docs/csp/>.
        '';
      };
      protocolUseSSL = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable to use TLS for resource paths.
          This only applies when {option}`domain` is set.
        '';
      };
      urlAddPort = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable to add the port to callback URLs.
          This only applies when {option}`domain` is set
          and only for ports other than 80 and 443.
        '';
      };
      useCDN = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to use CDN resources or not.
        '';
      };
      allowAnonymous = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to allow anonymous usage.
        '';
      };
      allowAnonymousEdits = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to allow guests to edit existing notes with the `freely` permission,
          when {option}`allowAnonymous` is enabled.
        '';
      };
      allowFreeURL = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to allow note creation by accessing a nonexistent note URL.
        '';
      };
      requireFreeURLAuthentication = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to require authentication for FreeURL mode style note creation.
        '';
      };
      defaultPermission = mkOption {
        type = types.enum [ "freely" "editable" "limited" "locked" "private" ];
        default = "editable";
        description = lib.mdDoc ''
          Default permissions for notes.
          This only applies for signed-in users.
        '';
      };
      dbURL = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = ''
          postgres://user:pass@host:5432/dbname
        '';
        description = lib.mdDoc ''
          Specify which database to use.
          HedgeDoc supports mysql, postgres, sqlite and mssql.
          See [
          https://sequelize.readthedocs.io/en/v3/](https://sequelize.readthedocs.io/en/v3/) for more information.
          Note: This option overrides {option}`db`.
        '';
      };
      db = mkOption {
        type = types.attrs;
        default = {};
        example = literalExpression ''
          {
            dialect = "sqlite";
            storage = "/var/lib/${name}/db.${name}.sqlite";
          }
        '';
        description = lib.mdDoc ''
          Specify the configuration for sequelize.
          HedgeDoc supports mysql, postgres, sqlite and mssql.
          See [
          https://sequelize.readthedocs.io/en/v3/](https://sequelize.readthedocs.io/en/v3/) for more information.
          Note: This option overrides {option}`db`.
        '';
      };
      sslKeyPath= mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/hedgedoc/hedgedoc.key";
        description = lib.mdDoc ''
          Path to the SSL key. Needed when {option}`useSSL` is enabled.
        '';
      };
      sslCertPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/hedgedoc/hedgedoc.crt";
        description = lib.mdDoc ''
          Path to the SSL cert. Needed when {option}`useSSL` is enabled.
        '';
      };
      sslCAPath = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "/var/lib/hedgedoc/ca.crt" ];
        description = lib.mdDoc ''
          SSL ca chain. Needed when {option}`useSSL` is enabled.
        '';
      };
      dhParamPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/hedgedoc/dhparam.pem";
        description = lib.mdDoc ''
          Path to the SSL dh params. Needed when {option}`useSSL` is enabled.
        '';
      };
      tmpPath = mkOption {
        type = types.str;
        default = "/tmp";
        description = lib.mdDoc ''
          Path to the temp directory HedgeDoc should use.
          Note that {option}`serviceConfig.PrivateTmp` is enabled for
          the HedgeDoc systemd service by default.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      defaultNotePath = mkOption {
        type = types.nullOr types.str;
        default = "./public/default.md";
        description = lib.mdDoc ''
          Path to the default Note file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      docsPath = mkOption {
        type = types.nullOr types.str;
        default = "./public/docs";
        description = lib.mdDoc ''
          Path to the docs directory.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      indexPath = mkOption {
        type = types.nullOr types.str;
        default = "./public/views/index.ejs";
        description = lib.mdDoc ''
          Path to the index template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      hackmdPath = mkOption {
        type = types.nullOr types.str;
        default = "./public/views/hackmd.ejs";
        description = lib.mdDoc ''
          Path to the hackmd template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      errorPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        defaultText = literalExpression "./public/views/error.ejs";
        description = lib.mdDoc ''
          Path to the error template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      prettyPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        defaultText = literalExpression "./public/views/pretty.ejs";
        description = lib.mdDoc ''
          Path to the pretty template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      slidePath = mkOption {
        type = types.nullOr types.str;
        default = null;
        defaultText = literalExpression "./public/views/slide.hbs";
        description = lib.mdDoc ''
          Path to the slide template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      uploadsPath = mkOption {
        type = types.str;
        default = "${cfg.workDir}/uploads";
        defaultText = literalExpression "/var/lib/${name}/uploads";
        description = lib.mdDoc ''
          Path under which uploaded files are saved.
        '';
      };
      sessionName = mkOption {
        type = types.str;
        default = "connect.sid";
        description = lib.mdDoc ''
          Specify the name of the session cookie.
        '';
      };
      sessionSecret = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Specify the secret used to sign the session cookie.
          If unset, one will be generated on startup.
        '';
      };
      sessionLife = mkOption {
        type = types.int;
        default = 1209600000;
        description = lib.mdDoc ''
          Session life time in milliseconds.
        '';
      };
      heartbeatInterval = mkOption {
        type = types.int;
        default = 5000;
        description = lib.mdDoc ''
          Specify the socket.io heartbeat interval.
        '';
      };
      heartbeatTimeout = mkOption {
        type = types.int;
        default = 10000;
        description = lib.mdDoc ''
          Specify the socket.io heartbeat timeout.
        '';
      };
      documentMaxLength = mkOption {
        type = types.int;
        default = 100000;
        description = lib.mdDoc ''
          Specify the maximum document length.
        '';
      };
      email = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable email sign-in.
        '';
      };
      allowEmailRegister = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable email registration.
        '';
      };
      allowGravatar = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to use gravatar as profile picture source.
        '';
      };
      imageUploadType = mkOption {
        type = types.enum [ "imgur" "s3" "minio" "filesystem" ];
        default = "filesystem";
        description = lib.mdDoc ''
          Specify where to upload images.
        '';
      };
      minio = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            accessKey = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Minio access key.
              '';
            };
            secretKey = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Minio secret key.
              '';
            };
            endPoint = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Minio endpoint.
              '';
            };
            port = mkOption {
              type = types.int;
              default = 9000;
              description = lib.mdDoc ''
                Minio listen port.
              '';
            };
            secure = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc ''
                Whether to use HTTPS for Minio.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the minio third-party integration.";
      };
      s3 = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            accessKeyId = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                AWS access key id.
              '';
            };
            secretAccessKey = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                AWS access key.
              '';
            };
            region = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                AWS S3 region.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the s3 third-party integration.";
      };
      s3bucket = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Specify the bucket name for upload types `s3` and `minio`.
        '';
      };
      allowPDFExport = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable PDF exports.
        '';
      };
      imgur.clientId = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Imgur API client ID.
        '';
      };
      azure = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            connectionString = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Azure Blob Storage connection string.
              '';
            };
            container = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Azure Blob Storage container name.
                It will be created if non-existent.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the azure third-party integration.";
      };
      oauth2 = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            authorizationURL = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Specify the OAuth authorization URL.
              '';
            };
            tokenURL = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Specify the OAuth token URL.
              '';
            };
            baseURL = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Specify the OAuth base URL.
              '';
            };
            userProfileURL = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Specify the OAuth userprofile URL.
              '';
            };
            userProfileUsernameAttr = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Specify the name of the attribute for the username from the claim.
              '';
            };
            userProfileDisplayNameAttr = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Specify the name of the attribute for the display name from the claim.
              '';
            };
            userProfileEmailAttr = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Specify the name of the attribute for the email from the claim.
              '';
            };
            scope = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Specify the OAuth scope.
              '';
            };
            providerName = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Specify the name to be displayed for this strategy.
              '';
            };
            rolesClaim = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Specify the role claim name.
              '';
            };
            accessRole = mkOption {
              type = with types; nullOr str;
              default = null;
              description = lib.mdDoc ''
                Specify role which should be included in the ID token roles claim to grant access
              '';
            };
            clientID = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Specify the OAuth client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Specify the OAuth client secret.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the OAuth integration.";
      };
      facebook = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            clientID = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Facebook API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Facebook API client secret.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the facebook third-party integration";
      };
      twitter = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            consumerKey = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Twitter API consumer key.
              '';
            };
            consumerSecret = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Twitter API consumer secret.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the Twitter third-party integration.";
      };
      github = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            clientID = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                GitHub API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Github API client secret.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the GitHub third-party integration.";
      };
      gitlab = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            baseURL = mkOption {
              type = types.str;
              default = "";
              description = lib.mdDoc ''
                GitLab API authentication endpoint.
                Only needed for other endpoints than gitlab.com.
              '';
            };
            clientID = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                GitLab API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                GitLab API client secret.
              '';
            };
            scope = mkOption {
              type = types.enum [ "api" "read_user" ];
              default = "api";
              description = lib.mdDoc ''
                GitLab API requested scope.
                GitLab snippet import/export requires api scope.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the GitLab third-party integration.";
      };
      mattermost = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            baseURL = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Mattermost authentication endpoint.
              '';
            };
            clientID = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Mattermost API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Mattermost API client secret.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the Mattermost third-party integration.";
      };
      dropbox = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            clientID = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Dropbox API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Dropbox API client secret.
              '';
            };
            appKey = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Dropbox app key.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the Dropbox third-party integration.";
      };
      google = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            clientID = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Google API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Google API client secret.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the Google third-party integration.";
      };
      ldap = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            providerName = mkOption {
              type = types.str;
              default = "";
              description = lib.mdDoc ''
                Optional name to be displayed at login form, indicating the LDAP provider.
              '';
            };
            url = mkOption {
              type = types.str;
              example = "ldap://localhost";
              description = lib.mdDoc ''
                URL of LDAP server.
              '';
            };
            bindDn = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Bind DN for LDAP access.
              '';
            };
            bindCredentials = mkOption {
              type = types.str;
              description = lib.mdDoc ''
                Bind credentials for LDAP access.
              '';
            };
            searchBase = mkOption {
              type = types.str;
              example = "o=users,dc=example,dc=com";
              description = lib.mdDoc ''
                LDAP directory to begin search from.
              '';
            };
            searchFilter = mkOption {
              type = types.str;
              example = "(uid={{username}})";
              description = lib.mdDoc ''
                LDAP filter to search with.
              '';
            };
            searchAttributes = mkOption {
              type = types.nullOr (types.listOf types.str);
              default = null;
              example = [ "displayName" "mail" ];
              description = lib.mdDoc ''
                LDAP attributes to search with.
              '';
            };
            userNameField = mkOption {
              type = types.str;
              default = "";
              description = lib.mdDoc ''
                LDAP field which is used as the username on HedgeDoc.
                By default {option}`useridField` is used.
              '';
            };
            useridField = mkOption {
              type = types.str;
              example = "uid";
              description = lib.mdDoc ''
                LDAP field which is a unique identifier for users on HedgeDoc.
              '';
            };
            tlsca = mkOption {
              type = types.str;
              default = "/etc/ssl/certs/ca-certificates.crt";
              example = "server-cert.pem,root.pem";
              description = lib.mdDoc ''
                Root CA for LDAP TLS in PEM format.
              '';
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the LDAP integration.";
      };
      saml = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            idpSsoUrl = mkOption {
              type = types.str;
              example = "https://idp.example.com/sso";
              description = lib.mdDoc ''
                IdP authentication endpoint.
              '';
            };
            idpCert = mkOption {
              type = types.path;
              example = "/path/to/cert.pem";
              description = lib.mdDoc ''
                Path to IdP certificate file in PEM format.
              '';
            };
            issuer = mkOption {
              type = types.str;
              default = "";
              description = lib.mdDoc ''
                Optional identity of the service provider.
                This defaults to the server URL.
              '';
            };
            identifierFormat = mkOption {
              type = types.str;
              default = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress";
              description = lib.mdDoc ''
                Optional name identifier format.
              '';
            };
            groupAttribute = mkOption {
              type = types.str;
              default = "";
              example = "memberOf";
              description = lib.mdDoc ''
                Optional attribute name for group list.
              '';
            };
            externalGroups = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "Temporary-staff" "External-users" ];
              description = lib.mdDoc ''
                Excluded group names.
              '';
            };
            requiredGroups = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "Hedgedoc-Users" ];
              description = lib.mdDoc ''
                Required group names.
              '';
            };
            providerName = mkOption {
              type = types.str;
              default = "";
              example = "My institution";
              description = lib.mdDoc ''
                Optional name to be displayed at login form indicating the SAML provider.
              '';
            };
            attribute = {
              id = mkOption {
                type = types.str;
                default = "";
                description = lib.mdDoc ''
                  Attribute map for `id'.
                  Defaults to `NameID' of SAML response.
                '';
              };
              username = mkOption {
                type = types.str;
                default = "";
                description = lib.mdDoc ''
                  Attribute map for `username'.
                  Defaults to `NameID' of SAML response.
                '';
              };
              email = mkOption {
                type = types.str;
                default = "";
                description = lib.mdDoc ''
                  Attribute map for `email`.
                  Defaults to `NameID` of SAML response if
                  {option}`identifierFormat` has
                  the default value.
                '';
              };
            };
          };
        });
        default = null;
        description = lib.mdDoc "Configure the SAML integration.";
      };
    }; in lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        inherit options;
      };
      description = lib.mdDoc ''
        HedgeDoc configuration, see
        <https://docs.hedgedoc.org/configuration/>
        for documentation.
      '';
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/var/lib/hedgedoc/hedgedoc.env";
      description = ''
        Environment file as defined in <citerefentry><refentrytitle>systemd.exec</refentrytitle><manvolnum>5</manvolnum></citerefentry>.

        Secrets may be passed to the service without adding them to the world-readable
        Nix store, by specifying placeholder variables as the option value in Nix and
        setting these variables accordingly in the environment file.

        <programlisting>
          # snippet of HedgeDoc-related config
          services.hedgedoc.configuration.dbURL = "postgres://hedgedoc:\''${DB_PASSWORD}@db-host:5432/hedgedocdb";
          services.hedgedoc.configuration.minio.secretKey = "$MINIO_SECRET_KEY";
        </programlisting>

        <programlisting>
          # content of the environment file
          DB_PASSWORD=verysecretdbpassword
          MINIO_SECRET_KEY=verysecretminiokey
        </programlisting>

        Note that this file needs to be available on the host on which
        <literal>HedgeDoc</literal> is running.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hedgedoc;
      defaultText = literalExpression "pkgs.hedgedoc";
      description = lib.mdDoc ''
        Package that provides HedgeDoc.
      '';
    };

  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.settings.db == {} -> (
          cfg.settings.dbURL != "" && cfg.settings.dbURL != null
        );
        message = "Database configuration for HedgeDoc missing."; }
    ];
    users.groups.${name} = {};
    users.users.${name} = {
      description = "HedgeDoc service user";
      group = name;
      extraGroups = cfg.groups;
      home = cfg.workDir;
      createHome = true;
      isSystemUser = true;
    };

    systemd.services.hedgedoc = {
      description = "HedgeDoc Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      preStart = ''
        ${pkgs.envsubst}/bin/envsubst \
          -o ${cfg.workDir}/config.json \
          -i ${prettyJSON cfg.settings}
        mkdir -p ${cfg.settings.uploadsPath}
      '';
      serviceConfig = {
        WorkingDirectory = cfg.workDir;
        StateDirectory = [ cfg.workDir cfg.settings.uploadsPath ];
        ExecStart = "${cfg.package}/bin/hedgedoc";
        EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
        Environment = [
          "CMD_CONFIG_FILE=${cfg.workDir}/config.json"
          "NODE_ENV=production"
        ];
        Restart = "always";
        User = name;
        PrivateTmp = true;
      };
    };
  };
}
