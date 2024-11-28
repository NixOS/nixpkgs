{ config, pkgs, lib, ... }:
let
  cfg = config.services.lidarr;
in
{
  options = {
    services.lidarr = {
      enable = lib.mkEnableOption "Lidarr, a Usenet/BitTorrent music downloader";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/lidarr/.config/Lidarr";
        description = "The directory where Lidarr stores its data files.";
      };

      package = lib.mkPackageOption pkgs "lidarr" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Lidarr
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "lidarr";
        description = ''
          User account under which Lidarr runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "lidarr";
        description = ''
          Group under which Lidarr runs.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-lidarr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.lidarr = {
      description = "Lidarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/Lidarr -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8686 ];
    };

    users.users = lib.mkIf (cfg.user == "lidarr") {
      lidarr = {
        group = cfg.group;
        home = "/var/lib/lidarr";
        uid = config.ids.uids.lidarr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "lidarr") {
      lidarr = {
        gid = config.ids.gids.lidarr;
      };
    };
  };
}
