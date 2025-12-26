{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.dex;
  fixClient =
    client:
    if client ? secretFile then
      (
        (builtins.removeAttrs client [ "secretFile" ])
        // {
          secret = client.secretFile;
        }
      )
    else
      client;
  filteredSettings = mapAttrs (
    n: v: if n == "staticClients" then (builtins.map fixClient v) else v
  ) cfg.settings;
  secretFiles = flatten (
    builtins.map (c: optional (c ? secretFile) c.secretFile) (cfg.settings.staticClients or [ ])
  );

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" filteredSettings;

  startPreScript = pkgs.writeShellScript "dex-start-pre" (
    concatStringsSep "\n" (
      map (file: ''
        replace-secret '${file}' '${file}' /run/dex/config.yaml
      '') secretFiles
    )
  );

  restartTriggers =
    [ ]
    ++ (optionals (cfg.environmentFile != null) [ cfg.environmentFile ])
    ++ (filter (file: builtins.typeOf file == "path") secretFiles);
in
{
  options.services.dex = {
    enable = mkEnableOption "the OpenID Connect and OAuth2 identity provider";

    package = mkPackageOption pkgs "dex-oidc" { };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Environment file (see {manpage}`systemd.exec(5)`
        "EnvironmentFile=" section for the syntax) to define variables for dex.
        This option can be used to safely include secret keys into the dex configuration.
      '';
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
      example = literalExpression ''
        {
          # External url
          issuer = "http://127.0.0.1:5556/dex";
          storage = {
            type = "postgres";
            config.host = "/var/run/postgres";
          };
          web = {
            http = "127.0.0.1:5556";
          };
          enablePasswordDB = true;
          staticClients = [
            {
              id = "oidcclient";
              name = "Client";
              redirectURIs = [ "https://example.com/callback" ];
              secretFile = "/etc/dex/oidcclient"; # The content of `secretFile` will be written into to the config as `secret`.
            }
          ];
        }
      '';
      description = ''
        The available options can be found in
        [the example configuration](https://github.com/dexidp/dex/blob/v${cfg.package.version}/config.yaml.dist).

        It's also possible to refer to environment variables (defined in [services.dex.environmentFile](#opt-services.dex.environmentFile))
        using the syntax `$VARIABLE_NAME`.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.dex = {
      description = "dex identity provider";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ]
      ++ (optional (cfg.settings.storage.type == "postgres") "postgresql.target");
      path = with pkgs; [ replace-secret ];
      restartTriggers = restartTriggers;
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/dex serve /run/dex/config.yaml";
        ExecStartPre = [
          "${pkgs.coreutils}/bin/install -m 600 ${configFile} /run/dex/config.yaml"
          "+${startPreScript}"
        ];

        RuntimeDirectory = "dex";
        BindReadOnlyPaths = [
          "/nix/store"
          "-/etc/dex"
          "-/etc/hosts"
          "-/etc/localtime"
          "-/etc/nsswitch.conf"
          "-/etc/resolv.conf"
          "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt"
        ];
        BindPaths = optional (cfg.settings.storage.type == "postgres") "/var/run/postgresql";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        # Port needs to be exposed to the host network
        #PrivateNetwork = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectSystem = "strict";
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @setuid @keyring"
        ];
        UMask = "0066";
      }
      // optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = cfg.environmentFile;
      };
    };
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
