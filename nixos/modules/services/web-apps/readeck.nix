{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.readeck;
in
{
  options = {
    services.readeck = {
      enable = mkEnableOption "Readeck";

      package = mkPackageOption pkgs "readeck" { };

      configFile = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Path to file containing config.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.readeck = {
      description = "Readeck";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        StateDirectory = "readeck";
        LoadCredential = "config:${cfg.configFile}";
        WorkingDirectory = "/var/lib/readeck";
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} serve -config \${CREDENTIALS_DIRECTORY}/config";
        ProtectSystem = "full";
        SystemCallArchitectures = "native";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        DevicePolicy = "closed";
        ProtectClock = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        LockPersonality = true;
        Restart = "on-failure";
      };
    };
  };
}
