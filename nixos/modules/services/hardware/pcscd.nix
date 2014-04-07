{ config, pkgs, ... }:

let
  cfgFile = pkgs.writeText "reader.conf" "";
in

with pkgs.lib;

{

  ###### interface

  options = {

    services.pcscd = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the PCSC-Lite daemon.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.pcscd.enable {

    systemd.services.pcscd = {
      description = "PCSC-Lite daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
          mkdir -p /var/lib/pcsc
          rm -Rf /var/lib/pcsc/drivers
          ln -s ${pkgs.ccid}/pcsc/drivers /var/lib/pcsc/
      '';
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.pcsclite}/sbin/pcscd -c ${cfgFile}";
      };
    };

  };

}
