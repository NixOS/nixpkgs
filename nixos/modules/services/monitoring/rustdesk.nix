{ config, lib, pkgs, ... }:

let

  cfg = config.services.rustdesk;

in {

  options = {

    services.rustdesk.enable = lib.mkEnableOption "Rustdesk daemon";
    services.rustdesk.package = lib.mkPackageOption pkgs "rustdesk" { };
    services.rustdesk = {
      user = lib.mkOption {
        type = lib.types.str;
        default = "rustdesk";
        description = ''
          rustdesk User.
        '';
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = "rustdesk";
        description = ''
          rustdesk group. Users who want to use `rustdesk` need to be part of this group.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { gid = config.ids.gids.rustdesk; };
    users.users.${cfg.user} = {
      description = "Rustdesk user";
      uid = config.ids.uids.rustdesk;
      group = cfg.group;
    };
    systemd.services.rustdesk = {
      enable = true;
      description = "rustdesk";
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --service";
        ExecStop = "{pkgs.coreutils}/bin/kill -9 $(cat /run/rustdesk.pid)";
        PIDFile = "/run/rustdesk.pid";
        KillMode = "mixed";
        TimeoutStopSec = "30";
        LimitNOFILE = "100000";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "";
        StateDirectory = "";
        StateDirectoryMode = "0770";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        PrivateTmp = "yes";
        RemoveIPC = "yes";
      };
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];
      after = [ "display-manager.service" ];
    };
  };
}
