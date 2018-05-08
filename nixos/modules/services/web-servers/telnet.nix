{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.telnet;

  user = "telnetd";
in
{

  options.services.telnet = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable telnetd.
        Only use in trusted networks as there is no encryption.
      '';
    };

    port = mkOption {
      default = 23;
      type = types.int;
      description = ''
        Port to listen to.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to automatically open the specified ports in the firewall.
      '';
    };
  };

  config = mkIf config.services.telnet.enable {

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    users.extraUsers = singleton {
      name = user;
      description = "Telnet daemon";
    };

      users.extraGroups = singleton {
        name = "telnetd";
      };


    systemd.services.telnetd = {
      description = "Telnet server";
      wantedBy = [ "multi-user.target" ];

      script = "${pkgs.busybox}/bin/telnetd -p ${toString cfg.port}";

      serviceConfig = {
        User = user;
        Group = "telnetd";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE=+ep";
        RuntimeDirectory = [ "telnetd" ];
        Restart = "always";
      };
    };
  };


  meta.maintainers = with maintainers; [ teto ];

}

