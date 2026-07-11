{ ... }:
{
  _class = "service";
  imports = [ ./default.nix ];
  config = {
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
