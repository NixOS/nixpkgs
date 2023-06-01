{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.frp-client;
  settingsFormat = pkgs.formats.ini { };
in
{
  options = {
    services.frp-client = {
      enable = mkEnableOption (lib.mdDoc "frp client configuration");

      package = mkPackageOptionMD pkgs "frp" { };

      settings = mkOption {
        type = settingsFormat.type;
        default = { };
        description = lib.mdDoc ''
          frp client configuration, for configuration options see the example on [github](https://github.com/fatedier/frp/blob/dev/conf/frpc_full.ini)
        '';
        example = literalExpression ''
          {
            common = {
              server_addr = "x.x.x.x";
              server_port = 7000;
            };
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc."frpc.ini".source = settingsFormat.generate "frpc.ini" cfg.settings;
    };
    systemd.services = {
      frp-client = {
        wants = [ "network.target" ];
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "frp client";
        serviceConfig = {
          DynamicUser = true;
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 15;
          ExecStart = "${cfg.package}/bin/frpc -c /etc/frpc.ini";
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
          RestrictAddressFamilies = [ "AF_UNIX" "AF_INET AF_INET6" ];
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
