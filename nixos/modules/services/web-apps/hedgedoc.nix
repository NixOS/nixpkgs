{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hedgedoc;

  name = if versionAtLeast config.system.stateVersion "21.03"
    then "hedgedoc"
    else "codimd";

  prettyJSON = conf:
    pkgs.runCommandLocal "hedgedoc-config.json" {
      nativeBuildInputs = [ pkgs.jq ];
    } ''
      echo '${builtins.toJSON conf}' | jq \
        '{production:del(.[]|nulls)|del(.[][]?|nulls)}' > $out
    '';
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "codimd" ] [ "services" "hedgedoc" ])
  ];

  options.services.hedgedoc = {
    enable = mkEnableOption "the HedgeDoc Markdown Editor";

    groups = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Groups to which the user ${name} should be added.
      '';
    };

    workDir = mkOption {
      type = types.path;
      default = "/var/lib/${name}";
      description = ''
        Working directory for the HedgeDoc service.
      '';
    };

    configuration = {
      debug = mkEnableOption "debug mode";
      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "hedgedoc.org";
        description = ''
          Domain name for the HedgeDoc instance.
        '';
      };
      urlPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/url/path/to/hedgedoc";
        description = ''
          Path under which HedgeDoc is accessible.
        '';
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Address to listen on.
        '';
      };
      port = mkOption {
        type = types.int;
        default = 3000;
        example = "80";
        description = ''
          Port to listen on.
        '';
      };
      path = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/run/hedgedoc.sock";
        description = ''
          Specify where a UNIX domain socket should be placed.
        '';
      };
      allowOrigin = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "localhost" "hedgedoc.org" ];
        description = ''
          List of domains to whitelist.
        '';
      };
      useSSL = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable to use SSL server. This will also enable
          <option>protocolUseSSL</option>.
        '';
      };
      hsts = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to enable HSTS if HTTPS is also enabled.
          '';
        };
        maxAgeSeconds = mkOption {
          type = types.int;
          default = 31536000;
          description = ''
            Max duration for clients to keep the HSTS status.
          '';
        };
        includeSubdomains = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to include subdomains in HSTS.
          '';
        };
        preload = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to allow preloading of the site's HSTS status.
          '';
        };
      };
      csp = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        example = literalExample ''
          {
            enable = true;
            directives = {
              scriptSrc = "trustworthy.scripts.example.com";
            };
            upgradeInsecureRequest = "auto";
            addDefaults = true;
          }
        '';
        description = ''
          Specify the Content Security Policy which is passed to Helmet.
          For configuration details see <link xlink:href="https://helmetjs.github.io/docs/csp/"
          >https://helmetjs.github.io/docs/csp/</link>.
        '';
      };
      protocolUseSSL = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable to use TLS for resource paths.
          This only applies when <option>domain</option> is set.
        '';
      };
      urlAddPort = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable to add the port to callback URLs.
          This only applies when <option>domain</option> is set
          and only for ports other than 80 and 443.
        '';
      };
      useCDN = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use CDN resources or not.
        '';
      };
      allowAnonymous = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to allow anonymous usage.
        '';
      };
      allowAnonymousEdits = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to allow guests to edit existing notes with the `freely' permission,
          when <option>allowAnonymous</option> is enabled.
        '';
      };
      allowFreeURL = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to allow note creation by accessing a nonexistent note URL.
        '';
      };
      defaultPermission = mkOption {
        type = types.enum [ "freely" "editable" "limited" "locked" "private" ];
        default = "editable";
        description = ''
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
        description = ''
          Specify which database to use.
          HedgeDoc supports mysql, postgres, sqlite and mssql.
          See <link xlink:href="https://sequelize.readthedocs.io/en/v3/">
          https://sequelize.readthedocs.io/en/v3/</link> for more information.
          Note: This option overrides <option>db</option>.
        '';
      };
      db = mkOption {
        type = types.attrs;
        default = {};
        example = literalExample ''
          {
            dialect = "sqlite";
            storage = "/var/lib/${name}/db.${name}.sqlite";
          }
        '';
        description = ''
          Specify the configuration for sequelize.
          HedgeDoc supports mysql, postgres, sqlite and mssql.
          See <link xlink:href="https://sequelize.readthedocs.io/en/v3/">
          https://sequelize.readthedocs.io/en/v3/</link> for more information.
          Note: This option overrides <option>db</option>.
        '';
      };
      sslKeyPath= mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/hedgedoc/hedgedoc.key";
        description = ''
          Path to the SSL key. Needed when <option>useSSL</option> is enabled.
        '';
      };
      sslCertPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/hedgedoc/hedgedoc.crt";
        description = ''
          Path to the SSL cert. Needed when <option>useSSL</option> is enabled.
        '';
      };
      sslCAPath = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "/var/lib/hedgedoc/ca.crt" ];
        description = ''
          SSL ca chain. Needed when <option>useSSL</option> is enabled.
        '';
      };
      dhParamPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/hedgedoc/dhparam.pem";
        description = ''
          Path to the SSL dh params. Needed when <option>useSSL</option> is enabled.
        '';
      };
      tmpPath = mkOption {
        type = types.str;
        default = "/tmp";
        description = ''
          Path to the temp directory HedgeDoc should use.
          Note that <option>serviceConfig.PrivateTmp</option> is enabled for
          the HedgeDoc systemd service by default.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      defaultNotePath = mkOption {
        type = types.nullOr types.str;
        default = "./public/default.md";
        description = ''
          Path to the default Note file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      docsPath = mkOption {
        type = types.nullOr types.str;
        default = "./public/docs";
        description = ''
          Path to the docs directory.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      indexPath = mkOption {
        type = types.nullOr types.str;
        default = "./public/views/index.ejs";
        description = ''
          Path to the index template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      hackmdPath = mkOption {
        type = types.nullOr types.str;
        default = "./public/views/hackmd.ejs";
        description = ''
          Path to the hackmd template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      errorPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        defaultText = "./public/views/error.ejs";
        description = ''
          Path to the error template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      prettyPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        defaultText = "./public/views/pretty.ejs";
        description = ''
          Path to the pretty template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      slidePath = mkOption {
        type = types.nullOr types.str;
        default = null;
        defaultText = "./public/views/slide.hbs";
        description = ''
          Path to the slide template file.
          (Non-canonical paths are relative to HedgeDoc's base directory)
        '';
      };
      uploadsPath = mkOption {
        type = types.str;
        default = "${cfg.workDir}/uploads";
        defaultText = "/var/lib/${name}/uploads";
        description = ''
          Path under which uploaded files are saved.
        '';
      };
      sessionName = mkOption {
        type = types.str;
        default = "connect.sid";
        description = ''
          Specify the name of the session cookie.
        '';
      };
      sessionSecret = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Specify the secret used to sign the session cookie.
          If unset, one will be generated on startup.
        '';
      };
      sessionLife = mkOption {
        type = types.int;
        default = 1209600000;
        description = ''
          Session life time in milliseconds.
        '';
      };
      heartbeatInterval = mkOption {
        type = types.int;
        default = 5000;
        description = ''
          Specify the socket.io heartbeat interval.
        '';
      };
      heartbeatTimeout = mkOption {
        type = types.int;
        default = 10000;
        description = ''
          Specify the socket.io heartbeat timeout.
        '';
      };
      documentMaxLength = mkOption {
        type = types.int;
        default = 100000;
        description = ''
          Specify the maximum document length.
        '';
      };
      email = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable email sign-in.
        '';
      };
      allowEmailRegister = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable email registration.
        '';
      };
      allowGravatar = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to use gravatar as profile picture source.
        '';
      };
      imageUploadType = mkOption {
        type = types.enum [ "imgur" "s3" "minio" "filesystem" ];
        default = "filesystem";
        description = ''
          Specify where to upload images.
        '';
      };
      minio = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            accessKey = mkOption {
              type = types.str;
              description = ''
                Minio access key.
              '';
            };
            secretKey = mkOption {
              type = types.str;
              description = ''
                Minio secret key.
              '';
            };
            endpoint = mkOption {
              type = types.str;
              description = ''
                Minio endpoint.
              '';
            };
            port = mkOption {
              type = types.int;
              default = 9000;
              description = ''
                Minio listen port.
              '';
            };
            secure = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether to use HTTPS for Minio.
              '';
            };
          };
        });
        default = null;
        description = "Configure the minio third-party integration.";
      };
      s3 = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            accessKeyId = mkOption {
              type = types.str;
              description = ''
                AWS access key id.
              '';
            };
            secretAccessKey = mkOption {
              type = types.str;
              description = ''
                AWS access key.
              '';
            };
            region = mkOption {
              type = types.str;
              description = ''
                AWS S3 region.
              '';
            };
          };
        });
        default = null;
        description = "Configure the s3 third-party integration.";
      };
      s3bucket = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Specify the bucket name for upload types <literal>s3</literal> and <literal>minio</literal>.
        '';
      };
      allowPDFExport = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable PDF exports.
        '';
      };
      imgur.clientId = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Imgur API client ID.
        '';
      };
      azure = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            connectionString = mkOption {
              type = types.str;
              description = ''
                Azure Blob Storage connection string.
              '';
            };
            container = mkOption {
              type = types.str;
              description = ''
                Azure Blob Storage container name.
                It will be created if non-existent.
              '';
            };
          };
        });
        default = null;
        description = "Configure the azure third-party integration.";
      };
      oauth2 = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            authorizationURL = mkOption {
              type = types.str;
              description = ''
                Specify the OAuth authorization URL.
              '';
            };
            tokenURL = mkOption {
              type = types.str;
              description = ''
                Specify the OAuth token URL.
              '';
            };
            clientID = mkOption {
              type = types.str;
              description = ''
                Specify the OAuth client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = ''
                Specify the OAuth client secret.
              '';
            };
          };
        });
        default = null;
        description = "Configure the OAuth integration.";
      };
      facebook = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            clientID = mkOption {
              type = types.str;
              description = ''
                Facebook API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = ''
                Facebook API client secret.
              '';
            };
          };
        });
        default = null;
        description = "Configure the facebook third-party integration";
      };
      twitter = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            consumerKey = mkOption {
              type = types.str;
              description = ''
                Twitter API consumer key.
              '';
            };
            consumerSecret = mkOption {
              type = types.str;
              description = ''
                Twitter API consumer secret.
              '';
            };
          };
        });
        default = null;
        description = "Configure the Twitter third-party integration.";
      };
      github = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            clientID = mkOption {
              type = types.str;
              description = ''
                GitHub API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = ''
                Github API client secret.
              '';
            };
          };
        });
        default = null;
        description = "Configure the GitHub third-party integration.";
      };
      gitlab = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            baseURL = mkOption {
              type = types.str;
              default = "";
              description = ''
                GitLab API authentication endpoint.
                Only needed for other endpoints than gitlab.com.
              '';
            };
            clientID = mkOption {
              type = types.str;
              description = ''
                GitLab API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = ''
                GitLab API client secret.
              '';
            };
            scope = mkOption {
              type = types.enum [ "api" "read_user" ];
              default = "api";
              description = ''
                GitLab API requested scope.
                GitLab snippet import/export requires api scope.
              '';
            };
          };
        });
        default = null;
        description = "Configure the GitLab third-party integration.";
      };
      mattermost = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            baseURL = mkOption {
              type = types.str;
              description = ''
                Mattermost authentication endpoint.
              '';
            };
            clientID = mkOption {
              type = types.str;
              description = ''
                Mattermost API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = ''
                Mattermost API client secret.
              '';
            };
          };
        });
        default = null;
        description = "Configure the Mattermost third-party integration.";
      };
      dropbox = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            clientID = mkOption {
              type = types.str;
              description = ''
                Dropbox API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = ''
                Dropbox API client secret.
              '';
            };
            appKey = mkOption {
              type = types.str;
              description = ''
                Dropbox app key.
              '';
            };
          };
        });
        default = null;
        description = "Configure the Dropbox third-party integration.";
      };
      google = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            clientID = mkOption {
              type = types.str;
              description = ''
                Google API client ID.
              '';
            };
            clientSecret = mkOption {
              type = types.str;
              description = ''
                Google API client secret.
              '';
            };
          };
        });
        default = null;
        description = "Configure the Google third-party integration.";
      };
      ldap = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            providerName = mkOption {
              type = types.str;
              default = "";
              description = ''
                Optional name to be displayed at login form, indicating the LDAP provider.
              '';
            };
            url = mkOption {
              type = types.str;
              example = "ldap://localhost";
              description = ''
                URL of LDAP server.
              '';
            };
            bindDn = mkOption {
              type = types.str;
              description = ''
                Bind DN for LDAP access.
              '';
            };
            bindCredentials = mkOption {
              type = types.str;
              description = ''
                Bind credentials for LDAP access.
              '';
            };
            searchBase = mkOption {
              type = types.str;
              example = "o=users,dc=example,dc=com";
              description = ''
                LDAP directory to begin search from.
              '';
            };
            searchFilter = mkOption {
              type = types.str;
              example = "(uid={{username}})";
              description = ''
                LDAP filter to search with.
              '';
            };
            searchAttributes = mkOption {
              type = types.listOf types.str;
              example = [ "displayName" "mail" ];
              description = ''
                LDAP attributes to search with.
              '';
            };
            userNameField = mkOption {
              type = types.str;
              default = "";
              description = ''
                LDAP field which is used as the username on HedgeDoc.
                By default <option>useridField</option> is used.
              '';
            };
            useridField = mkOption {
              type = types.str;
              example = "uid";
              description = ''
                LDAP field which is a unique identifier for users on HedgeDoc.
              '';
            };
            tlsca = mkOption {
              type = types.str;
              example = "server-cert.pem,root.pem";
              description = ''
                Root CA for LDAP TLS in PEM format.
              '';
            };
          };
        });
        default = null;
        description = "Configure the LDAP integration.";
      };
      saml = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            idpSsoUrl = mkOption {
              type = types.str;
              example = "https://idp.example.com/sso";
              description = ''
                IdP authentication endpoint.
              '';
            };
            idpCert = mkOption {
              type = types.path;
              example = "/path/to/cert.pem";
              description = ''
                Path to IdP certificate file in PEM format.
              '';
            };
            issuer = mkOption {
              type = types.str;
              default = "";
              description = ''
                Optional identity of the service provider.
                This defaults to the server URL.
              '';
            };
            identifierFormat = mkOption {
              type = types.str;
              default = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress";
              description = ''
                Optional name identifier format.
              '';
            };
            groupAttribute = mkOption {
              type = types.str;
              default = "";
              example = "memberOf";
              description = ''
                Optional attribute name for group list.
              '';
            };
            externalGroups = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "Temporary-staff" "External-users" ];
              description = ''
                Excluded group names.
              '';
            };
            requiredGroups = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "Hedgedoc-Users" ];
              description = ''
                Required group names.
              '';
            };
            attribute = {
              id = mkOption {
                type = types.str;
                default = "";
                description = ''
                  Attribute map for `id'.
                  Defaults to `NameID' of SAML response.
                '';
              };
              username = mkOption {
                type = types.str;
                default = "";
                description = ''
                  Attribute map for `username'.
                  Defaults to `NameID' of SAML response.
                '';
              };
              email = mkOption {
                type = types.str;
                default = "";
                description = ''
                  Attribute map for `email'.
                  Defaults to `NameID' of SAML response if
                  <option>identifierFormat</option> has
                  the default value.
                '';
              };
            };
          };
        });
        default = null;
        description = "Configure the SAML integration.";
      };
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/var/lib/hedgedoc/hedgedoc.env";
      description = ''
        Environment file as defined in <citerefentry>
        <refentrytitle>systemd.exec</refentrytitle><manvolnum>5</manvolnum>
        </citerefentry>.

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
      description = ''
        Package that provides HedgeDoc.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.configuration.db == {} -> (
          cfg.configuration.dbURL != "" && cfg.configuration.dbURL != null
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
          -i ${prettyJSON cfg.configuration}
      '';
      serviceConfig = {
        WorkingDirectory = cfg.workDir;
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
