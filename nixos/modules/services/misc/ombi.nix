{ config, pkgs, lib, ... }:
let cfg = config.services.ombi;

in {
  options = {
    services.ombi = {
      enable = lib.mkEnableOption ''
        Ombi, a web application that automatically gives your shared Plex or
        Emby users the ability to request content by themselves!

        Optionally see <https://docs.ombi.app/info/reverse-proxy>
        on how to set up a reverse proxy
      '';

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/ombi";
        description = "The directory where Ombi stores its data files.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5000;
        description = "The port for the Ombi web interface.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Ombi web interface.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "ombi";
        description = "User account under which Ombi runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "ombi";
        description = "Group under which Ombi runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.ombi = {
      description = "Ombi";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${pkgs.ombi}/bin/Ombi --storage '${cfg.dataDir}' --host 'http://*:${toString cfg.port}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users = lib.mkIf (cfg.user == "ombi") {
      ombi = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = lib.mkIf (cfg.group == "ombi") { ombi = { }; };
  };
}
