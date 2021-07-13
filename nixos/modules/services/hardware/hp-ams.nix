{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.hardware.hp-ams;

  fake-dpkg-query = pkgs.writeScriptBin "dpkg-query" ''
    #!${pkgs.runtimeShell}
    # returns nothing for now
  '';
in
{
  options = {
    services.hardware.hp-ams = {
      enable = mkEnableOption "HP Agentless Management Service";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hp-ams = {
      description = "HP Agentless Management Service for ProLiant";
      wantedBy = [ "multi-user.target" ];

      path = [ fake-dpkg-query ];

      serviceConfig = {
        ExecStart = "${pkgs.hp-ams}/sbin/amsHelper -I0 -L -f";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";

        Restart = "on-failure";
        RestartSec = "15s";

        # Hardening
        CapabilityBoundingSet = "CAP_SYS_ADMIN";
        DevicePolicy = "closed";
        DeviceAllow = [
          "char-hpilo"
          "char-ipmidev"
        ];
        IPAddressDeny = "any";
        KeyringMode = "private";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        NotifyAccess = "none";
        ProcSubset = "all";
        RemoveIPC = true;

        PrivateDevices = false;
        PrivateMounts = true;
        PrivateNetwork = false;
        PrivateTmp = true;
        PrivateUsers = false;

        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = "";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        SystemCallFilter = [
          "@system-service"
          "~@aio"
          "~@clock"
          "~@cpu-emulation"
          "~@chown"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@module"
          "~@mount"
          "~@raw-io"
          "~@reboot"
          "~@swap"
          "~@privileged"
          "~@resources"
          "~@setuid"
          "~@sync"
          "~@timer"
        ];
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
      };
    };

    # fake this for amsHelper, otherwise it will segfault
    environment.etc."debian_version".text = "10.9";
  };
}
