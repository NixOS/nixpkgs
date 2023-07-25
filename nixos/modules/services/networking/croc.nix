{ config, lib, pkgs, ... }:
let
  inherit (lib) types;
  cfg = config.services.croc;
  rootDir = "/run/croc";
in
{
  options.services.croc = {
    enable = lib.mkEnableOption (lib.mdDoc "croc relay");
    ports = lib.mkOption {
      type = with types; listOf port;
      default = [9009 9010 9011 9012 9013];
      description = lib.mdDoc "Ports of the relay.";
    };
    pass = lib.mkOption {
      type = with types; either path str;
      default = "pass123";
      description = lib.mdDoc "Password or passwordfile for the relay.";
    };
    openFirewall = lib.mkEnableOption (lib.mdDoc "opening of the peer port(s) in the firewall");
    debug = lib.mkEnableOption (lib.mdDoc "debug logs");
  };

  config = lib.mkIf cfg.enable {
    systemd.services.croc = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.croc}/bin/croc --pass '${cfg.pass}' ${lib.optionalString cfg.debug "--debug"} relay --ports ${lib.concatMapStringsSep "," toString cfg.ports}";
        # The following options are only for optimizing:
        # systemd-analyze security croc
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DynamicUser = true;
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateNetwork = lib.mkDefault false;
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
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RootDirectory = rootDir;
        # Avoid mounting rootDir in the own rootDir of ExecStart='s mount namespace.
        InaccessiblePaths = [ "-+${rootDir}" ];
        BindReadOnlyPaths = [
          builtins.storeDir
        ] ++ lib.optional (types.path.check cfg.pass) cfg.pass;
        # This is for BindReadOnlyPaths=
        # to allow traversal of directories they create in RootDirectory=.
        UMask = "0066";
        # Create rootDir in the host's mount namespace.
        RuntimeDirectory = [(baseNameOf rootDir)];
        RuntimeDirectoryMode = "700";
        SystemCallFilter = [
          "@system-service"
          "~@aio" "~@keyring" "~@memlock" "~@privileged" "~@setuid" "~@sync" "~@timer"
        ];
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall cfg.ports;
  };

  meta.maintainers = with lib.maintainers; [ hax404 julm ];
}
