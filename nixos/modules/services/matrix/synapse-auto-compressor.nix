{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.synapse-auto-compressor;
  synapseConfig = config.services.matrix-synapse;
  postgresEnabled = config.services.postgresql.enable;
  synapseUsesPostgresql = synapseConfig.settings.database.name == "psycopg2";
  synapseUsesLocalPostgresql =
    let
      args = synapseConfig.settings.database.args;
    in
    synapseUsesPostgresql
    && postgresEnabled
    && (
      !(args ? host)
      || (builtins.elem args.host [
        "localhost"
        "127.0.0.1"
        "::1"
      ])
    );
in
{
  options = {
    services.synapse-auto-compressor = {
      enable = lib.mkEnableOption "synapse-auto-compressor";
      package = lib.mkPackageOption pkgs "rust-synapse-compress-state" { };
      postgresUrl = lib.mkOption {
        default =
          let
            args = synapseConfig.settings.database.args;
          in
          if synapseConfig.enable then
            ''postgresql://${args.user}${lib.optionalString (args ? password) (":" + args.password)}@${
              lib.escapeURL (if (args ? host) then args.host else "/run/postgresql")
            }${lib.optionalString (args ? port) (":" + args.port)}/${args.database}''
          else
            null;
        defaultText = lib.literalExpression ''
          let
            synapseConfig = config.services.matrix-synapse;
            args = synapseConfig.settings.database.args;
          in
          if synapseConfig.enable then
            '''postgresql://''${args.user}''${lib.optionalString (args ? password) (":" + args.password)}@''${
              lib.escapeURL (if (args ? host) then args.host else "/run/postgresql")
            }''${lib.optionalString (args ? port) (":" + args.port)}''${args.database}'''
          else
            null;
        '';
        type = lib.types.str;
        example = "postgresql://username:password@mydomain.com:port/database";
        description = ''
          Connection string to postgresql in the
          [rust `postgres` crate config format](https://docs.rs/postgres/latest/postgres/config/struct.Config.html).
          The module will attempt to build a URL-style connection string out of the `services.matrix-synapse.settings.database.args`
          if a local synapse is enabled.
        '';
      };
      startAt = lib.mkOption {
        default = "weekly";
        type = with lib.types; either str (listOf str);
        description = "How often to run this service in systemd calendar syntax (see {manpage}`systemd.time(7)`)";
        example = "daily";
      };

      settings = {
        chunk_size = lib.mkOption {
          type = lib.types.int;
          default = 500;
          description = ''
            The number of state groups to work on at once. All of the entries from `state_groups_state` are requested
            from the database for state groups that are worked on. Therefore small chunk sizes may be needed on
            machines with low memory.

            Note: if the compressor fails to find space savings on the chunk as a whole
            (which may well happen in rooms with lots of backfill in) then the entire chunk is skipped.
          '';
        };
        chunks_to_compress = lib.mkOption {
          type = lib.types.int;
          default = 100;
          description = ''
            `chunks_to_compress` chunks of size `chunk_size` will be compressed. The higher this number is set to,
            the longer the compressor will run for.
          '';
        };
        levels = lib.mkOption {
          type = with lib.types; listOf int;
          default = [
            100
            50
            25
          ];
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
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = synapseConfig.enable && synapseUsesPostgresql;
        message = "`services.synapse-auto-compressor` requires local synapse to use postgresql as a database backend";
      }
    ];
    systemd.services.synapse-auto-compressor = {
      description = "synapse-auto-compressor";
      requires = lib.optionals synapseUsesLocalPostgresql [
        "postgresql.target"
      ];
      inherit (cfg) startAt;
      serviceConfig = {
        Type = "oneshot";
        DynamicUser = true;
        User = "matrix-synapse";
        PrivateTmp = true;
        ExecStart = utils.escapeSystemdExecArgs [
          "${cfg.package}/bin/synapse_auto_compressor"
          "-p"
          cfg.postgresUrl
          "-c"
          cfg.settings.chunk_size
          "-n"
          cfg.settings.chunks_to_compress
          "-l"
          (lib.concatStringsSep "," (builtins.map builtins.toString cfg.settings.levels))
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        ProcSubset = "pid";
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
      };
    };
  };
}
