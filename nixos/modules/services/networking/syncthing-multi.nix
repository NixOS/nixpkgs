{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.syncthing-multi;
  inherit (lib) types;
in
{
  options.services.syncthing-multi = {
    enable = lib.mkEnableOption "Syncthing";

    package = lib.mkPackageOption pkgs "syncthing" { };

    instances = lib.mkOption {
      description = ''
        Syncthing instances to run.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule (
          let
            globalConfig = config;
          in
          { name, config, ... }:
          {
            options = {
              settings = lib.mkOption {
                type =
                  let
                    simples = [
                      types.bool
                      types.str
                      types.int
                      types.float
                    ];
                  in
                  types.attrsOf (
                    types.oneOf (
                      simples
                      ++ [
                        (types.listOf (types.oneOf simples))
                      ]
                    )
                  );
                default = { };
                example = {
                  gui-address = "localhost:8000";
                };
                description = ''
                  Settings that should be passed to Syncthing via long options.
                  See {manpage}`syncthing(1)` for available options.
                '';
              };

              user = lib.mkOption {
                type = types.str;
                default = name;
                defaultText = "<name>";
                description = ''
                  The name of an existing user account under which the Syncthing process should run.
                  If the name of the user is "syncthing", then an account will be created automatically.
                '';
              };

              group = lib.mkOption {
                type = types.nullOr types.str;
                default = null;
                description = ''
                  The name of an existing user group under which the Syncthing process should run.
                  If the name of the group is "syncthing", then a group will be created automatically.
                '';
              };

              workDir = lib.mkOption {
                type = types.str;
                default = globalConfig.users.users.${config.user}.home;
                defaultText = ''
                  The user's home directory.
                '';
                description = ''
                  The working directory of the Syncthing process.
                '';
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = lib.mkMerge (
      lib.mapAttrsToList (
        instanceName: instance:
        let
          systemdName = "syncthing-${instanceName}";
        in
        {
          ${systemdName} = {
            description = "Syncthing instance ${instanceName}";

            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];

            environment = {
              STNORESTART = "yes";
              STNOUPGRADE = "yes";
            };

            serviceConfig = {
              Type = "simple";

              User = instance.user;
              Group = lib.mkIf (instance.group != null) instance.group;

              WorkingDirectory = instance.workDir;

              ExecStart =
                let
                  settingsToCommandLine = lib.cli.toCommandLineGNU {
                    isLong = _: true;
                  };
                in
                utils.escapeSystemdExecArgs (
                  [
                    (lib.getExe cfg.package)
                    "serve"
                    "--no-browser"
                  ]
                  ++ settingsToCommandLine instance.settings
                );

              MemoryDenyWriteExecute = true;
              NoNewPrivileges = true;
              PrivateDevices = true;
              PrivateMounts = true;
              PrivateTmp = true;
              PrivateUsers = true;
              ProtectControlGroups = true;
              ProtectHostname = true;
              ProtectKernelModules = true;
              ProtectKernelTunables = true;
              RestrictNamespaces = true;
              RestrictRealtime = true;
              RestrictSUIDSGID = true;
              CapabilityBoundingSet = [
                "~CAP_SYS_PTRACE"
                "~CAP_SYS_ADMIN"
                "~CAP_SETGID"
                "~CAP_SETUID"
                "~CAP_SETPCAP"
                "~CAP_SYS_TIME"
                "~CAP_KILL"
              ];
            };
          };
        }
      ) cfg.instances
    );

    users = lib.mkMerge (
      lib.mapAttrsToList (instanceName: instance: {
        users = lib.mkIf (instance.user == "syncthing") {
          syncthing = {
            group = "syncthing";
            home = "/var/lib/syncthing";
            createHome = true;
            uid = config.ids.uids.syncthing;
            description = "Syncthing service user";
          };
        };

        groups =
          lib.mkIf (instance.group == "syncthing" || (instance.group == null && instance.user == "syncthing"))
            {
              syncthing.gid = config.ids.gids.syncthing;
            };
      }) cfg.instances
    );
  };
}
