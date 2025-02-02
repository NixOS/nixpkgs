{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ydotool;
in
{
  meta = {
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };

  options.programs.ydotool = {
    enable = lib.mkEnableOption ''
      ydotoold system service and install ydotool.
      Add yourself to the 'ydotool' group to be able to use it.
    '';
  };

  config = lib.mkIf cfg.enable {
    users.groups.ydotool = { };

    systemd.services.ydotoold = {
      description = "ydotoold - backend for ydotool";
      wantedBy = [ "multi-user.target" ];
      partOf = [ "multi-user.target" ];
      serviceConfig = {
        Group = "ydotool";
        RuntimeDirectory = "ydotoold";
        RuntimeDirectoryMode = "0750";
        ExecStart = "${lib.getExe' pkgs.ydotool "ydotoold"} --socket-path=/run/ydotoold/socket --socket-perm=0660";

        # hardening

        ## allow access to uinput
        DeviceAllow = [ "/dev/uinput" ];
        DevicePolicy = "closed";

        ## allow creation of unix sockets
        RestrictAddressFamilies = [ "AF_UNIX" ];

        CapabilityBoundingSet = "";
        IPAddressDeny = "any";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateNetwork = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProtectUser = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";

        # -> systemd-analyze security score 0.7 SAFE 😀
      };
    };

    environment.variables = {
      YDOTOOL_SOCKET = "/run/ydotoold/socket";
    };
    environment.systemPackages = with pkgs; [ ydotool ];
  };
}
