{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.beanstalkd;
  pkg = pkgs.beanstalkd;
in

{
  # interface

  options = {
    services.beanstalkd = {
      enable = mkEnableOption (lib.mdDoc "the Beanstalk work queue");

      listen = {
        port = mkOption {
          type = types.int;
          description = lib.mdDoc "TCP port that will be used to accept client connections.";
          default = 11300;
        };

        address = mkOption {
          type = types.str;
          description = lib.mdDoc "IP address to listen on.";
          default = "127.0.0.1";
          example = "0.0.0.0";
        };
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to open ports in the firewall for the server.";
      };
    };
  };

  # implementation

  config = mkIf cfg.enable {

    networking.firewall = mkIf cfg.openFirewall {
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
