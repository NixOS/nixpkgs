{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.powerManagment.powertop;
in {
  ###### interface

  options.powerManagment.powertop.enable = mkEnableOption "powertop auto tuning on startup";

  ###### implementation

  config = mkIf (cfg.enable) {
    systemd.services = {
      powertop = {
        wantedBy = [ "multi-user.target" ];
        description = "Powertop tunings";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
        };
      };
    };
  };
}
