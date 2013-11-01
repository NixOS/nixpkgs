{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.oidentd.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable ‘oidentd’, an implementation of the Ident
        protocol (RFC 1413).  It allows remote systems to identify the
        name of the user associated with a TCP connection.
      '';
    };

  };

  
  ###### implementation

  config = mkIf config.services.oidentd.enable {

    jobs.oidentd =
      { startOn = "started network-interfaces";
        daemonType = "fork";
        exec = "${pkgs.oidentd}/sbin/oidentd -u oidentd -g nogroup";
      };

    users.extraUsers.oidentd = {
      description = "Ident Protocol daemon user";
      group = "oidentd";
      uid = config.ids.uids.oidentd;
    };

    users.extraGroups.oidentd.gid = config.ids.gids.oidentd;

  };

}
