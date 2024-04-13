{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types mdDoc literalExpression;

  cfg = config.services.hedgedoc;

  # 21.03 will not be an official release - it was instead 21.05.  This
  # versionAtLeast statement remains set to 21.03 for backwards compatibility.
  # See https://github.com/NixOS/nixpkgs/pull/108899 and
  # https://github.com/NixOS/rfcs/blob/master/rfcs/0080-nixos-release-schedule.md.
  name = if lib.versionAtLeast config.system.stateVersion "21.03" then
    "hedgedoc"
  else
    "codimd";

  settingsFormat = pkgs.formats.jsonWithRuntimeSubstitution { };
in
{
  meta.maintainers = with lib.maintainers; [ SuperSandro2000 h7x4 ];

  imports = [
    (lib.mkRenamedOptionModule [ "services" "codimd" ] [ "services" "hedgedoc" ])
    (lib.mkRenamedOptionModule [ "services" "hedgedoc" "configuration" ] [ "services" "hedgedoc" "settings" ])
    (lib.mkRenamedOptionModule [ "services" "hedgedoc" "groups" ] [ "users" "users" "hedgedoc" "extraGroups" ])
    (lib.mkRemovedOptionModule [ "services" "hedgedoc" "workDir" ] ''
      This option has been removed in favor of systemd managing the state directory.

      If you have set this option without specifying `services.settings.uploadsDir`,
      please move these files to `/var/lib/hedgedoc/uploads`, or set the option to point
      at the correct location.
    '')
    (lib.mkRemovedOptionModule [ "services" "hedgedoc" "environmentFile" ] ''
      This option and the module's envsubst behaviour have been
      removed in favour of a more robust secret injection mechanism.

      You can now use systemd credentials or define settings to be loaded from files at runtime as follows:
      ```
      systemd.services.hedgedoc.serviceConfig.LoadCredential = "oauth-client-secret:/run/secrets/hedgedoc-oauth-client-secret";
      services.hedgedoc.settings.oauth2.clientSecret = lib.stringFromSystemdCredential "oauth-client-secret";
      services.hedgedoc.settings.db.password = lib.stringFromRuntimeFile "/run/secrets/hedgedoc-db-password";
      ```

      Note that if using files, the permissions of the file must allow
      the hedgedoc user to read it.
    '')
  ];

  options.services.hedgedoc = {
    package = lib.mkPackageOption pkgs "hedgedoc" { };
    enable = lib.mkEnableOption (mdDoc "the HedgeDoc Markdown Editor");

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          domain = mkOption {
            type = with types; nullOr str;
            default = null;
            example = "hedgedoc.org";
            description = mdDoc ''
              Domain to use for website.

              This is useful if you are trying to run hedgedoc behind
              a reverse proxy.
            '';
          };
          urlPath = mkOption {
            type = with types; nullOr str;
            default = null;
            example = "hedgedoc";
            description = mdDoc ''
              URL path for the website.

              This is useful if you are hosting hedgedoc on a path like
              `www.example.com/hedgedoc`
            '';
          };
          host = mkOption {
            type = with types; nullOr str;
            default = "localhost";
            description = mdDoc ''
              Address to listen on.
            '';
          };
          port = mkOption {
            type = types.port;
            default = 3000;
            example = 80;
            description = mdDoc ''
              Port to listen on.
            '';
          };
          path = mkOption {
            type = with types; nullOr path;
            default = null;
            example = "/run/hedgedoc/hedgedoc.sock";
            description = mdDoc ''
              Path to UNIX domain socket to listen on

              ::: {.note}
                If specified, {option}`host` and {option}`port` will be ignored.
              :::
            '';
          };
          protocolUseSSL = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = mdDoc ''
              Use `https://` for all links.

              This is useful if you are trying to run hedgedoc behind
              a reverse proxy.

              ::: {.note}
                Only applied if {option}`domain` is set.
              :::
            '';
          };
          allowOrigin = mkOption {
            type = with types; listOf str;
            default = with cfg.settings; [ host ] ++ lib.optionals (domain != null) [ domain ];
            defaultText = literalExpression ''
              with config.services.hedgedoc.settings; [ host ] ++ lib.optionals (domain != null) [ domain ]
            '';
            example = [ "localhost" "hedgedoc.org" ];
            description = mdDoc ''
              List of domains to whitelist.
            '';
          };
          db = mkOption {
            type = types.attrs;
            default = {
              dialect = "sqlite";
              storage = "/var/lib/${name}/db.sqlite";
            };
            defaultText = literalExpression ''
              {
                dialect = "sqlite";
                storage = "/var/lib/hedgedoc/db.sqlite";
              }
            '';
            example = literalExpression ''
              db = {
                username = "hedgedoc";
                database = "hedgedoc";
                host = "localhost:5432";
                # or via socket
                # host = "/run/postgresql";
                dialect = "postgresql";
              };
            '';
            description = mdDoc ''
              Specify the configuration for sequelize.
              HedgeDoc supports `mysql`, `postgres`, `sqlite` and `mssql`.
              See <https://sequelize.readthedocs.io/en/v3/>
              for more information.

              ::: {.note}
                The relevant parts will be overriden if you set {option}`dbURL`.
              :::
            '';
          };
          useSSL = mkOption {
            type = types.bool;
            default = false;
            description = mdDoc ''
              Enable to use SSL server.

              ::: {.note}
                This will also enable {option}`protocolUseSSL`.

                It will also require you to set the following:

                - {option}`sslKeyPath`
                - {option}`sslCertPath`
                - {option}`sslCAPath`
                - {option}`dhParamPath`
              :::
            '';
          };
          uploadsPath = mkOption {
            type = types.path;
            default = "/var/lib/${name}/uploads";
            defaultText = "/var/lib/hedgedoc/uploads";
            description = mdDoc ''
              Directory for storing uploaded images.
            '';
          };

          # Declared because we change the default to false.
          allowGravatar = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = mdDoc ''
              Whether to enable [Libravatar](https://wiki.libravatar.org/) as
              profile picture source on your instance.

              Despite the naming of the setting, Hedgedoc replaced Gravatar
              with Libravatar in [CodiMD 1.4.0](https://hedgedoc.org/releases/1.4.0/)
            '';
          };
        };
      };

      description = mdDoc ''
        HedgeDoc configuration, see
        <https://docs.hedgedoc.org/configuration/>
        for documentation.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${name} = { };
    users.users.${name} = {
      description = "HedgeDoc service user";
      group = name;
      isSystemUser = true;
    };

    services.hedgedoc.settings = {
      defaultNotePath = lib.mkDefault "${cfg.package}/share/hedgedoc/public/default.md";
      docsPath = lib.mkDefault "${cfg.package}/share/hedgedoc/public/docs";
      viewPath = lib.mkDefault "${cfg.package}/share/hedgedoc/public/views";
    };

    systemd.services.hedgedoc = {
      description = "HedgeDoc Service";
      documentation = [ "https://docs.hedgedoc.org/" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      preStart =
        let
          configGenerator = settingsFormat.generate "hedgedoc-config.json" {
            production = cfg.settings;
          };
        in
        ''
          ${configGenerator} > /run/${name}/config.json
          ${pkgs.coreutils}/bin/mkdir -p ${cfg.settings.uploadsPath}
        '';
      serviceConfig = {
        User = name;
        Group = name;

        Restart = "always";
        ExecStart = lib.getExe cfg.package;
        RuntimeDirectory = [ name ];
        StateDirectory = [ name ];
        WorkingDirectory = "/run/${name}";
        ReadWritePaths = [
          "-${cfg.settings.uploadsPath}"
        ] ++ lib.optionals (cfg.settings.db ? "storage") [ "-${cfg.settings.db.storage}" ];
        Environment = [
          "CMD_CONFIG_FILE=/run/${name}/config.json"
          "NODE_ENV=production"
        ];

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          # Required for connecting to database sockets,
          # and listening to unix socket at `cfg.settings.path`
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindAllow = lib.mkIf (cfg.settings.path == null) cfg.settings.port;
        SocketBindDeny = "any";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @obsolete"
          "@pkey"
        ];
        UMask = "0007";
      };
    };
  };
}
