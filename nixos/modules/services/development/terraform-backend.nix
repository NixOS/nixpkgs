{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.terraform-backend;
in
{
  options.services.terraform-backend = {
    enable = lib.mkEnableOption "terraform-backend, a Terraform/OpenTofu HTTP state backend";

    package = lib.mkPackageOption pkgs "terraform-backend" { };

    kmsKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/terraform-backend-kms-key";
      description = ''
        Path to the key used by the `local` KMS backend to encrypt state at rest.

        The file must contain the base64 encoding of 16, 24 or 32 raw bytes, with no
        trailing newline, as produced by `openssl rand -base64 32 | tr -d '\n'`.
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
        the firewall. The metrics listener is left closed.
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
            default = ":8080";
            example = "127.0.0.1:8080";
            description = ''
              Address to serve the state API (`/state/{project}/{name}`) and `/health` on.
            '';
          };

          METRICS_LISTEN_ADDR = lib.mkOption {
            type = lib.types.str;
            default = ":8081";
            example = "127.0.0.1:8081";
            description = ''
              Address to serve Prometheus metrics (`/metrics`) on. When it equals
              `LISTEN_ADDR`, metrics are served by the main listener instead.
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
        };
      };
      default = { };
      example = {
        LOG_LEVEL = "debug";
        STORAGE_BACKEND = "s3";
        STORAGE_S3_BUCKET = "terraform-state";
      };
      description = ''
        Environment variables configuring the backend. See
        <https://github.com/nimbolus/terraform-backend#configuration> for the full list;
        the backend is configured through environment variables only, there is no
        configuration file.

        Clients authenticate with HTTP basic auth, where the username selects the
        authentication backend (`basic` or `jwt`). Note that the `basic` backend does not
        restrict access: it namespaces state, deriving the state id from
        `sha256("<password>:<project>/<name>")`, so a client presenting a different
        password sees a different, initially empty state rather than being rejected.

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
          || cfg.kmsKeyFile != null
          || cfg.environmentFile != null
          || cfg.settings ? KMS_KEY_FILE
          || cfg.settings ? KMS_KEY;
        message = ''
          services.terraform-backend: the `local` KMS backend needs a key, otherwise the
          service exits at startup. Set services.terraform-backend.kmsKeyFile, or supply
          KMS_KEY through services.terraform-backend.environmentFile.
        '';
      }
    ];

    warnings = lib.optional (cfg.settings ? KMS_KEY) ''
      services.terraform-backend.settings.KMS_KEY puts the state encryption key in the
      world-readable Nix store. Use services.terraform-backend.kmsKeyFile instead.
    '';

    services.terraform-backend.settings.KMS_KEY_FILE = lib.mkIf (cfg.kmsKeyFile != null) (
      lib.mkDefault "%d/kms-key"
    );

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

    networking.firewall.allowedTCPPorts =
      let
        port = lib.toInt (lib.last (lib.splitString ":" cfg.settings.LISTEN_ADDR));
      in
      lib.mkIf cfg.openFirewall [ port ];
  };

  meta.maintainers = with lib.maintainers; [ kiara ];
}
