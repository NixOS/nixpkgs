{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.bluesky-pds;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    escapeShellArgs
    concatMapStringsSep
    types
    literalExpression
    ;

  pdsadminWrapper =
    let
      cfgSystemd = config.systemd.services.bluesky-pds.serviceConfig;
    in
    pkgs.writeShellScriptBin "pdsadmin" ''
      DUMMY_PDS_ENV_FILE="$(mktemp)"
      trap 'rm -f "$DUMMY_PDS_ENV_FILE"' EXIT
      env "PDS_ENV_FILE=$DUMMY_PDS_ENV_FILE"                                                   \
          ${escapeShellArgs cfgSystemd.Environment}                                            \
          ${concatMapStringsSep " " (envFile: "$(cat ${envFile})") cfgSystemd.EnvironmentFile} \
          ${getExe pkgs.bluesky-pdsadmin} "$@"
    '';
in
# All defaults are from https://github.com/bluesky-social/pds/blob/8b9fc24cec5f30066b0d0b86d2b0ba3d66c2b532/installer.sh
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "pds" "enable" ] [ "services" "bluesky-pds" "enable" ])
    (lib.mkRenamedOptionModule [ "services" "pds" "package" ] [ "services" "bluesky-pds" "package" ])
    (lib.mkRenamedOptionModule [ "services" "pds" "settings" ] [ "services" "bluesky-pds" "settings" ])
    (lib.mkRenamedOptionModule
      [ "services" "pds" "environmentFiles" ]
      [ "services" "bluesky-pds" "environmentFiles" ]
    )
    (lib.mkRenamedOptionModule [ "services" "pds" "pdsadmin" ] [ "services" "bluesky-pds" "pdsadmin" ])
  ];

  options.services.bluesky-pds = {
    enable = mkEnableOption "pds";

    package = mkPackageOption pkgs "bluesky-pds" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (
          types.oneOf [
            (types.nullOr types.str)
            types.port
          ]
        );
        options = {
          PDS_PORT = mkOption {
            type = types.port;
            default = 3000;
            description = "Port to listen on";
          };

          PDS_HOSTNAME = mkOption {
            type = types.str;
            example = "pds.example.com";
            description = "Instance hostname (base domain name)";
          };

          PDS_BLOB_UPLOAD_LIMIT = mkOption {
            type = types.str;
            default = "104857600";
            description = "Size limit of uploaded blobs in bytes";
          };

          PDS_DID_PLC_URL = mkOption {
            type = types.str;
            default = "https://plc.directory";
            description = "URL of DID PLC directory";
          };

          PDS_BSKY_APP_VIEW_URL = mkOption {
            type = types.str;
            default = "https://api.bsky.app";
            description = "URL of bsky frontend";
          };

          PDS_BSKY_APP_VIEW_DID = mkOption {
            type = types.str;
            default = "did:web:api.bsky.app";
            description = "DID of bsky frontend";
          };

          PDS_REPORT_SERVICE_URL = mkOption {
            type = types.str;
            default = "https://mod.bsky.app";
            description = "URL of mod service";
          };

          PDS_REPORT_SERVICE_DID = mkOption {
            type = types.str;
            default = "did:plc:ar7c4by46qjdydhdevvrndac";
            description = "DID of mod service";
          };

          PDS_CRAWLERS = mkOption {
            type = types.str;
            default = "https://bsky.network";
            description = "URL of crawlers";
          };

          PDS_DATA_DIRECTORY = mkOption {
            type = types.str;
            default = "/var/lib/pds";
            description = "Directory to store state";
          };

          PDS_BLOBSTORE_DISK_LOCATION = mkOption {
            type = types.nullOr types.str;
            default = "/var/lib/pds/blocks";
            description = "Store blobs at this location, set to null to use e.g. S3";
          };

          LOG_ENABLED = mkOption {
            type = types.nullOr types.str;
            default = "true";
            description = "Enable logging";
          };
        };
      };

      description = ''
        Environment variables to set for the service. Secrets should be
        specified using {option}`environmentFile`.

        Refer to <https://github.com/bluesky-social/atproto/blob/main/packages/pds/src/config/env.ts> for available environment variables.
      '';
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      description = ''
        File to load environment variables from. Loaded variables override
        values set in {option}`environment`.

        Use it to set values of `PDS_JWT_SECRET`, `PDS_ADMIN_PASSWORD`,
        and `PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX` secrets.
        `PDS_JWT_SECRET` and `PDS_ADMIN_PASSWORD` can be generated with
        ```
        openssl rand --hex 16
        ```
        `PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX` can be generated with
        ```
        openssl ecparam --name secp256k1 --genkey --noout --outform DER | tail --bytes=+8 | head --bytes=32 | xxd --plain --cols 32
        ```
      '';
    };

    pdsadmin = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        defaultText = literalExpression "config.services.bluesky-pds.enable";
        description = "Add pdsadmin script to PATH";
      };
    };
  };

  config = mkIf cfg.enable {
    environment = mkIf cfg.pdsadmin.enable {
      systemPackages = [ pdsadminWrapper ];
    };

    systemd.services.bluesky-pds = {
      description = "bluesky pds";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = getExe cfg.package;
        Environment = lib.mapAttrsToList (k: v: "${k}=${if builtins.isInt v then toString v else v}") (
          lib.filterAttrs (_: v: v != null) cfg.settings
        );

        EnvironmentFile = cfg.environmentFiles;
        User = "pds";
        Group = "pds";
        StateDirectory = "pds";
        StateDirectoryMode = "0755";
        Restart = "always";

        # Hardening
        RemoveIPC = true;
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        PrivateMounts = true;
        SystemCallArchitectures = [ "native" ];
        MemoryDenyWriteExecute = false; # required by V8 JIT
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        ProtectHostname = true;
        LockPersonality = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictRealtime = true;
        DeviceAllow = [ "" ];
        ProtectSystem = "strict";
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectHome = true;
        PrivateUsers = true;
        PrivateTmp = true;
        UMask = "0077";
      };
    };

    users = {
      users.pds = {
        group = "pds";
        isSystemUser = true;
      };
      groups.pds = { };
    };

  };

  meta.maintainers = with lib.maintainers; [ t4ccer ];
}
