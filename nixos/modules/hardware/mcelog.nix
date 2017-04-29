{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.grahamc ];
  options = {

    hardware.mcelog = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Machine Check Exception logger.
        '';
      };
    };

  };

  config = mkIf config.hardware.mcelog.enable {
    systemd.services.mcelog = {
      description = "Machine Check Exception Logging Daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.mcelog}/bin/mcelog --daemon --foreground";
        SuccessExitStatus = [ 0 15 ];

        ProtectHome = true;
        PrivateNetwork = true;
        PrivateTmp = true;
      };
    };
  };

}
