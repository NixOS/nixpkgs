{ config, lib, pkgs, ... }:
let
  cfg = config.services.beanstalkd;
  pkg = pkgs.beanstalkd;
in

{
  # interface

  options = {
    services.beanstalkd = {
      enable = lib.mkEnableOption "the Beanstalk work queue";

      listen = {
        port = lib.mkOption {
          type = lib.types.port;
          description = "TCP port that will be used to accept client connections.";
          default = 11300;
        };

        address = lib.mkOption {
          type = lib.types.str;
          description = "IP address to listen on.";
          default = "127.0.0.1";
          example = "0.0.0.0";
        };
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open ports in the firewall for the server.";
      };
    };
  };

  # implementation

  config = lib.mkIf cfg.enable {

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ];
    };

    environment.systemPackages = [ pkg ];

    systemd.services.beanstalkd = {
      description = "Beanstalk Work Queue";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        ExecStart = "${pkg}/bin/beanstalkd -l ${cfg.listen.address} -p ${toString cfg.listen.port} -b $STATE_DIRECTORY";
        StateDirectory = "beanstalkd";
      };
    };

  };
}
