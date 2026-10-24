{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrNames
    elem
    filter
    filterAttrs
    flip
    getExe
    hasSuffix
    join
    lowerChars
    maintainers
    mapAttrs
    mapAttrs'
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkRenamedOptionModule
    nameValuePair
    pipe
    removeSuffix
    splitStringBy
    toList
    toUpper
    upperChars
    ;
  inherit (lib.generators) mkKeyValueDefault mkValueStringDefault;
  inherit (lib.types)
    attrsOf
    bool
    externalPath
    int
    listOf
    nullOr
    oneOf
    port
    str
    submodule
    ;

  cfg = config.services.qui;

  envName = flip pipe [
    (splitStringBy (prev: curr: elem prev lowerChars && elem curr upperChars) true)
    (map toUpper)
    (join "_")
    (s: "QUI__${s}")
  ];
  envValue = flip pipe [
    toList
    (map (mkValueStringDefault { }))
    (join ",")
  ];
  toEnvironment = mapAttrs' (n: v: nameValuePair (envName n) (envValue v));
  toCredentials = mapAttrsToList (mkKeyValueDefault { } ":");

  isSecretFile = hasSuffix "File";
  publicSettings = filterAttrs (n: _: !isSecretFile n) cfg.settings;
  secretSettings = filterAttrs (n: v: isSecretFile n && v != null) cfg.settings;
  secretPaths = mapAttrs (n: _: "%d/${n}") secretSettings;
in
{
  imports = [
    (mkRenamedOptionModule
      [ "services" "qui" "secretFile" ]
      [ "services" "qui" "settings" "sessionSecretFile" ]
    )
  ];

  options = {
    services.qui = {
      enable = mkEnableOption "qui";

      package = mkPackageOption pkgs "qui" { };

      user = mkOption {
        type = str;
        default = "qui";
        description = "User to run qui as.";
      };

      group = mkOption {
        type = str;
        default = "qui";
        example = "torrents";
        description = "Group to run qui as.";
      };

      openFirewall = mkOption {
        type = bool;
        default = false;
        description = "Whether to open ports in the firewall for qui.";
      };

      settings = mkOption {
        default = { };
        example = {
          port = 7777;
          logLevel = "DEBUG";
          metricsEnabled = true;
        };
        type = submodule {
          freeformType = attrsOf (oneOf [
            bool
            int
            str
            (listOf str)
          ]);
          options = {
            host = mkOption {
              type = str;
              default = "127.0.0.1";
              description = "The host address qui listens on.";
            };

            port = mkOption {
              type = port;
              default = 7476;
              description = "The port qui listens on.";
            };

            databaseDsnFile = mkOption {
              type = nullOr externalPath;
              default = null;
              example = "/run/secrets/qui/database-dsn";
              description = ''
                Path to a file containing the PostgreSQL connection string (DSN),
                used when `databaseEngine` is set to `postgres`.
                Takes precedence over the individual database host, user, and password settings.
              '';
            };

            databasePasswordFile = mkOption {
              type = nullOr externalPath;
              default = null;
              example = "/run/secrets/qui/database-password";
              description = ''
                Path to a file containing the PostgreSQL password,
                used when `databaseEngine` is set to `postgres` and no DSN is provided.
              '';
            };

            oidcClientSecretFile = mkOption {
              type = nullOr externalPath;
              default = null;
              example = "/run/secrets/qui/oidc-client-secret";
              description = ''
                Path to a file containing the OIDC client secret from your identity provider,
                used when `oidcEnabled` is `true`.
              '';
            };

            sessionSecretFile = mkOption {
              type = nullOr externalPath;
              default = null;
              example = "/run/secrets/qui/session-secret";
              description = ''
                Path to a file containing the session secret,
                used to encrypt stored qBittorrent instance credentials.
                Can be generated with `openssl rand -hex 32`.
                When `null`, qui generates and persists its own secret.
              '';
            };
          };
        };
        description = ''
          Configuration for qui.

          Settings use camelCase and are mapped to qui's corresponding `QUI__*`
          [environment variables](https://getqui.com/docs/configuration/environment/).
          The environment variables are not set directly,
          to stay backwards compatible with existing configurations.
          Any setting with a corresponding environment variable can be set here.

          Secret settings (`databaseDsn`, `databasePassword`, `oidcClientSecret`, `sessionSecret`)
          must instead be supplied as a path by adding the `File` suffix, e.g. `sessionSecretFile`.
          These `File` settings are passed to the service through systemd `LoadCredential=`,
          keeping the secret out of the world-readable Nix store.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = pipe cfg.settings [
      attrNames
      (filter isSecretFile)
      (map (
        secretFile:
        let
          secret = removeSuffix "File" secretFile;
        in
        {
          assertion = !cfg.settings ? ${secret};
          message = ''
            `services.qui.settings.${secret}` must not be set,
            as it is written to the world-readable Nix store.
            Use `services.qui.settings.${secretFile}` instead.
          '';
        }
      ))
    ];

    systemd.services.qui = {
      description = "qui: alternative qBittorrent webUI";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = toEnvironment (publicSettings // secretPaths);
      serviceConfig = {
        Type = "exec";
        User = cfg.user;
        Group = cfg.group;
        LoadCredential = toCredentials secretSettings;
        StateDirectory = "%N";
        StateDirectoryMode = "0700";
        ExecStartPre = "${getExe cfg.package} generate-config --config-dir %S/%N";
        ExecStart = "${getExe cfg.package} serve --config-dir %S/%N";
        Restart = "on-failure";
        # Based on qBittorrent and nemorosa hardening settings
        # Similar to what systemd hardening helper suggests
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateNetwork = false;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = "yes";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        # This should allow hardlinking to torrent client files
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.settings.port ]; };

    users = {
      users = mkIf (cfg.user == "qui") {
        qui = {
          inherit (cfg) group;
          description = "qui user";
          isSystemUser = true;
        };
      };

      groups = mkIf (cfg.group == "qui") { qui = { }; };
    };
  };

  meta.maintainers = with maintainers; [
    connor-grady
    undefined-landmark
  ];
}
