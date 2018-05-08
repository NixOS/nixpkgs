{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.telnet;

in
{

  options.services.telnet = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable telnetd.
      '';
    };

    port = mkOption {
      default = 12345;
      type = types.int;
      description = ''
        Port on which to listen.
      '';
    };

  };

  config = mkIf config.services.telnet.enable {

    networking.firewall.allowedUDPPorts =  [ cfg.port ];

    users.extraUsers.telnetd.uid = config.ids.uids.telnetd;
    users.extraGroups.telnetd.gid = config.ids.gids.telnetd;


    systemd.services.telnetd = {
      description = "Telnet server";

      script = "${pkgs.busybox}/bin/telnetd -p ${toString cfg.port}";
      serviceConfig = {
        User = "telnetd";
        Group = "telnetd";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        # RuntimeDirectory = [ "telnetd" ];
      };
      wantedBy = [ "multi-user.target" ];
    };
  };


  meta.maintainers = with maintainers; [ teto ];

}

