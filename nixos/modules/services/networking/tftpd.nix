{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.tftpd.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable tftpd, a Trivial File Transfer Protocol server.
        The server will be run as an xinetd service.
      '';
    };

    services.tftpd.path = mkOption {
      type = types.path;
      default = "/srv/tftp";
      description = lib.mdDoc ''
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
