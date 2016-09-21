{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sundtek;

in
{
  options.services.sundtek = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Whether to enable Sundtek driver.";
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.sundtek ];

    systemd.services.sundtek = {
      description = "Sundtek driver";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.sundtek}/bin/mediasrv -d -v -p ${pkgs.sundtek}/bin ;\
          ${pkgs.sundtek}/bin/mediaclient --start --wait-for-devices
          '';
        ExecStop = "${pkgs.sundtek}/bin/mediaclient --shutdown";
        RemainAfterExit = true;
      };
    };
  };
}
