{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.services.vikunja;
  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "vikunja" "setupNginx" ]
      "services.vikunja no longer supports the automatic set up of a nginx virtual host. Set up your own webserver config with a proxy pass to the vikunja service."
    )
  ];

  options.services.vikunja = with lib; {
    auth = {
      local = {
        # Note that this is 'enabled' not 'enable' because it's writing the
        # Vikunja config directly rather than translating from NixOS standard (enable)
        # to Vikunja config (enabled)
        enabled = mkEnableOption "local auth";
      };
      openid = {
        # Note that this is 'enabled' not 'enable' because it's writing the
        # Vikunja config directly rather than translating from NixOS standard (enable)
        # to Vikunja config (enabled)
        enabled = mkEnableOption "openid auth";
        providers = mkOption {
          type = with types; listOf (submodule {
            options = {
              authurl = mkOption {
                type = str;
                description = "The auth url to send users to if they want to authenticate using OpenID Connect.";
              };
              clientid = mkOption {
                type = str;
                description = "The clientID";
              };
              clientsecret = mkOption {
                type = str;
                description = "The client secret";
              };
              name = mkOption {
                type = str;
                description = "the display name";
              };
            };
          });
        };
      };
    };
    enable = mkEnableOption "vikunja service";
    package = mkPackageOption pkgs "vikunja" { };
    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        List of environment files set in the vikunja systemd service.
        For example passwords should be set in one of these files.
      '';
    };
    frontendScheme = mkOption {
      type = types.enum [
        "http"
        "https"
      ];
      description = ''
        Whether the site is available via http or https.
      '';
    };
    frontendHostname = mkOption {
      type = types.str;
      description = "The Hostname under which the frontend is running.";
    };
    port = mkOption {
      type = types.port;
      default = 3456;
      description = "The TCP port exposed by the API.";
    };

    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        Vikunja configuration. Refer to
        <https://vikunja.io/docs/config-options/>
        for details on supported values.
      '';
    };
    database = {
      database = mkOption {
        type = types.str;
        default = "vikunja";
        description = "Database name.";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Database host address. Can also be a socket.";
      };
      password = mkOption {
        type = types.str;
        default = "";
        description = "The password to use when connecting to the database.";
      };
      path = mkOption {
        type = types.str;
        default = "/var/lib/vikunja/vikunja.db";
        description = "Path to the sqlite3 database file.";
      };
      sslmode = mkOption {
        default = "require";
        description = "Postres-only, SSL mode";
        example = "require";
        type = types.enum [
          "disable"
          "require"
          "verify-full"
          "verify-ca"
        ];
      };
      type = mkOption {
        type = types.enum [
          "sqlite"
          "mysql"
          "postgres"
        ];
        example = "postgres";
        default = "sqlite";
        description = "Database engine to use.";
      };
      user = mkOption {
        type = types.str;
        default = "vikunja";
        description = "Database user.";
      };
    };
    mailer = {
      authtype = mkOption {
        type = types.enum [
          "cram-md5"
          "login"
          "plain"
        ];
        example = "login";
        default = "plain";
        description = "SMTP auth type.";
      };
      # Note that this is 'enabled' not 'enable' because it's writing the
      # Vikunja config directly rather than translating from NixOS standard (enable)
      # to Vikunja config (enabled)
      enabled = mkEnableOption "vikunja service";
      fromemail = mkOption {
        type = types.str;
        description = "The from address for sending email";
      };
      forcessl = mkEnableOption "By default Vikunja uses starttls, this option forces ssl instead.";
      host = mkOption {
        type = types.str;
        description = "The SMTP host for sending email";
      };
      password = mkOption {
        type = types.str;
        description = "The SMTP password";
      };
      port = mkOption {
        type = types.int;
        default = 587;
        description = "The SMTP port to communicate with the host";
      };
      queuelength = mkOption {
        type = types.int;
        default = 100;
        description = "The length of the mail queue";
      };
      queuetimeout = mkOption {
        type = types.int;
        default = 30;
        description = "The timeout in seconds after which the current open connection to the mailserver will be closed";
      };
      skiptlsverify = mkEnableOption "skip TLS verification";
      username = mkOption {
        type = types.str;
        description = "The SMTP username";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.vikunja.settings = {
      auth = {
        inherit (cfg.auth)
          local
          openid
          ;
      };
      database = {
        inherit (cfg.database)
          database
          host
          type
          path
          password
          sslmode
          user
          ;
      };
      files = {
        basepath = "/var/lib/vikunja/files";
      };
      mailer = {
        inherit (cfg.mailer)
          authtype
          enabled
          fromemail
          forcessl
          host
          password
          port
          queuelength
          queuetimeout
          skiptlsverify
          username
          ;
      };
      service = {
        interface = ":${toString cfg.port}";
        frontendurl = "${cfg.frontendScheme}://${cfg.frontendHostname}/";
      };
    };

    systemd.services.vikunja = {
      description = "vikunja";
      after =
        [ "network.target" ]
        ++ lib.optional usePostgresql "postgresql.service"
        ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      restartTriggers = [ configFile ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "vikunja";
        ExecStart = "${cfg.package}/bin/vikunja";
        Restart = "always";
        EnvironmentFile = cfg.environmentFiles;
      };
    };

    environment.etc."vikunja/config.yaml".source = configFile;

    environment.systemPackages = [
      cfg.package # for admin `vikunja` CLI
    ];
  };
}
