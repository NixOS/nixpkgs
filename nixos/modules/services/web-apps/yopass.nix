{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.yopass;

  stateDirectory = "/var/lib/yopass";

  # yopass-server has no config file: every flag is read from an
  # environment variable of the same name (upstream
  # docs/server-options.md). List-valued flags such as TRUSTED_PROXIES
  # are parsed as comma-separated strings.
  toEnvValue =
    v:
    if lib.isBool v then
      lib.boolToString v
    else if lib.isList v then
      lib.concatMapStringsSep "," toString v
    else
      toString v;
in
{
  options.services.yopass = {
    enable = lib.mkEnableOption "Yopass, a secure way to share secrets and files";

    package = lib.mkPackageOption pkgs "yopass" { };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/yopass";
      description = ''
        Path to a file in systemd `EnvironmentFile` format, for
        settings that shouldn't land in the Nix store: `API_TOKEN`,
        `WEBHOOK_SECRET`, `LICENSE_KEY`, `OIDC_CLIENT_SECRET`,
        `OIDC_SESSION_KEY`.
      '';
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          bool
          int
          str
          (listOf str)
        ]);
      default = { };
      example = {
        PORT = 8080;
        DATABASE = "redis";
        REDIS = "redis://127.0.0.1:6379/0";
        MAX_FILE_SIZE = "10MB";
        TRUSTED_PROXIES = [
          "192.168.1.0/24"
          "10.0.0.0/8"
        ];
      };
      description = ''
        yopass-server settings, passed as environment variables. Every
        flag in [the upstream documentation](https://github.com/jhaals/yopass/blob/master/docs/server-options.md)
        has an environment variable form (`--oidc-issuer` is
        `OIDC_ISSUER`); use that name as the attribute. Booleans become
        `true`/`false`, numbers are stringified and lists are joined
        with commas. Anything left unset keeps yopass-server's own
        default, except that the module binds `ADDRESS` to `127.0.0.1`
        (expecting a reverse proxy in front) and points
        `FILE_STORE_PATH` at `/var/lib/yopass/files` so uploads survive
        restarts; both can be overridden here.

        A `FILE_STORE_PATH` outside `/var/lib/yopass` is allow-listed
        for writing automatically, but it must already exist and be
        writable by the service, which runs as a dynamic user.

        The module doesn't own the storage backend. With `DATABASE =
        "redis"` pointing at a local `services.redis.servers.<name>`,
        add `systemd.services.yopass.after = [ "redis-<name>.service" ];`
        yourself to avoid a startup race; the memcached unit name is
        fixed, so that ordering is handled for you.

        Secrets belong in {option}`services.yopass.environmentFile`
        rather than here, since this ends up in the Nix store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.yopass.settings = {
      ADDRESS = lib.mkDefault "127.0.0.1";
      # Upstream defaults to /tmp/yopass-files, which lands on the unit's
      # PrivateTmp and is wiped on every restart.
      FILE_STORE_PATH = lib.mkDefault "${stateDirectory}/files";
    };

    systemd.services.yopass = {
      description = "Yopass - Share secrets securely";
      documentation = [ "https://github.com/jhaals/yopass" ];
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ]
      ++ lib.optional ((cfg.settings.DATABASE or "memcached") == "memcached") "memcached.service";

      environment = lib.mapAttrs (_: toEnvValue) cfg.settings;

      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "yopass-server";
        DynamicUser = true;
        Restart = "on-failure";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = baseNameOf stateDirectory;
        # StateDirectory is writable already; anything else needs
        # allow-listing under ProtectSystem=strict.
        ReadWritePaths = lib.optional (
          !lib.hasPrefix "${stateDirectory}/" cfg.settings.FILE_STORE_PATH
        ) cfg.settings.FILE_STORE_PATH;

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @setuid @keyring"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ fraggerfox ];
}
