{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.tftpd.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable tftpd, a Trivial File Transfer Protocol server.
      '';
    };

    services.tftpd.path = mkOption {
      type = types.path;
      default = "/home/tftp";
      description = ''
        Where the tftp server files are stored.
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
