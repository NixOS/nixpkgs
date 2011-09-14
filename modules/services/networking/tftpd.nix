{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.tftpd.enable = mkOption {
      default = false;
      description = ''
        Whether to enable the anonymous FTP user.
      '';
    };

    services.tftpd.path = mkOption {
      default = "/home/tftp";
      description = ''
        Where the tftp server files are stored
      '';
    };

  };


  ###### implementation

  config = mkIf config.services.tftpd.enable {

    services.xinetd.enable = true;

    services.xinetd.services = singleton
      { name = "tftp";
        protocol = "udp";
        server = "${pkgs.netkittftp}/sbin/in.tftpd";
        serverArgs = "${config.services.tftpd.path}";
      };

  };

}
