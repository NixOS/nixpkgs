{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    elem
    escapeShellArg
    getExe
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    optionals
    recursiveUpdate
    types
    ;

  cfg = config.services.buildgrid;

  # Internal references used to tie a single storage/cache/scheduler/sql
  # instance to every place it is used in the generated configuration, so
  # that BuildGrid constructs one shared object (via a YAML anchor) instead
  # of one independent copy per reference.
  refs = {
    sql = "sql";
    storage = "cas-storage";
    actionCache = "action-cache";
    scheduler = "scheduler";
  };

  # A scalar tagged with one of BuildGrid's "string" YAML tags, e.g.
  # `!read-file /path`.
  taggedScalar = tag: value: {
    __tag = tag;
    __scalar = value;
  };

  isScalar =
    v: v == null || builtins.isBool v || builtins.isInt v || builtins.isFloat v || builtins.isString v;

  scalarText =
    v:
    if v == null then
      "null"
    else if builtins.isBool v then
      (if v then "true" else "false")
    else if builtins.isString v then
      builtins.toJSON v
    else
      toString v;

  # Renders a BuildGrid configuration value as flow-style YAML, expanding
  # `__tag`/`__ref` markers into BuildGrid's custom object tags and, for
  # values reused across multiple places, YAML anchors/aliases (so shared
  # state - e.g. an in-memory action cache - is actually shared at runtime
  # rather than duplicated once per reference).
  #
  # `seen` is threaded through the recursion and lists the `__ref` names
  # already anchored earlier in the document.
  renderValue =
    seen: value:
    if isScalar value then
      {
        text = scalarText value;
        inherit seen;
      }
    else if builtins.isList value then
      let
        folded =
          builtins.foldl'
            (
              acc: item:
              let
                r = renderValue acc.seen item;
              in
              {
                texts = acc.texts ++ [ r.text ];
                inherit (r) seen;
              }
            )
            {
              texts = [ ];
              inherit seen;
            }
            value;
      in
      {
        text = "[" + concatStringsSep ", " folded.texts + "]";
        inherit (folded) seen;
      }
    else if value ? __scalar then
      {
        text = "!${value.__tag} ${scalarText value.__scalar}";
        inherit seen;
      }
    else if value ? __tag then
      renderTagged seen value
    else
      renderMapping seen value;

  renderTagged =
    seen: value:
    let
      ref = value.__ref or null;
    in
    if ref != null && elem ref seen then
      {
        text = "*${ref}";
        inherit seen;
      }
    else
      let
        body = removeAttrs value [
          "__tag"
          "__ref"
        ];
        seen' = if ref != null then seen ++ [ ref ] else seen;
        anchor = if ref != null then "&${ref} " else "";
        r = renderMapping seen' body;
      in
      {
        text = "!${value.__tag} ${anchor}${r.text}";
        inherit (r) seen;
      };

  renderMapping =
    seen: attrs:
    let
      folded =
        builtins.foldl'
          (
            acc: key:
            let
              r = renderValue acc.seen attrs.${key};
            in
            {
              pairs = acc.pairs ++ [ "${key}: ${r.text}" ];
              inherit (r) seen;
            }
          )
          {
            pairs = [ ];
            inherit seen;
          }
          (builtins.attrNames attrs);
    in
    {
      text = "{" + concatStringsSep ", " folded.pairs + "}";
      inherit (folded) seen;
    };

  # BuildGrid's schema requires anchors to be defined before use, so the
  # top-level keys of the generated document must be emitted in dependency
  # order rather than the alphabetical order `builtins.attrNames` would give.
  topLevelOrder = [
    "description"
    "server"
    "grpc-server-options"
    "authorization"
    "connections"
    "storages"
    "caches"
    "schedulers"
    "instances"
    "services"
    "monitoring"
    "thread-pool-size"
    "maximum-concurrent-rpcs"
    "limiter"
  ];

  renderDocument =
    topAttrs:
    let
      orderedKeys =
        builtins.filter (k: topAttrs ? ${k}) topLevelOrder
        ++ builtins.filter (k: !(elem k topLevelOrder)) (builtins.attrNames topAttrs);
      folded =
        builtins.foldl'
          (
            acc: key:
            let
              r = renderValue acc.seen topAttrs.${key};
            in
            {
              lines = acc.lines ++ [ "${key}: ${r.text}" ];
              inherit (r) seen;
            }
          )
          {
            lines = [ ];
            seen = [ ];
          }
          orderedKeys;
    in
    concatStringsSep "\n" folded.lines + "\n";

  channel = {
    __tag = "channel";
    address = cfg.server.address;
    insecure-mode = cfg.server.insecure;
  }
  // optionalAttrs (!cfg.server.insecure) {
    credentials = {
      tls-server-key = cfg.server.tls.keyFile;
      tls-server-cert = cfg.server.tls.certFile;
    }
    // optionalAttrs (cfg.server.tls.clientCaFile != null) {
      tls-client-certs = cfg.server.tls.clientCaFile;
    };
  };

  sqlConnection = {
    __tag = "sql-connection";
    __ref = refs.sql;
    connection-string =
      if cfg.database.createLocally then
        "postgresql:///${cfg.database.name}?host=${cfg.database.socketDir}"
      else
        taggedScalar "read-file" (toString cfg.database.connectionStringFile);
  };

  diskStorage = {
    __tag = "disk-storage";
    __ref = refs.storage;
    path = cfg.storage.path;
  };

  lruActionCache = {
    __tag = "lru-action-cache";
    __ref = refs.actionCache;
    storage = diskStorage;
    max-cached-refs = 256;
    allow-updates = true;
    cache-failed-actions = true;
  };

  sqlScheduler = {
    __tag = "sql-scheduler";
    __ref = refs.scheduler;
    sql = sqlConnection;
    storage = diskStorage;
    action-cache = lruActionCache;
  };

  instanceService =
    name:
    if name == "action-cache" then
      {
        __tag = "action-cache";
        cache = lruActionCache;
      }
    else if name == "execution" then
      {
        __tag = "execution";
        scheduler = sqlScheduler;
      }
    else if name == "cas" then
      {
        __tag = "cas";
        storage = diskStorage;
      }
    else if name == "bytestream" then
      {
        __tag = "bytestream";
        storage = diskStorage;
      }
    else
      throw "buildgrid: unknown instance service `${name}`";

  generatedSettings = {
    server = [ channel ];
    authorization.method = "none";
    connections = [ sqlConnection ];
    storages = [ diskStorage ];
    caches = [ lruActionCache ];
    schedulers = [ sqlScheduler ];
    instances = map (instance: {
      inherit (instance) name;
      services = map instanceService instance.services;
    }) cfg.instances;
  };

  finalSettings = recursiveUpdate generatedSettings cfg.settings;

  configFile = pkgs.writeText "buildgrid-server.yml" (renderDocument finalSettings);

  connectionStringShell =
    if cfg.database.createLocally then
      escapeShellArg "postgresql:///${cfg.database.name}?host=${cfg.database.socketDir}"
    else
      ''"$(cat ${escapeShellArg cfg.database.connectionStringFile})"'';

  migrateScript = pkgs.writeShellScript "buildgrid-migrate" ''
    set -euo pipefail
    exec ${getExe cfg.package} migrate apply ${connectionStringShell}
  '';

  instanceServiceType = types.enum [
    "action-cache"
    "execution"
    "cas"
    "bytestream"
  ];
