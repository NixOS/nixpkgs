{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.terraform-backend;

  # `null` when `LISTEN_ADDR` has no numeric port. An assertion reports that; this must
  # not throw, because the firewall option is evaluated before assertions are.
  listenPort =
    let
      groups = builtins.match ".*:([0-9]+)" cfg.settings.LISTEN_ADDR;
    in
    if groups == null then null else lib.toInt (lib.head groups);

  # The `local` lock backend is an in-process mutex, so it cannot exclude a second
  # instance. Shared storage plus a second instance corrupts state.
  sharedStorage = (cfg.settings.STORAGE_BACKEND or "fs") != "fs";
in
{
  options.services.terraform-backend = {
    enable = lib.mkEnableOption "terraform-backend, a Terraform/OpenTofu HTTP state backend" // {
      description = ''
        Whether to enable terraform-backend, a Terraform/OpenTofu HTTP state backend.

        Terraform state is a high-value target. It maps the infrastructure, and it
        frequently holds credentials in plain text. Do not make this service available to
        an untrusted network. The `basic` authentication backend does not authenticate
        anybody, and the service has no protection against a client that sends a very
        large request body before it authenticates.
      '';
    };

    package = lib.mkPackageOption pkgs "terraform-backend" { };

    kmsKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/terraform-backend-kms-key";
      description = ''
        Path to the key used by the `local` KMS backend to encrypt state at rest.

        The file must contain the base64 encoding of 16, 24 or 32 raw bytes, with no
        trailing newline, as produced by `openssl rand -base64 32 | tr -d '\n'`.

        Give a path that is outside the Nix store, such as a file from a secret manager.
        A path literal such as `./kms-key` copies the key into the world-readable store.

        The key cannot be rotated. The `local` KMS backend stores no key id with the
        ciphertext, so a new key makes every stored state undecryptable.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/terraform-backend.env";
      description = ''
        Path of a file with additional environment variables, as defined in
        {manpage}`systemd.exec(5)`.

        This file is not added to the Nix store, so it is the place for the remaining
        secrets, such as {env}`STORAGE_S3_SECRET_KEY`, {env}`POSTGRES_CONNECTION`,
        {env}`REDIS_PASSWORD` and {env}`VAULT_TOKEN`.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Open the port of [](#opt-services.terraform-backend.settings) `LISTEN_ADDR` in
        the firewall.

        The port of `METRICS_LISTEN_ADDR` stays closed. When the two addresses are equal,
        the main listener serves `/metrics` too, and this option makes the metrics
        available as well.

        Clients send the state and the password in plain text unless `TLS_CERT` and
        `TLS_KEY` are set.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.nullOr (
            lib.types.oneOf [
              lib.types.bool
              lib.types.int
              lib.types.str
            ]
          )
        );
        options = {
          LISTEN_ADDR = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1:8080";
            example = "0.0.0.0:8080";
            description = ''
              Address to serve the state API (`/state/{project}/{name}`) and `/health` on.

              This default is the loopback interface, and not the all-interfaces default of
              the upstream package, because the service has no usable access control.
            '';
          };

          METRICS_LISTEN_ADDR = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1:8081";
            example = "0.0.0.0:8081";
            description = ''
              Address to serve Prometheus metrics (`/metrics`) on. When it equals
              `LISTEN_ADDR`, the main listener serves the metrics instead.

              The metrics are not authenticated. `tfbackend_stored_objects` reports how
              many states the server holds.
            '';
          };

          STORAGE_FS_DIR = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/terraform-backend/states";
            description = ''
              Directory holding the encrypted state files, used by the `fs` storage
              backend. It is created with mode 0700 on startup.
            '';
          };

          KMS_KEY_FILE = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = if cfg.kmsKeyFile != null then "%d/kms-key" else null;
            defaultText = lib.literalMD ''
              the credential that [](#opt-services.terraform-backend.kmsKeyFile) supplies,
              or `null`
            '';
            description = ''
              Path of the key for the `local` KMS backend, as the service sees it.

              Set [](#opt-services.terraform-backend.kmsKeyFile) instead. That option
              passes the key as a systemd credential, which keeps it readable for the
              service alone.
            '';
          };

          FORCE_UNLOCK_ENABLED = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Accept an unlock request that does not carry the id of the current lock.

              This default is `false`, and not the `true` of the upstream package, because
              a force unlock lets one client interrupt the apply of another client.
            '';
          };
        };
      };
      default = { };
      example = {
        LOG_LEVEL = "debug";
        STORAGE_BACKEND = "s3";
        STORAGE_S3_BUCKET = "terraform-state";
        LOCK_BACKEND = "redis";
        REDIS_ADDR = "127.0.0.1:6379";
      };
      description = ''
        Environment variables configuring the backend. See
        <https://github.com/nimbolus/terraform-backend#configuration> for the full list;
        the backend is configured through environment variables only, there is no
        configuration file.

        Clients authenticate with HTTP basic auth, where the username selects the
        authentication backend (`basic` or `jwt`).

        The `basic` backend is not access control, and it is safe in a test environment
        only. It accepts every password. It only namespaces the state, and derives the
        state id from `sha256("<password>:" + sha256("<project>-<name>"))`, so a client
        that presents a different password sees a different, initially empty state. There
        is no way to reject a client, to rotate a password, or to withdraw access from a
        client that holds one.

        The `jwt` backend does check the `terraform-backend.project` and
        `terraform-backend.state` claims of the token. It needs {env}`VAULT_ADDR`, and it
        takes the issuer from that address. Do not set
        {env}`AUTH_JWT_OIDC_ISSUER_URL`: as of version 0.2.3 that value makes every
        request fail.

        The lock does not cover every request. As of version 0.2.3 a `DELETE` request
        removes the state and does not read the lock, so a client can delete the state
        while a different client applies. A write does read the lock.

        The `local` lock backend, which is the default, holds the locks in memory. A
        restart of the service releases all locks that are held at that time, and a
        client that applies at that moment keeps a lock id that the service no longer
        knows. Set {env}`LOCK_BACKEND` to `redis` or `postgres` to keep the locks through
        a restart.

        Set {env}`LOG_LEVEL` to `trace` in a test environment only. That level writes
        every request and response body to the journal, which is the plain text state with
        every credential in it.

        Values set here end up in the world-readable Nix store, so secrets belong in
        [](#opt-services.terraform-backend.kmsKeyFile) and
        [](#opt-services.terraform-backend.environmentFile) instead.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          (cfg.settings.KMS_BACKEND or "local") != "local"
          || cfg.settings.KMS_KEY_FILE != null
          || cfg.environmentFile != null
          || cfg.settings ? KMS_KEY;
        message = ''
          services.terraform-backend: the `local` KMS backend needs a key, otherwise the
          service exits at startup and writes a freshly generated key to the journal. Set
          services.terraform-backend.kmsKeyFile, or supply KMS_KEY through
          services.terraform-backend.environmentFile.
        '';
      }
      {
        assertion = !(cfg.settings ? AUTH_JWT_OIDC_ISSUER_URL);
        message = ''
          services.terraform-backend.settings.AUTH_JWT_OIDC_ISSUER_URL makes every request
          fail as of version 0.2.3. The `jwt` backend takes the issuer from VAULT_ADDR;
          set that instead.
        '';
      }
      {
        assertion = !cfg.openFirewall || listenPort != null;
        message = ''
          services.terraform-backend.openFirewall needs a numeric port in
          services.terraform-backend.settings.LISTEN_ADDR, which is
          "${cfg.settings.LISTEN_ADDR}".
        '';
      }
    ];

    warnings =
      lib.optional (cfg.settings ? KMS_KEY) ''
        services.terraform-backend.settings.KMS_KEY puts the state encryption key in the
        world-readable Nix store. Use services.terraform-backend.kmsKeyFile instead.
      ''
      ++ lib.optional (cfg.kmsKeyFile != null && lib.hasPrefix builtins.storeDir "${cfg.kmsKeyFile}") ''
        services.terraform-backend.kmsKeyFile is a Nix store path, which makes the state
        encryption key world-readable. Give a path that a secret manager writes at
        runtime instead.
      ''
      ++ lib.optional (sharedStorage && (cfg.settings.LOCK_BACKEND or "local") == "local") ''
        services.terraform-backend uses shared storage
        (STORAGE_BACKEND = "${cfg.settings.STORAGE_BACKEND}") with the `local` lock
        backend. That lock is an in-process mutex, so it cannot exclude a second instance
        of the service, and two concurrent applies corrupt the state. Set LOCK_BACKEND to
        `redis` or `postgres`, or keep the storage local to this machine.
      '';

    systemd.services.terraform-backend = {
      description = "Terraform/OpenTofu HTTP state backend";
      documentation = [ "https://github.com/nimbolus/terraform-backend" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # Rendered here rather than through `environment` so that systemd expands the
        # `%d` credentials-directory specifier in KMS_KEY_FILE.
        Environment = lib.mapAttrsToList (
          name: value: "${name}=${if lib.isBool value then lib.boolToString value else toString value}"
        ) (lib.filterAttrs (_: value: value != null) cfg.settings);
        ExecStart = lib.getExe cfg.package;
        LoadCredential = lib.optional (cfg.kmsKeyFile != null) "kms-key:${cfg.kmsKeyFile}";
        EnvironmentFile = cfg.environmentFile;
        Restart = "on-failure";
        RestartSec = 5;

        DynamicUser = true;
        StateDirectory = "terraform-backend";
        StateDirectoryMode = "0700";
        UMask = "0077";

        ProtectSystem = "strict";
        # `StateDirectory` already covers the default of `STORAGE_FS_DIR`.
        ReadWritePaths = lib.optional (
          !lib.hasPrefix "/var/lib/terraform-backend" (toString cfg.settings.STORAGE_FS_DIR)
        ) cfg.settings.STORAGE_FS_DIR;
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        LockPersonality = true;
        NoNewPrivileges = true;
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        # AF_UNIX for a local PostgreSQL socket.
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall (
      lib.optional (listenPort != null) listenPort
    );
  };

  meta.maintainers = with lib.maintainers; [ kiara ];
}
