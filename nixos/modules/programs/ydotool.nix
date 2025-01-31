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
      ydotoold system service and {command}`ydotool` for members of
      {option}`programs.ydotool.group`.
    '';
    group = lib.mkOption {
      type = lib.types.str;
      default = "ydotool";
      description = ''
        Group which users must be in to use {command}`ydotool`.
      '';
    };
  };

  config = let
    runtimeDirectory = "ydotoold";
  in lib.mkIf cfg.enable {
    users.groups."${config.programs.ydotool.group}" = { };

    systemd.services.ydotoold = {
      description = "ydotoold - backend for ydotool";
      wantedBy = [ "multi-user.target" ];
      partOf = [ "multi-user.target" ];
      serviceConfig = {
        Group = config.programs.ydotool.group;
        RuntimeDirectory = runtimeDirectory;
        RuntimeDirectoryMode = "0750";
        ExecStart = "${lib.getExe' pkgs.ydotool "ydotoold"} --socket-path=${config.environment.variables.YDOTOOL_SOCKET} --socket-perm=0660";

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
      YDOTOOL_SOCKET = "/run/${runtimeDirectory}/socket";
    };
    environment.systemPackages = with pkgs; [ ydotool ];
  };
}
