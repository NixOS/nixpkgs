{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {
    services.tinydns = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to run the tinydns dns server";
      };

      data = mkOption {
        type = types.lines;
        default = "";
        description = "The DNS data to serve, in the format described by tinydns-data(8)";
      };

      ip = mkOption {
        default = "0.0.0.0";
        type = types.str;
        description = "IP address on which to listen for connections";
      };
    };
  };

  ###### implementation

  config = mkIf config.services.tinydns.enable {
    environment.systemPackages = [ pkgs.djbdns ];

    users.users.tinydns = {};

    systemd.services.tinydns = {
      description = "djbdns tinydns server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = with pkgs; [ daemontools djbdns ];
      preStart = ''
        rm -rf /var/lib/tinydns
        tinydns-conf tinydns tinydns /var/lib/tinydns ${config.services.tinydns.ip}
        cd /var/lib/tinydns/root/
        ln -sf ${pkgs.writeText "tinydns-data" config.services.tinydns.data} data
        tinydns-data
      '';
      script = ''
        cd /var/lib/tinydns
        exec ./run
      '';
    };
  };
}
