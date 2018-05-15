{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.telnet;
in {
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
      name = "telnetd";
      group = "telnetd";
      description = "Telnet daemon";
    };

    users.extraGroups = singleton {
      name = "telnetd";
    };

    systemd.services.telnetd = {
      description = "Telnet server";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart="${pkgs.busybox}/bin/telnetd -p ${toString cfg.port}";
        Type="forking";
        User = "telnetd";
        Group = "telnetd";
        AmbientCapabilities = "cap_net_bind_service";
      };
    };
  };
}
