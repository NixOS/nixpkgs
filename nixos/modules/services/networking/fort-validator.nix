{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.networking.fort-validator;
in
{
  options = {
    services.networking.fort-validator = {
      enable = mkEnableOption "FORT Validator";

      acceptArinRpa = mkOption {
        type = types.bool;
        default = false;
        description = ''
          By enabling this option you agree to be bound by
          the <link xlink:href="https://www.arin.net/resources/manage/rpki/rpa.pdf">ARIN RPA</link>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users = {
      users.fort-validator = {
        name = "fort-validator";
        group = "fort-validator";
        isSystemUser = true;
        description = "FORT Validator user";
      };

      groups.fort-validator = { };
    };

    systemd = {
      services = {
        init-fort-tals = {
          description = "Create and download RPKI TALs for FORT.";

          wantedBy = [ "multi-user.target" ];
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];

          serviceConfig = {
            Type = "oneshot";
            User = "fort-validator";
            Group = "fort-validator";
          };

          script =
            let
              rpaResult = if cfg.acceptArinRpa then "yes" else "no";
            in
            ''
              TALS_DIR="/var/lib/fort/tals"
              if [ ! -d "$TALS_DIR" ]; then
                  mkdir -p "$TALS_DIR"
                  printf '${rpaResult}\n' | ${pkgs.fort-validator}/bin/fort --init-tals --tal "$TALS_DIR"
              else
                  echo "skipping: TALs already loaded"
              fi
            '';
        };

        fort-validator = {
          description = "FORT Validator";

          wantedBy = [ "multi-user.target" ];
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];

          path = [ pkgs.rsync ];

          serviceConfig = {
            User = "fort-validator";
            Group = "fort-validator";
            ReadWritePaths = "/var/lib/fort";
            ExecStart = "${pkgs.fort-validator}/bin/fort --tal /var/lib/fort/tals --local-repository /var/lib/fort/cache --server.address \"127.0.0.1,::1\" --server.port 3323";
            ExecReload = "${pkgs.coreutils}/bin/kill -SIGHUP $MAINPID";
            KillSignal = "SIGINT";
            TimeoutStopSec = "30s";
            Restart = "always";

            # Hardening
            CapabilityBoundingSet = "";
            DeviceAllow = "";
            IPAddressDeny = [ "" ];
            KeyringMode = "private";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            NotifyAccess = "none";
            ProcSubset = "pid";
            RemoveIPC = true;

            PrivateDevices = true;
            PrivateMounts = true;
            PrivateNetwork = "no";
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
            RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;

            # requires the ipc syscall in order to not crash
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
      };

      tmpfiles.rules = [
        "d /var/lib/fort 0755 fort-validator fort-validator - -"
        "z /var/lib/fort 0755 fort-validator fort-validator - -"
      ];
    };
  };
}
