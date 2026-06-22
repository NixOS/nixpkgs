#v Non-module dependencies (`importApply`)
{ pkgs }:

# Service module
{
  lib,
  options,
  config,
  ...
}:
let
  cfg = config.autoconnect;
  tomlFmt = pkgs.formats.toml { };
in
{
  _class = "service";
  options = {
    package = lib.mkPackageOption pkgs "autopush-rs.out" { };
    autoconnect.settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = tomlFmt.type;
        options = {
          db_dsn = lib.mkOption {
            description = "Endpoint of the database server.";
            type = lib.types.str;
            default = "";
            example = lib.literalExpression "redis+socket://${config.services.redis.servers.autopush-rs.unixSocket}";
          };
        };
      };
      default = { };
      description = "";
    };
  };
  config =
    let
      configFile = tomlFmt.generate "autoconnect.toml" cfg.settings;
    in
    {
      process.argv = [
        "${config.package}/bin/autoconnect"
        "-c"
        (toString configFile)
      ];
    }
    // lib.optionalAttrs (options ? systemd) {
      systemd.service = {
        after = [ "network.target" ];
        wants = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "on-failure";

          #hardening
          MemoryDenyWriteExecute = true;
          StateDirectoryMode = 0700;
          UMask = 077;
          DynamicUser = true;
          PrivateUsers = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectSystem = "full";
          ProtectHome = true;
          NoNewPrivileges = true;
          RuntimeDirectoryMode = 755;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictNamespaces = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          SystemCallArchitectures = "native";

          ProtectProc = "invisible";
          ProcSubset = "pid";

          SystemCallFilter = [
            "~@clock"
            "~@cpu-emulation"
            "~@debug"
            "~@module"
            "~@mount"
            "~@obsolete"
            "~@raw-io"
            "~@reboot"
            "~@swap"
          ];
        };
      };
    };
}
