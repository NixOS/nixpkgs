{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.bloop;

in {

  options.services.bloop = {
    install = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to install a user service for the Bloop server.

        The service must be manually started for each user with
        "systemctl --user start bloop".
      '';
    };
  };

  config = mkIf (cfg.install) {
    systemd.user.services.bloop = {
      description = "Bloop Scala build server";

      environment = {
        PATH = mkForce "${makeBinPath [ config.programs.java.package ]}";
      };
      serviceConfig = {
        Type        = "simple";
        ExecStart   = ''${pkgs.bloop}/bin/bloop server'';
        Restart     = "always";
      };
    };

    environment.systemPackages = [ pkgs.bloop ];
  };
}
