{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.arpwatch;
in {
  options.services.arpwatch.interfaces = mkOption {
    type = types.listOf types.str;
    description = ''
      List of interfaces to watch ("all" to not bind to a specific interface)
    '';
    default = [];
    example = [ "enp0s3" ];
  };
  config = {
    systemd.services = listToAttrs (flip map cfg.interfaces (interface: {
      name = "arpwatch-" + interface;
      value = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          mkdir -p /var/lib/arpwatch
          touch /var/lib/arpwatch/${interface}.dat
        '';
        serviceConfig = {
          Type = "forking";
          ExecStart = ''
            ${pkgs.arpwatch} ${optionalString (interface != "all") "-i ${interface}"} \
              -f /var/lib/arpwatch/${interface}.dat
          '';
        };
      };
    }));
  };
}
