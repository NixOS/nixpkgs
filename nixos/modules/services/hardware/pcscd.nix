{ config, lib, pkgs, ... }:

let
  cfgFile = pkgs.writeText "reader.conf" "";
in

with lib;

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

    systemd.sockets.pcscd = {
      description = "PCSC-Lite Socket";
      wantedBy = [ "sockets.target" ];
      before = [ "multi-user.target" ];
      socketConfig.ListenStream = "/run/pcscd/pcscd.comm";
    };

    systemd.services.pcscd = {
      description = "PCSC-Lite daemon";
      preStart = ''
          mkdir -p /var/lib/pcsc
          rm -Rf /var/lib/pcsc/drivers
          ln -s ${pkgs.ccid}/pcsc/drivers /var/lib/pcsc/
      '';
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.pcsclite}/sbin/pcscd --auto-exit -c ${cfgFile}";
        ExecReload = "${pkgs.pcsclite}/sbin/pcscd --hotplug";
      };
    };

  };

}
