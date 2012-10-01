{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.dnsmasq;
  dnsmasq = pkgs.dnsmasq;

  serversParam = concatMapStrings (s: "-S ${s} ") cfg.servers;

in

{

  ###### interface

  options = {

    services.dnsmasq = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run dnsmasq.
        '';
      };

      servers = mkOption {
        default = [];
        example = [ "8.8.8.8" "8.8.4.4" ];
        description = ''
          The parameter to dnsmasq -S.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.dnsmasq.enable {

    jobs.dnsmasq =
      { description = "dnsmasq daemon";

        startOn = "ip-up";

        daemonType = "daemon";

        exec = "${dnsmasq}/bin/dnsmasq -R ${serversParam} -o";
      };

  };

}
