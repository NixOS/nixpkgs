{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.pds;

  inherit (lib)
    boolToString
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalString
    types
    ;
in
# All defaults are from https://github.com/bluesky-social/pds/blob/8b9fc24cec5f30066b0d0b86d2b0ba3d66c2b532/installer.sh
{
  options.services.pds = {
    enable = mkEnableOption "pds";

    package = mkPackageOption pkgs "pds" { };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Environment variables to set for the service. Secrets should be
        specified using {option}`environmentFile`.
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
        You can generate initial values with
        ```
        nix-build -A pds.passthru.generateSecrets
        ./result/bin/generate-pds-secrets > secrets.env
        ```
      '';
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "Port to listen on";
    };

    hostname = mkOption {
      type = types.str;
      description = "Instance hostname";
    };

    dataDirectory = mkOption {
      type = types.str;
      default = "/var/lib/pds";
      description = "Directory to store state";
    };

    blobstorageDirectory = mkOption {
      type = types.nullOr types.str;
      default = "/var/lib/pds/blocks";
      description = "Directory to store blobstorage";
    };

    blobUploadLimit = mkOption {
      type = types.int;
      default = 52428800;
      description = "Size limit of uploaded blobs";
    };

    plcUrl = mkOption {
      type = types.str;
      default = "https://plc.directory";
      description = "URL of DID PLC directory";
    };

    bskyAppViewUrl = mkOption {
      type = types.str;
      default = "https://api.bsky.app";
      description = "URL of bsky frontend";
    };

    bskyAppViewDid = mkOption {
      type = types.str;
      default = "did:web:api.bsky.app";
      description = "DID of bsky frontend";
    };

    reportServiceUrl = mkOption {
      type = types.str;
      default = "https://mod.bsky.app";
      description = "URL of mod service";
    };

    reportServiceDid = mkOption {
      type = types.str;
      default = "did:plc:ar7c4by46qjdydhdevvrndac";
      description = "DID of mod service";
    };

    crawlers = mkOption {
      type = types.str;
      default = "https://bsky.network";
      description = "URL of crawlers";
    };

    log.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable logging";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pds = {
      description = "pds";
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      script = ''
        exec ${getExe cfg.package}
      '';

      serviceConfig = {
        Environment =
          [
            "NODE_ENV=production"
            "PDS_PORT=${toString cfg.port}"
            "PDS_HOSTNAME=${cfg.hostname}"
            "PDS_DATA_DIRECTORY=${cfg.dataDirectory}"
            "PDS_BLOB_UPLOAD_LIMIT=${toString cfg.blobUploadLimit}"
            "PDS_DID_PLC_URL=${cfg.plcUrl}"
            "PDS_BSKY_APP_VIEW_URL=${cfg.bskyAppViewUrl}"
            "PDS_BSKY_APP_VIEW_DID=${cfg.bskyAppViewDid}"
            "PDS_REPORT_SERVICE_URL=${cfg.reportServiceUrl}"
            "PDS_REPORT_SERVICE_DID=${cfg.reportServiceDid}"
            "PDS_CRAWLERS=${cfg.crawlers}"
            "LOG_ENABLED=${boolToString cfg.log.enable}"
          ]
          ++ (optional (
            cfg.blobstorageDirectory != null
          ) "PDS_BLOBSTORE_DISK_LOCATION=${cfg.blobstorageDirectory}");

        EnvironmentFile = cfg.environmentFiles;
        User = "pds";
        Group = "pds";
        StateDirectory = "pds";
        StateDirectoryMode = "0755";
        Restart = "always";
      };
    };

    users = {
      users.pds = {
        group = "pds";
        createHome = false;
        isSystemUser = true;
      };
      groups.pds = { };
    };

  };

  meta.maintainers = with lib.maintainers; [ t4ccer ];
}
