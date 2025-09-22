{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.hydroxide;
in
{
  options.services.hydroxide =
    let
      inherit (lib)
        mkOption
        mkEnableOption
        mkPackageOption
        types
        ;
      pathNotInStore = types.pathWith {
        absolute = true;
        inStore = false;
      };
    in
    {
      enable = mkEnableOption "hydroxide service";
      package = mkPackageOption pkgs "hydroxide" { };

      debug = mkEnableOption "debug logs";

      authfile = mkOption {
        type = types.nullOr pathNotInStore;
        default = null;
        description = ''
          Path to auth.json file.

          Optional. Please note that this would overwrite any logins configured manually using the auth subcommand.

          Do NOT use a path from the nix store here!
        '';
      };

      api-endpoint = mkOption {
        type = types.str;
        default = "https://mail.proton.me/api";
        description = ''
          ProtonMail API endpoint.
        '';
      };
      app-version = mkOption {
        type = types.str;
        default = "Other";
        description = ''
          ProtonMail application version.
        '';
      };

      smtp = {
        enable = mkEnableOption "SMTP for hydroxide serve" // {
          default = true;
        };
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Allowed SMTP email hostname on which hydroxide listens";
        };
        port = mkOption {
          type = types.int;
          default = 1025;
          description = "SMTP port on which hydroxide listens";
        };
      };

      imap = {
        enable = mkEnableOption "IMAP for hydroxide serve" // {
          default = true;
        };
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Allowed IMAP email hostname on which hydroxide listens";
        };
        port = mkOption {
          type = types.int;
          default = 1143;
          description = "IMAP port on which hydroxide listens";
        };
      };

      carddav = {
        enable = lib.mkEnableOption "CardDAV for hydroxide serve" // {
          default = true;
        };
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Allowed CardDAV hostname on which hydroxide listens";
        };
        port = mkOption {
          type = types.int;
          default = 8080;
          description = "CardDAV port on which hydroxide listens";
        };
      };

      tls = {
        cert = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/path/to/cert.pem";
          description = ''
            Path to the certificate to use for incoming connections (Optional)
          '';
        };
        key = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/path/to/key.pem";
          description = ''
            Path to the certificate key to use for incoming connections (Optional)
          '';
        };
        client-ca = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/path/to/ca.pem";
          description = ''
            If set, clients must provide a certificate signed by the given CA (Optional)
          '';
        };
      };
    };

  config = lib.mkIf cfg.enable {
    systemd.services.hydroxide = {
      description = "third-party, open-source ProtonMail bridge";

      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" ];
      after = [ "network.target" ];
      restartTriggers = [
        cfg.authfile
      ];

      script =
        let
          mkGlobalArgs =
            args:
            lib.concatStringsSep " " (
              lib.mapAttrsToList (
                key: value:
                if lib.typeOf value == "bool" then
                  "-${key}"
                else
                  "-${key}=\"${lib.escapeShellArg (builtins.toString value)}\""
              ) (lib.filterAttrs (_: value: (value != null) && (value != false)) args)
            );

          globalArgs = mkGlobalArgs {
            inherit (cfg) debug api-endpoint app-version;

            disable-smtp = !cfg.smtp.enable;
            disable-imap = !cfg.imap.enable;
            disable-carddav = !cfg.carddav.enable;

            tls-cert = cfg.tls.cert;
            tls-key = cfg.tls.key;
            tls-client-ca = cfg.tls.client-ca;

            smtp-host = cfg.smtp.host;
            smtp-port = cfg.smtp.port;

            imap-host = cfg.imap.host;
            imap-port = cfg.imap.port;

            carddav-host = cfg.carddav.host;
            carddav-port = cfg.carddav.port;
          };
        in
        ''
          ${lib.optionalString (cfg.authfile != null) ''
            ln -sfn "$CREDENTIALS_DIRECTORY/auth" $STATE_DIRECTORY/auth.json
          ''}
          export XDG_CONFIG_HOME="$STATE_DIRECTORY/.."
          ${lib.getExe cfg.package} ${globalArgs} serve
        '';

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "hydroxide";

        Restart = "on-failure";
        RestartSec = 5;

        LoadCredential = if cfg.authfile != null then "auth:${cfg.authfile}" else null;

        # hardening
        KeyringMode = "private";
        MemoryDenyWriteExecute = true;
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        LockPersonality = true;
        SystemCallArchitectures = "native";
        LimitNOFILE = 65536;
      };
    };

    # XXX: maybe wrap so it manages global StateDirectory instead of user's?
    # so that e.g. manual hydroxide auth ... command would just work (tm)
    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [
    griffi-gh
  ];
}
