{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.brltty;
  
  stateDir = "/run/brltty";

  pidFile = "${stateDir}/brltty.pid";

in {

  options = {

    services.brltty.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the BRLTTY daemon.";
    };

  };

  config = mkIf cfg.enable {

    systemd.services.brltty = {
      description = "Braille console driver";
      preStart = ''
        mkdir -p ${stateDir}
      '';
      serviceConfig = {
        ExecStart = "${pkgs.brltty}/bin/brltty --pid-file=${pidFile}";
        Type = "forking";
        PIDFile = pidFile;
      };
      before = [ "sysinit.target" ];
      wantedBy = [ "sysinit.target" ];
    };

  };

}
