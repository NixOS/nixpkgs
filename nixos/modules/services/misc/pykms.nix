{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pykms;

  home = "/var/lib/pykms";

  services = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
      StartLimitInterval = "1min";
      PrivateTmp = true;
      ProtectSystem = "full";
      ProtectHome = true;
    };
  };

in {

  options = {
    services.pykms = rec {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the PyKMS service.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "The IP address on which to listen.";
      };

      port = mkOption {
        type = types.int;
        default = 1688;
        description = "The port on which to listen.";
      };

      verbose = mkOption {
        type = types.bool;
        default = false;
        description = "Show verbose output.";
      };

      openFirewallPort = mkOption {
        type = types.bool;
        default = false;
        description = "Whether the listening port should be opened automatically.";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewallPort [ cfg.port ];

    systemd.services = {
      pykms = services // {
        description = "Python KMS";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = with pkgs; {
          User = "pykms";
          Group = "pykms";
          ExecStartPre = "${getBin pykms}/bin/create_pykms_db.sh ${home}/clients.db";
          ExecStart = "${getBin pykms}/bin/server.py ${optionalString cfg.verbose "--verbose"} ${cfg.listenAddress} ${toString cfg.port}";
          WorkingDirectory = home;
          MemoryLimit = "64M";
        };
      };
    };

    users = {
      users.pykms = {
        name = "pykms";
        group = "pykms";
        home  = home;
        createHome = true;
        uid = config.ids.uids.pykms;
        description = "PyKMS daemon user";
      };

      groups.pykms = {
        gid = config.ids.gids.pykms;
      };
    };
  };
}
