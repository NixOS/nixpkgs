{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.security.sgx;
in
{
  options.security.sgx = {
    enable = mkEnableOption "Intel SGX";

    config = mkOption {
      type = types.lines;
      default = "";
      description = "Configuration for the SGX daemon.";
    };

    packages = {
      psw = mkOption {
        default = pkgs.intel-sgx-psw;
        defaultText = "pkgs.intel-sgx-psw";
        description = "The SGX PSW (platform software) package to use.";
      };

      sdk = mkOption {
        default = pkgs.intel-sgx-sdk;
        defaultText = "pkgs.intel-sgx-sdk";
        description = "The SGX SDK (software development kit) package to use.";
      };

      driver = mkOption {
        type = types.package;
        default = pkgs.linuxPackages.isgx;
        defaultText = "pkgs.linuxPackages.isgx";
        description = "The SGX driver package to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ cfg.packages.driver ];
    services.udev.packages = [ cfg.packages.psw ];

    # aesmd depends on auditd
    security.auditd.enable = true;

    # write service config file
    environment.etc."aesmd.conf".text = cfg.config;

    # create service user and groups
    users = {
      users.aesmd = {
        group = "aesmd";
        isSystemUser = true;
        extraGroups = [ "sgx_prv" ];
        description = "Intel SGX Service Account";
      };

      groups = {
        aesmd = { };
        sgx_prv = { };
      };
    };

    systemd.services.aesmd =
      let
        path = "${cfg.packages.psw}/aesm";
      in
      {
        description = "Intel(R) Architectural Enclave Service Manager";
        after = [ "syslog.target" "network.target" "auditd.service" ];
        wantedBy = [ "multi-user.target" ];

        # restart when config file changes
        restartTriggers = [ config.environment.etc."aesmd.conf".source ];

        environment = {
          NAME = "aesm_service";
          AESM_PATH = "/var/opt/aesmd";
          LD_LIBRARY_PATH = "${cfg.packages.psw}/lib:${path}";
        };

        serviceConfig = {
          ExecStart = "${path}/aesm_service --no-daemon";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          ExecStartPre = [ "${pkgs.coreutils}/bin/mkdir -p /var/opt/aesmd/data /var/opt/aesmd/fwdir/data" ];

          Restart = "on-failure";
          RestartSec = "15s";

          # environment
          User = "aesmd";
          Group = "aesmd";

          WorkingDirectory = "/var/opt/aesmd";
          RuntimeDirectory = "aesmd";
          RuntimeDirectoryMode = "0755";
          ReadWritePaths = [ "/var/opt/aesmd" ];

          # Hardening
          CapabilityBoundingSet = "";
          DevicePolicy = "closed";
          DeviceAllow = [
            "/dev/isgx rw"
            "/dev/sgx rw"
            "/dev/sgx/enclave rw"
            "/dev/sgx/provision rw"
          ];
          IPAddressDeny = "any";
          KeyringMode = "private";
          LockPersonality = true;
          MemoryDenyWriteExecute = false;
          NoNewPrivileges = true;
          NotifyAccess = "none";
          ProcSubset = "pid";
          RemoveIPC = true;

          PrivateDevices = false;
          PrivateMounts = true;
          PrivateNetwork = false;
          PrivateTmp = true;
          PrivateUsers = true;

          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectHostname = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictAddressFamilies = [ "AF_UNIX" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;

          # needs the ipc syscall in order to run
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

    systemd.tmpfiles.rules = [
      "d /var/opt/aesmd 0750 aesmd aesmd - -"
      "z /var/opt/aesmd 0750 aesmd aesmd - -"
    ];
  };
}
