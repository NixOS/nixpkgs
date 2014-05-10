{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fcgiwrap;

in {

  options = {
    services.fcgiwrap = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable fcgiwrap, a server for running CGI applications over FastCGI.";
      };

      preforkProcesses = mkOption {
        type = types.int;
        default = 1;
        description = "Number of processes to prefork.";
      };

      bindSocket = mkOption {
        type = types.string;
        default = "unix:/run/fcgiwrap.sock";
        description = ''
          Socket to bind to. Valid socket URLs are:
            unix:/path/to/socket for Unix sockets
            tcp:dot.ted.qu.ad:port for IPv4 sockets
            tcp6:[ipv6_addr]:port for IPv6 sockets
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.fcgiwrap = {
      after = [ "nss-user-lookup.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.fcgiwrap}/sbin/fcgiwrap -c ${builtins.toString cfg.preforkProcesses} -s ${cfg.bindSocket}";
      };
    };

  };
}
