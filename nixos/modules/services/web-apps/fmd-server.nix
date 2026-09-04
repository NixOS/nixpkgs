{
  lib,
  pkgs,
  config,
  ...
}:
let
  format = pkgs.formats.yaml { };
  cfg = config.services.fmd-server;
  settingsFile = format.generate "fmd-server-config.yml" cfg.settings;
in
{
  options.services.fmd-server = {
    enable = lib.mkEnableOption "FMD server";
    package = lib.mkPackageOption pkgs "fmd-server" { };
    environmentFile = lib.mkOption {
      description = ''
        Path to a file containing environment variables.

        Use this option to pass secrets.
      '';
      default = "";
      type = lib.types.oneOf [
        lib.types.path
        lib.types.str
      ];
    };
    settings = lib.mkOption {
      description = ''
        Configuration for the FMD server.

        See [the documentation](https://fmd-foss.org/docs/fmd-server/installation/configuration)
        for more information.

        Use {option}`services.fmd-server.environmentFile` to specify secrets.
      '';
      default = { };
      type = format.type;
    };
    databaseDir = lib.mkOption {
      description = ''
        Path to a directory where the database should be stored.
      '';
      default = "/var/lib/fmd-server/db/";
      type = lib.types.str;
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.fmd-server = {
      description = "FMD Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} serve --config ${settingsFile} --db-dir ${cfg.databaseDir}";
        Restart = "always";
        DynamicUser = true;
        RuntimeDirectory = "fmd-server";
        RuntimeDirectoryMode = "0770";
        StateDirectory = "fmd-server";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != "") cfg.environmentFile;
        # Hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = "";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    ungeskriptet
  ];
}
