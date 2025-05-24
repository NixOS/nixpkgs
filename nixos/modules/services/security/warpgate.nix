{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.warpgate;
in
{
  options.services.warpgate =
    let
      inherit (lib.types) str bool;
      inherit (lib.options) mkOption mkPackageOption;
    in
    {
      enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to enable Warpgate.
          This module will initialize Warpgate config automatically. Please run `warpgate recover-access` to gain access.
        '';
      };

      package = mkPackageOption pkgs "warpgate" { };

      stateDir = mkOption {
        type = str;
        default = "warpgate";
        description = ''
          Directory below `/var/lib/private` to store Warpgate config files and session recordings.
          This directory will be created automatically using systemd’s StateDirectory mechanism.
        '';
      };

      configFile = mkOption {
        type = str;
        default = "/var/lib/warpgate/warpgate.yml";
        description = "Path to Warpgate configuration file. Please supply your own after adapting the module initialized one to your need.";
      };

      bindOnPrivilegedPorts = mkOption {
        type = bool;
        default = false;
        description = "Set to true if you are binding listeners on privilege ports. For example, binding HTTP endpoint on 443.";
      };
    };

  config =
    let
      preStartScript = pkgs.writers.writeBash "warpgate-dbinit" ''
        CFGFILE=${cfg.configFile}
        INITPWD=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 16)
        if [ -O $CFGFILE ] && [ -s $CFGFILE ]; then
          exit 0
        else
          ${lib.getExe cfg.package} --config $CFGFILE unattended-setup --data-path /var/lib/${cfg.stateDir} --http-port 8888 --admin-password $INITPWD
        fi
      '';
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      systemd.services.warpgate = {
        description = "Warpgate smart bastion";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        startLimitBurst = 5;
        serviceConfig =
          {
            ExecStartPre = preStartScript;
            ExecStart = "${lib.getExe cfg.package} --config ${cfg.configFile} run";
            DynamicUser = true;
            RestartSec = 3;
            Restart = "on-failure";
            StateDirectory = cfg.stateDir;
            StateDirectoryMode = "0700";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectHome = true;
            PrivateDevices = true;
            DeviceAllow = [
              "/dev/null rw"
              "/dev/urandom r"
            ];
            DevicePolicy = "strict";
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            RestrictNamespaces = true;
            ProtectProc = "invisible";
            ProtectSystem = "full";
            ProtectClock = true;
            ProtectControlGroups = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            RemoveIPC = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
            ];
          }
          // (
            if (cfg.bindOnPrivilegedPorts) then
              {
                AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
                CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
              }
            else
              {
                PrivateUsers = true;
              }
          );
      };
    };

  meta.maintainers = with lib.maintainers; [ alemonmk ];
}
