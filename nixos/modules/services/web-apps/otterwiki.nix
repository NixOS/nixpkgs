{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.otterwiki;
  mapToUnits = f: lib.mapAttrs' (name: inst: lib.nameValuePair inst.process.unit (f inst));
  secretKeyFile = inst: "/var/lib/${inst.process.unit}/secret.cfg";

  gunicornInstanceOptions =
    { config, ... }@moduleArgs:
    lib.recursiveUpdate (import ../web-servers/gunicorn/instance-options.nix moduleArgs) {
      options.process.unit.default = "otterwiki-${config._module.args.name}";
    };

  instanceOptions =
    { config, ... }@moduleArgs:
    {
      options = {
        inherit ((gunicornInstanceOptions moduleArgs).options) process socket;

        package = lib.mkPackageOption pkgs "otterwiki" { };

        repository = lib.mkOption {
          type = lib.types.str;
          default = "/var/lib/${config.process.unit}/repository";
          description = ''
            Path to the Git repository for the wiki content.

            If this path is outside of the service's private data directory,
            it is also necessary to also add it to
            `systemd.services.''${config.process.unit}.serviceConfig.BindPaths`.
          '';
        };

        databaseUri = lib.mkOption {
          type = lib.types.str;
          default = "sqlite:////var/lib/${config.process.unit}/db.sqlite";
          description = ''
            SQLAlchemy database connection URI.
            Defaults to using an independent SQLite database.

            If using a file or UNIX socket outside of the service's private data directory,
            it is also necessary to also add it to
            `systemd.services.''${config.process.unit}.serviceConfig.BindPaths`.
          '';
        };

        settings = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          example = {
            SITE_NAME = "Otterwiki";
          };
          description = ''
            Configuration for Otter Wiki.
            See <https://otterwiki.com/Configuration>.

            A cookie secret is automatically generated at first start.
          '';
        };

        environmentFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            Path to an environment file.
            This is suitable for supplying secrets such as the SMTP credentials.
          '';
        };
      };
    };

in
{
  options.services.otterwiki.instances = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule instanceOptions);
    default = { };
    description = "Configuration for instances of Otter Wiki.";
  };

  config = {
    services.gunicorn.instances = mapToUnits (inst: {
      inherit (inst) process socket;
      app.package = inst.package;
    }) cfg.instances;

    systemd.services = mapToUnits (inst: {
      environment = {
        REPOSITORY = inst.repository;
        SQLALCHEMY_DATABASE_URI = inst.databaseUri;
        OTTERWIKI_SETTINGS = secretKeyFile inst;
      }
      // inst.settings;

      path = [ pkgs.git ];

      preStart = ''
        # generate cookie secret
        if [[ ! -f ${lib.escapeShellArg (secretKeyFile inst)} ]]; then
          (
            echo -n "SECRET_KEY='"
            cat /dev/urandom | head -c128 | tr -dc A-Za-z0-9
            echo "'"
          ) > ${lib.escapeShellArg (secretKeyFile inst)}
        fi

        # init wiki repo
        if [[ ! -d ${lib.escapeShellArg inst.repository} ]]; then
          mkdir -p $(dirname ${lib.escapeShellArg inst.repository})
          git init ${lib.escapeShellArg inst.repository}
        fi
      '';

      serviceConfig = {
        EnvironmentFile = lib.mkIf (inst.environmentFile != null) inst.environmentFile;
        StateDirectory = inst.process.unit;

        StateDirectoryMode = "0700";
        UMask = "0077";

        TemporaryFileSystem = [ "/:ro" ];
        BindPaths = [ ];
        BindReadOnlyPaths = [ "/nix/store" ];

        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;

        ProtectKernelModules = true;
        SystemCallArchitectures = "native";
        PrivateMounts = true;

        LockPersonality = true;
        ProtectHostname = true;
        RestrictRealtime = true;

        ProtectSystem = "strict";
        ProtectHome = true;

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;

        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];

        # needed to bind inet sockets and send emails
        PrivateNetwork = lib.mkDefault false;

        MemoryDenyWriteExecute = true;
        PrivateUsers = true;

        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" ];

        ProtectKernelLogs = true;
        DevicePolicy = "closed";
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        RestrictNamespaces = true;
        RemoveIPC = true;
      };
    }) cfg.instances;
  };

  meta = {
    maintainers = with lib.maintainers; [ euxane ];
  };
}
