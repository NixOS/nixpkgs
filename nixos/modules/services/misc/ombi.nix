{ config, pkgs, lib, ... }:

with lib;

let cfg = config.services.ombi;

in {
  options = {
    services.ombi = {
      enable = mkEnableOption ''
        Ombi.
        Optionally see <link xlink:href="https://docs.ombi.app/info/reverse-proxy"/>
        on how to set up a reverse proxy
      '';

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/ombi";
        description = lib.mdDoc "The directory where Ombi stores its data files.";
      };

      port = mkOption {
        type = types.port;
        default = 5000;
        description = lib.mdDoc "The port for the Ombi web interface.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for the Ombi web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "ombi";
        description = lib.mdDoc "User account under which Ombi runs.";
      };

      group = mkOption {
        type = types.str;
        default = "ombi";
        description = lib.mdDoc "Group under which Ombi runs.";
      };
    };
  };

  config = mkIf cfg.enable {
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

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users = mkIf (cfg.user == "ombi") {
      ombi = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = mkIf (cfg.group == "ombi") { ombi = { }; };
  };
}