in
{
  options.services.buildgrid = {
    enable = mkEnableOption "the BuildGrid remote execution and remote caching server";

    package = mkPackageOption pkgs "buildgrid" { };

    user = mkOption {
      type = types.str;
      default = "buildgrid";
      description = "User account under which BuildGrid runs.";
    };

    group = mkOption {
      type = types.str;
      default = "buildgrid";
      description = "Group under which BuildGrid runs.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/buildgrid";
      description = "Directory holding BuildGrid's persistent state.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for {option}`services.buildgrid.server.address`.";
    };

    server = {
      address = mkOption {
        type = types.str;
        default = "[::]:50051";
        example = "0.0.0.0:50051";
        description = ''
          Address BuildGrid's gRPC server listens on, equivalent to the
          `50051:50051` port mapping exposed by upstream's Docker Compose
          setup.
        '';
      };

      insecure = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to serve gRPC without TLS, matching the `insecure-mode: true`
          default used by upstream's Docker Compose setup. Set to `false` and
          configure {option}`services.buildgrid.server.tls` to enable TLS.
        '';
      };

      tls = {
        certFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "TLS server certificate, required when `insecure` is `false`.";
        };

        keyFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "TLS server key, required when `insecure` is `false`.";
        };

        clientCaFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = "CA bundle used to verify client certificates, for mutual TLS.";
        };
      };
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to provision a local PostgreSQL database and role for
          BuildGrid, mirroring the bundled `postgres:latest` `database`
          service in upstream's Docker Compose setup. Connection happens
          over the local UNIX socket using peer authentication, matching
          {option}`services.buildgrid.user`.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "buildgrid";
        description = "Name of the PostgreSQL database used for job/action state.";
      };

      user = mkOption {
        type = types.str;
        default = cfg.user;
        defaultText = literalExpression "config.services.buildgrid.user";
        description = "PostgreSQL role used to connect to the database.";
      };

      socketDir = mkOption {
        type = types.path;
        default = "/run/postgresql";
        description = "UNIX socket directory of the PostgreSQL server, used when `createLocally` is `true`.";
      };

      connectionStringFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/secrets/buildgrid-db-connection-string";
        description = ''
          Path to a file containing a full PostgreSQL connection URI (e.g.
          `postgresql://user:password@host:5432/dbname`), read at runtime via
          BuildGrid's `!read-file` tag. Required when `createLocally` is
          `false`, ignored otherwise.
        '';
      };
    };

    storage.path = mkOption {
      type = types.path;
      default = "${cfg.dataDir}/store";
      defaultText = literalExpression ''"''${config.services.buildgrid.dataDir}/store"'';
      description = ''
        Directory used for the on-disk content-addressable storage.
        Equivalent to the `data` volume that upstream's Docker Compose
        setup mounts at `/var/lib/buildgrid/store`.
      '';
    };

    instances = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              default = "";
              description = "Instance name, as used by REAPI/RWAPI clients.";
            };

            services = mkOption {
              type = types.listOf instanceServiceType;
              default = [
                "action-cache"
                "execution"
                "cas"
                "bytestream"
              ];
              description = "REAPI/RWAPI services exposed by this instance.";
            };
          };
        }
      );
      default = [
        {
          services = [
            "action-cache"
            "execution"
            "cas"
            "bytestream"
          ];
        }
      ];
      example = literalExpression ''
        [
          {
            name = "main";
            services = [ "cas" "bytestream" ];
          }
        ]
      '';
      description = ''
        BuildGrid instances to serve. Restricting an instance's `services`
        mirrors the way upstream's Docker Compose setup splits storage,
        cache, controller and bots-interface responsibilities across
        separate containers.
      '';
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      example = literalExpression ''
        {
          monitoring.enabled = true;
          thread-pool-size = 200;
          authorization.method = "jwt";
        }
      '';
      description = ''
        Additional BuildGrid-specific settings, recursively merged into the
        generated server configuration. This is where anything not covered
        by the options above belongs, e.g. authorization, monitoring, gRPC
        tunables or scheduler tuning.

        Use the attribute `__tag` on an attribute set to emit a YAML object
        tag (e.g. `{ __tag = "s3-storage"; ... }` renders as
        `!s3-storage {...}`) and `__ref` to have BuildGrid share a single
        instance of it across every place it is referenced, via a YAML
        anchor.

        See upstream's [reference configuration](https://gitlab.com/BuildGrid/buildgrid/-/blob/master/data/config/reference.yml)
        for the full set of supported keys and tags.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createLocally || cfg.database.connectionStringFile != null;
        message = "services.buildgrid.database.connectionStringFile is required when services.buildgrid.database.createLocally is false.";
      }
      {
        assertion =
          cfg.server.insecure || (cfg.server.tls.certFile != null && cfg.server.tls.keyFile != null);
        message = "services.buildgrid.server.tls.certFile and keyFile are required when services.buildgrid.server.insecure is false.";
      }
    ];

    users.users = optionalAttrs (cfg.user == "buildgrid") {
      buildgrid = {
        isSystemUser = true;
        inherit (cfg) group;
        home = cfg.dataDir;
        description = "BuildGrid service user";
      };
    };

    users.groups = optionalAttrs (cfg.group == "buildgrid") {
      buildgrid = { };
    };

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.storage.path}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.buildgrid = {
      description = "BuildGrid remote execution and remote caching server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ optional cfg.database.createLocally "postgresql.service";
      requires = optionals cfg.database.createLocally [ "postgresql.service" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStartPre = [ migrateScript ];
        ExecStart = "${getExe cfg.package} server start ${configFile}";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    networking.firewall.allowedTCPPorts = optional cfg.openFirewall (
      lib.toInt (lib.last (lib.splitString ":" cfg.server.address))
    );
  };
}
