{
  config,
  lib,
  pkgs,
  ...
}:
let
  shared = import ./paperclip-shared.nix { inherit lib pkgs; };
  instances = lib.filterAttrs (_: c: c.enable) config.services.paperclip.instances;
  render = name: c: shared.render name c;
  localDatabases = lib.filterAttrs (_: c: c.database.local.enable) instances;
  databaseName = name: "paperclip_${lib.replaceStrings [ "-" ] [ "_" ] name}";
  migrationRole = c: "${c.user}-migration";
in
{
  options.services.paperclip.instances = lib.mkOption {
    default = { };
    description = "Independent native Paperclip system services.";
    type = lib.types.attrsOf (
      lib.types.submodule [
        shared.instanceOptions
        ({ name, config, ... }: {
          options = {
            user = lib.mkOption {
              type = lib.types.str;
              default = "paperclip-${name}";
              description = "Dedicated Unix identity.";
            };
            openFirewall = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Open the listening TCP port.";
            };
            memoryMax = lib.mkOption {
              type = lib.types.str;
              default = "4G";
              description = "systemd memory limit.";
            };
            tasksMax = lib.mkOption {
              type = lib.types.ints.positive;
              default = 512;
              description = "systemd task limit.";
            };
            inaccessiblePaths = lib.mkOption {
              type = lib.types.listOf (lib.types.strMatching "^/[^[:space:]]+$");
              default = [ ];
              example = [
                "/srv/operator-workspaces"
                "/data/private"
              ];
              description = "Existing paths hidden from the service mount namespace, including readable operator workspaces outside /home. Missing paths fail startup. This is stronger than read-only access.";
            };
            database.local.enable = lib.mkEnableOption "a local PostgreSQL database with separate runtime and migration roles, authenticated over a Unix socket";
          };
          config.stateDir = lib.mkDefault "/var/lib/paperclip-${name}";
          config.database = lib.mkIf config.database.local.enable {
            mode = lib.mkDefault "postgres";
            urlFile = lib.mkDefault "/run/paperclip-${name}/database-url";
            migrationUrlFile = lib.mkDefault "/run/paperclip-${name}/migration-url";
          };
        })
      ]
    );
  };
  config = {
    assertions = shared.assertions instances ++ [
      {
        assertion =
          builtins.length (lib.unique (map (c: c.user) (builtins.attrValues instances)))
          == builtins.length (builtins.attrNames instances);
        message = "Paperclip system instances require distinct service users.";
      }
      {
        assertion = lib.all (c: builtins.match "[a-z][a-z0-9_-]{0,46}" c.user != null) (
          builtins.attrValues instances
        );
        message = "Paperclip service users must be safe SQL/system identifiers of at most 47 characters.";
      }
      {
        assertion =
          builtins.length (lib.unique (map databaseName (builtins.attrNames localDatabases)))
          == builtins.length (builtins.attrNames localDatabases);
        message = "Paperclip local PostgreSQL database names must be distinct after identifier normalization.";
      }
      {
        assertion = lib.all (c: c.database.mode == "postgres") (builtins.attrValues localDatabases);
        message = "Paperclip local PostgreSQL provisioning requires database.mode = postgres.";
      }
    ];
    services.postgresql = lib.mkIf (localDatabases != { }) {
      enable = true;
      ensureDatabases = map databaseName (builtins.attrNames localDatabases);
      ensureUsers = lib.concatMap (c: [
        { name = c.user; }
        { name = migrationRole c; }
      ]) (builtins.attrValues localDatabases);
      authentication = lib.mkBefore (
        lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            name: c: "local ${databaseName name} ${c.user},${migrationRole c} peer map=paperclip-${name}"
          ) localDatabases
        )
      );
      identMap = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: c: ''
          paperclip-${name} ${c.user} ${c.user}
          paperclip-${name} ${c.user} ${migrationRole c}
        '') localDatabases
      );
    };
    users.users = lib.mapAttrs' (
      name: c:
      lib.nameValuePair c.user {
        isSystemUser = true;
        group = c.user;
        home = c.stateDir;
      }
    ) instances;
    users.groups = lib.mapAttrs' (_: c: lib.nameValuePair c.user { }) instances;
    systemd.tmpfiles.rules = lib.mapAttrsToList (
      _: c: "d ${c.stateDir} 0700 ${c.user} ${c.user} -"
    ) instances;
    systemd.services =
      (lib.mapAttrs' (
        name: c:
        lib.nameValuePair "paperclip-${name}" {
          description = "Paperclip (${name})";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network-online.target"
          ]
          ++ lib.optional c.database.local.enable "paperclip-${name}-database.service";
          wants = [ "network-online.target" ];
          requires = lib.optional c.database.local.enable "paperclip-${name}-database.service";
          preStart = lib.optionalString c.database.local.enable ''
            printf '%s\n' 'postgresql://${c.user}@localhost:${toString config.services.postgresql.settings.port}/${databaseName name}?host=/run/postgresql' > /run/paperclip-${name}/database-url
            printf '%s\n' 'postgresql://${migrationRole c}@localhost:${toString config.services.postgresql.settings.port}/${databaseName name}?host=/run/postgresql' > /run/paperclip-${name}/migration-url
          '';
          path = c.extraPackages;
          restartTriggers = [
            (render name c).configFile
            (render name c).descriptorFile
          ];
          serviceConfig = {
            Type = "simple";
            User = c.user;
            Group = c.user;
            ExecStart = "${c.package}/bin/paperclip-deployment ${(render name c).descriptorFile}";
            WorkingDirectory = c.stateDir;
            RuntimeDirectory = "paperclip-${name}";
            RuntimeDirectoryMode = "0700";
            # Keep nonsecret peer-connection files available to offline apply after
            # an explicit stop. They are recreated at the next boot/start.
            RuntimeDirectoryPreserve = if c.database.local.enable then "yes" else "no";
            Environment = [
              "XDG_RUNTIME_DIR=/run/paperclip-${name}"
              "HOME=${c.stateDir}"
            ];
            UMask = "0077";
            Restart = "on-failure";
            RestartSec = 5;
            KillMode = "mixed";
            TimeoutStopSec = 120;
            ProtectSystem = "strict";
            ProtectHome = true;
            # Read-only mounts do not prevent reading workspaces or connecting
            # to privileged Unix sockets. These paths are hidden, not read-only.
            InaccessiblePaths =
              (map (p: "-${p}") [
                "/run/docker.sock"
                "/run/containerd"
                "/run/podman"
                "/run/libvirt"
                "/nix/var/nix/daemon-socket"
              ])
              ++ c.inaccessiblePaths;
            PrivateTmp = true;
            ReadWritePaths = [ c.stateDir ] ++ lib.optional (c.database.dataDir != null) c.database.dataDir;
            NoNewPrivileges = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
            RestrictSUIDSGID = true;
            LockPersonality = true;
            CapabilityBoundingSet = "";
            MemoryMax = c.memoryMax;
            TasksMax = c.tasksMax;
          };
        }
      ) instances)
      // (lib.mapAttrs' (
        name: c:
        lib.nameValuePair "paperclip-${name}-database" {
          description = "Paperclip (${name}) PostgreSQL role grants";
          after = [ "postgresql-setup.service" ];
          requires = [ "postgresql-setup.service" ];
          environment.PGPORT = toString config.services.postgresql.settings.port;
          serviceConfig = {
            Type = "oneshot";
            User = "postgres";
            RemainAfterExit = true;
          };
          script = ''
            ${config.services.postgresql.package}/bin/psql -v ON_ERROR_STOP=1 -d postgres <<'SQL'
            ALTER DATABASE "${databaseName name}" OWNER TO "${migrationRole c}";
            REVOKE ALL ON DATABASE "${databaseName name}" FROM PUBLIC;
            GRANT CONNECT ON DATABASE "${databaseName name}" TO "${c.user}";
            SQL
            ${config.services.postgresql.package}/bin/psql -v ON_ERROR_STOP=1 -d '${databaseName name}' <<'SQL'
            REVOKE CREATE ON SCHEMA public FROM PUBLIC;
            GRANT USAGE ON SCHEMA public TO "${c.user}";
            ALTER DEFAULT PRIVILEGES FOR ROLE "${migrationRole c}" GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO "${c.user}";
            ALTER DEFAULT PRIVILEGES FOR ROLE "${migrationRole c}" GRANT USAGE, SELECT ON SEQUENCES TO "${c.user}";
            ALTER DEFAULT PRIVILEGES FOR ROLE "${migrationRole c}" GRANT USAGE ON SCHEMAS TO "${c.user}";
            SQL
          '';
        }
      ) localDatabases);
    networking.firewall.allowedTCPPorts = map (c: c.port) (
      builtins.attrValues (lib.filterAttrs (_: c: c.openFirewall) instances)
    );
  };
}
