{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.qdrant;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in
{

  options = {
    services.qdrant = {
      enable = lib.mkEnableOption "Vector Search Engine for the next generation of AI applications";

      package = lib.mkPackageOption pkgs "qdrant" { };

      webUIPackage = lib.mkPackageOption pkgs "qdrant-web-ui" { };

      settings = lib.mkOption {
        description = ''
          Configuration for Qdrant
          Refer to <https://github.com/qdrant/qdrant/blob/master/config/config.yaml> for details on supported values.
        '';

        type = settingsFormat.type;

        example = {
          storage = {
            storage_path = "/var/lib/qdrant/storage";
            snapshots_path = "/var/lib/qdrant/snapshots";
          };
          hsnw_index = {
            on_disk = true;
          };
          service = {
            host = "127.0.0.1";
            http_port = 6333;
            grpc_port = 6334;
          };
          telemetry_disabled = true;
        };

        defaultText = lib.literalExpression ''
          {
            storage = {
              storage_path = "/var/lib/qdrant/storage";
              snapshots_path = "/var/lib/qdrant/snapshots";
            };
            hsnw_index = {
              on_disk = true;
            };
            service = {
              host = "127.0.0.1";
              http_port = 6333;
              grpc_port = 6334;
            };
            telemetry_disabled = true;
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.qdrant.settings = {
      service.static_content_dir = lib.mkDefault cfg.webUIPackage;
      storage.storage_path = lib.mkDefault "/var/lib/qdrant/storage";
      storage.snapshots_path = lib.mkDefault "/var/lib/qdrant/snapshots";
      # The following default values are the same as in the default config,
      # they are just written here for convenience.
      storage.on_disk_payload = lib.mkDefault true;
      storage.wal.wal_capacity_mb = lib.mkDefault 32;
      storage.wal.wal_segments_ahead = lib.mkDefault 0;
      storage.performance.max_search_threads = lib.mkDefault 0;
      storage.performance.max_optimization_threads = lib.mkDefault 1;
      storage.optimizers.deleted_threshold = lib.mkDefault 0.2;
      storage.optimizers.vacuum_min_vector_number = lib.mkDefault 1000;
      storage.optimizers.default_segment_number = lib.mkDefault 0;
      storage.optimizers.max_segment_size_kb = lib.mkDefault null;
      storage.optimizers.memmap_threshold_kb = lib.mkDefault null;
      storage.optimizers.indexing_threshold_kb = lib.mkDefault 20000;
      storage.optimizers.flush_interval_sec = lib.mkDefault 5;
      storage.optimizers.max_optimization_threads = lib.mkDefault 1;
      storage.hnsw_index.m = lib.mkDefault 16;
      storage.hnsw_index.ef_construct = lib.mkDefault 100;
      storage.hnsw_index.full_scan_threshold_kb = lib.mkDefault 10000;
      storage.hnsw_index.max_indexing_threads = lib.mkDefault 0;
      storage.hnsw_index.on_disk = lib.mkDefault false;
      storage.hnsw_index.payload_m = lib.mkDefault null;
      service.max_request_size_mb = lib.mkDefault 32;
      service.max_workers = lib.mkDefault 0;
      service.http_port = lib.mkDefault 6333;
      service.grpc_port = lib.mkDefault 6334;
      service.enable_cors = lib.mkDefault true;
      cluster.enabled = lib.mkDefault false;
      # the following have been altered for security
      service.host = lib.mkDefault "127.0.0.1";
      telemetry_disabled = lib.mkDefault true;
    };

    systemd.services.qdrant = {
      description = "Vector Search Engine for the next generation of AI applications";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        LimitNOFILE = 65536;
        ExecStart = "${cfg.package}/bin/qdrant --config-path ${configFile}";
        DynamicUser = true;
        Restart = "on-failure";
        StateDirectory = "qdrant";
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RemoveIPC = true;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };
    };
  };
}
