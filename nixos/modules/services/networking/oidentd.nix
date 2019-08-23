{ config, lib, pkgs, ... }:

with lib;

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
    systemd.services.oidentd = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "forking";
      script = "${pkgs.oidentd}/sbin/oidentd -u oidentd -g nogroup";
    };

    users.users.oidentd = {
      description = "Ident Protocol daemon user";
      group = "oidentd";
      uid = config.ids.uids.oidentd;
    };

    users.groups.oidentd.gid = config.ids.gids.oidentd;

  };

}
