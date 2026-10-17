{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.windscribe;
in
{
  options.services.windscribe = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable the Windscribe VPN client daemon and system integration.

        ::: {.note}
        Users must be in the "windscribe" group to communicate with the helper socket:
        `users.users.<name>.extraGroups = [ "windscribe" ];`
        :::
      '';
    };

    package = lib.mkPackageOption pkgs "windscribe" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.groups.windscribe = { };

    users.users.windscribe = {
      isSystemUser = true;
      group = "windscribe";
      description = "Windscribe daemon user";
      home = "/var/lib/windscribe";
    };

    systemd.services.windscribe-helper = {
      description = "Windscribe helper service";
      before = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe' cfg.package "windscribe-helper"}";
        ExecStopPost = "-${lib.getExe' cfg.package "windscribe-helper"} --reset-mac-addresses";
        Restart = "on-failure";
        RestartSec = 2;
        Group = "windscribe";
        RuntimeDirectory = "windscribe amneziawg";
        RuntimeDirectoryMode = "0775";
        LogsDirectory = "windscribe";
        LogsDirectoryMode = "0775";
        StateDirectory = "windscribe";
        StateDirectoryMode = "0770";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ aliheidary1381 ];
}
