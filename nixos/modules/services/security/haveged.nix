{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.haveged;

in


{

  ###### interface

  options = {

    services.haveged = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable to haveged entropy daemon, which refills
          /dev/random when low.
        '';
      };

      refill_threshold = mkOption {
        type = types.int;
        default = 1024;
        description = ''
          The number of bits of available entropy beneath which
          haveged should refill the entropy pool.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.haveged =
      { description = "Entropy Harvesting Daemon";
        unitConfig.Documentation = "man:haveged(8)";
        wantedBy = [ "multi-user.target" ];

        path = [ pkgs.haveged ];

        serviceConfig = {
          ExecStart = "${pkgs.haveged}/bin/haveged -F -w ${toString cfg.refill_threshold} -v 1";
          SuccessExitStatus = 143;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateNetwork = true;
          ProtectSystem = "full";
          ProtectHome = true;
        };
      };

  };

}
