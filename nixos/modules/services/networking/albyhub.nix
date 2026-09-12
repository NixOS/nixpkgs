{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.albyhub;

  albyhubSystemdSandbox = {
    PrivateTmp = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
    RestrictNamespaces = true;
    LockPersonality = true;
    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    CapabilityBoundingSet = "";
    SystemCallArchitectures = "native";
  };

  rootScript = name: text: "+${pkgs.writeShellScript name text}";

  envFileContent = ''
    WORK_DIR=${cfg.dataDir}
    DATABASE_URI=${cfg.dataDir}/nwc.db
    PORT=${toString cfg.port}
    LOG_LEVEL=${toString cfg.logLevel}
    AUTO_LINK_ALBY_ACCOUNT=${boolToString cfg.autoLinkAlbyAccount}
    ${optionalString (cfg.logToFile != null) "LOG_TO_FILE=${boolToString cfg.logToFile}"}
    ${optionalString (cfg.logDBQueries != null) "LOG_DB_QUERIES=${boolToString cfg.logDBQueries}"}
    ${optionalString (cfg.network != null) "NETWORK=${cfg.network}"}
    ${optionalString (cfg.mempoolApi != null) "MEMPOOL_API=${cfg.mempoolApi}"}
    ${optionalString (cfg.albyOAuth.clientId != null) "ALBY_OAUTH_CLIENT_ID=${cfg.albyOAuth.clientId}"}
    ${optionalString (cfg.baseUrl != null) "BASE_URL=${cfg.baseUrl}"}
    ${optionalString (cfg.frontendUrl != null) "FRONTEND_URL=${cfg.frontendUrl}"}
    ${optionalString (cfg.logEvents != null) "LOG_EVENTS=${boolToString cfg.logEvents}"}
    ${optionalString (cfg.relay != null) "RELAY=${cfg.relay}"}
    ${optionalString (cfg.boltzApi != null) "BOLTZ_API=${cfg.boltzApi}"}
    ${optionalString (cfg.extraConfig != null) cfg.extraConfig}
  '';

  envFile = "${cfg.dataDir}/.env";

in
{
  options.services.albyhub = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Alby Hub, a service to control lightning wallets over nostr.
        See the user guide at https://guides.getalby.com/user-guide/alby-hub.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.albyhub;
      defaultText = literalExpression "pkgs.albyhub";
      description = "The Alby Hub package to use.";
    };

    user = mkOption {
      type = types.str;
      default = "albyhub";
      description = "User account under which Alby Hub runs.";
    };

    group = mkOption {
      type = types.str;
      default = cfg.user;
      defaultText = literalExpression "config.services.albyhub.user";
      description = "Group account under which Alby Hub runs.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/albyhub";
      description = "Directory where Alby Hub stores its state.";
    };

    port = mkOption {
      type = types.port;
      default = 8082;
      description = "Port on which Alby Hub listens.";
    };

    relay = mkOption {
      type = with types; nullOr (listOf str);
      example = [
        "wss://relay.damus.io"
        "wss://offchain.pub"
        "wss://relay.primal.net"
      ];
      default = null;
      apply = value: if builtins.isList value then concatStringsSep "," value else value;
      description = "The nostr relays to use. Find more relays: https://nostrwat.ch/";
    };

    logLevel = mkOption {
      type = types.int;
      default = 4;
      description = "Log level for the application. Higher is more verbose.";
    };

    logToFile = mkOption {
      type = with types; nullOr bool;
      default = null;
      description = "Log to file.";
    };

    logDBQueries = mkOption {
      type = with types; nullOr bool;
      default = null;
      description = "Log database queries.";
    };

    network = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "The network to use (e.g. mainnet, testnet, regtest).";
      example = "signet";
    };

    mempoolApi = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "Mempool API endpoint.";
      example = "https://mempool.space/api";
    };

    baseUrl = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Public base URL of your Alby Hub backend (used as `BASE_URL`).
        This must be reachable by the browser and is required when using a custom Alby OAuth client,
        because the OAuth callback is ''${baseUrl}/api/alby/callback.
      '';
      example = "http://localhost:8082";
    };

    frontendUrl = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Public URL of the Hub frontend UI used for browser redirects (for example after OAuth or logout).
        If unset, redirects fall back to `baseUrl`.
      '';
    };

    logEvents = mkOption {
      type = with types; nullOr bool;
      default = null;
      description = "Log events.";
    };

    autoLinkAlbyAccount = mkOption {
      type = types.bool;
      default = false;
      description = "Auto link Alby account.";
    };

    boltzApi = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "wss://api.boltz.exchange/";
      description = "Boltz API endpoint.";
    };

    extraConfig = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "Extra configuration options appended to the environment file.";
    };

    autoUnlockPasswordFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Path to a file containing the password to auto-unlock Alby Hub on startup.
        Password will still be required to access the interface.
        Setting this option is insecure. The password file will be world-readable
        in the Nix store.
      '';
    };

    jwtSecretFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Path to a file containing the JWT secret.
        Setting this option is insecure. The secret file will be world-readable
        in the Nix store.
      '';
    };

    albyOAuth = {
      clientId = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Alby OAuth Client ID.";
      };
      clientSecretFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = "Path to a file containing the Alby OAuth client secret.";
      };
    };

  };

  config = mkIf cfg.enable {

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };
    users.groups.${cfg.group} = { };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0770 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.albyhub = {
      description = mkDefault "Alby Hub";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = albyhubSystemdSandbox // {
        # Build `${envFile}` at service start so dynamic values and secrets are resolved at runtime,
        # rather than being baked into the Nix-evaluated config. This hook also handles privileged
        # setup (for example copying LND macaroon and fixing ownership/permissions) before dropping to `${cfg.user}`.
        ExecStartPre =
          let
            catSecret = secret: optionalString (secret != null) "cat ${secret}";
            appendToFile =
              key: secret:
              optionalString (secret != null) ''
                echo -n '${key}=' >> ${envFile}
                ${catSecret secret} >> ${envFile}
                echo >> ${envFile}
              '';
          in
          [
            (rootScript "albyhub-setup" ''
              cat > ${envFile} <<EOF
              ${envFileContent}
              EOF
              ${appendToFile "AUTO_UNLOCK_PASSWORD" cfg.autoUnlockPasswordFile}
              ${optionalString (cfg.jwtSecretFile != null) (appendToFile "JWT_SECRET" cfg.jwtSecretFile)}
              ${optionalString (cfg.albyOAuth.clientSecretFile != null) (
                appendToFile "ALBY_OAUTH_CLIENT_SECRET" cfg.albyOAuth.clientSecretFile
              )}

              chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
              chmod 600 ${envFile}
            '')
          ];

        User = cfg.user;
        Group = cfg.group;
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = "-${envFile}";
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        RestartSec = "10s";
        ReadWritePaths = [ cfg.dataDir ];
      };

    };

  };
}
