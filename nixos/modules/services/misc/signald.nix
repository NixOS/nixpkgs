{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.signald;
  dataDir = "/var/lib/signald";
  defaultUser = "signald";
in
{
  options.services.signald = {
    enable = mkEnableOption "the signald service";

    user = mkOption {
      type = types.str;
      default = defaultUser;
      description = lib.mdDoc "User under which signald runs.";
    };

    group = mkOption {
      type = types.str;
      default = defaultUser;
      description = lib.mdDoc "Group under which signald runs.";
    };

    socketPath = mkOption {
      type = types.str;
      default = "/run/signald/signald.sock";
      description = lib.mdDoc "Path to the signald socket";
    };
  };

  config = mkIf cfg.enable {
    users.users = optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == defaultUser) {
      ${defaultUser} = { };
    };

    systemd.services.signald = {
      description = "A daemon for interacting with the Signal Private Messenger";
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.signald}/bin/signald -d ${dataDir} -s ${cfg.socketPath}";
        Restart = "on-failure";
        StateDirectory = "signald";
        RuntimeDirectory = "signald";
        StateDirectoryMode = "0750";
        RuntimeDirectoryMode = "0750";

        BindReadOnlyPaths = [
          "/nix/store"
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
        ];
        CapabilityBoundingSet = "";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        # Use a static user so other applications can access the files
        #DynamicUser = true;
        LockPersonality = true;
        # Needed for java
        #MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        # Needs network access
        #PrivateNetwork = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        # Would re-mount paths ignored by temporary root
        #ProtectSystem = "strict";
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged @resources @setuid @keyring" ];
        TemporaryFileSystem = "/:ro";
        # Does not work well with the temporary root
        #UMask = "0066";
      };
    };
  };
}
