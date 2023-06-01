{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.frp-server;
  settingsFormat = pkgs.formats.ini { };
in
{
  options = {
    services.frp-server = {
      enable = mkEnableOption (lib.mdDoc "frp server configuration");

      package = mkPackageOptionMD pkgs "frp" { };

      settings = mkOption {
        type = settingsFormat.type;
        default = { };
        description = lib.mdDoc ''
          frp server configuration, for configuration options see the example on [github](https://github.com/fatedier/frp/blob/dev/conf/frps_full.ini)
          note that you have to do the firewall configuration manually
        '';
        example = literalExpression ''
          {
            common = {
              bind_port = 7000;
            };
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc."frps.ini".source = settingsFormat.generate "frps.ini" cfg.settings;
    };
    systemd.services = {
      frp-server = {
        wants = [ "network.target" ];
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "frp server";
        serviceConfig = {
          DynamicUser = true;
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 15;
          ExecStart = "${cfg.package}/bin/frps -c /etc/frps.ini";
          StateDirectoryMode = "0700";
          UMask = "0007";
          CapabilityBoundingSet = "";
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_INET AF_INET6" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "~@clock @privileged @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @reboot @setuid @swap";
          BindReadOnlyPaths = [
            "-/etc/resolv.conf"
            "-/etc/nsswitch.conf"
            "-/etc/ssl/certs"
            "-/etc/static/ssl/certs"
            "-/etc/hosts"
            "-/etc/localtime"
          ];
        };
      };
    };
  };
}
