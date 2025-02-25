{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.services.synapse-auto-compressor;
  opt = options.services.synapes-auto-compressor;
  bin = lib.getExe cfg.package;
  types = lib.types;
in {
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.postgres-url != null;
        message = "postgres-url must be set!";
      }
    ];
  };

  options = {
    services.synapse-auto-compressor = {
      enable = lib.mkEnableOption "synapse-auto-compressor";
      package = lib.mkPackageOption pkgs "rust-synapse-state-compress";
      postgres-url = lib.mkOption {
        default = config.services.matrix-synapse.hasLocalPostgresDB @TODOl;
        type = types.nullOr types.str;
        example = "postgresql://username:password@mydomain.com/database";
      };
      startAt = lib.mkOption {
        default = "@weekly";
        type = types.either types.str (types.listOf types.str);
        description = "How often to run this service in SystemD Calendar syntax (e.g.: @daily, @weekly)";
      };
    };
  };

  services.synapse-auto-compressor = {
    settings = lib.mkOption {
      default = { };
      description = ''
        TODO
      '';
      type =
        with lib.types;
        submodule {
          freeformType = format.type;
          options = {
            postgres_location = mkOption {

            };
            chunk_size = lib.mkOption {
              type = types.int;
              example = 500;
              default = 500;
              description = ''
                The number of state groups to work on at once. All of the entries from state_groups_state are requested
                from the database for state groups that are worked on. Therefore small chunk sizes may be needed on
                machines with low memory. Note: if the compressor fails to find space savings on the chunk as a whole
                (which may well happen in rooms with lots of backfill in) then the entire chunk is skipped.
              '';
            };
            chunks_to_compress = mkOption {
              type = types.int;
              example = 100;
              default = 100;
              description = ''
                CHUNKS_TO_COMPRESS chunks of size CHUNK_SIZE will be compressed. The higher this number is set to,
                the longer the compressor will run for.
              '';
            };
            levels = mkOption {
              type = types.listOf types.int;
              example = [ 100 50 25 ];
              default = [ 100 50 25 ];
              description = ''
                Sizes of each new level in the compression algorithm, as a comma-separated list. The first entry in
                the list is for the lowest, most granular level, with each subsequent entry being for the next highest
                level. The number of entries in the list determines the number of levels that will be used. The sum of
                the sizes of the levels affects the performance of fetching the state from the database, as the sum of
                the sizes is the upper bound on the number of iterations needed to fetch a given set of state.
             '';
            };
          };
        };
    };
  };

  systemd.services.synapse-auto-compressor = {
    description = "synapse-auto-compressor";
    requires = "postgresql.service";
    path = [ cfg.package ];
    inherit (cfg) startAt;
    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;
      PrivateTmp = true;
      ExecStart = "${bin} -p ${cfg.postgres_url} -c ${cfg.settings.chunk_size} -n ${cfg.settings.chunks_to_compress}";
      NoNewPrivileges = true;
      ProcSubset = "pid";
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectDevices = true;
      ProtectUsers = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RemoveIPC = true;
      PrivateMounts = true;
    };
  };
}
