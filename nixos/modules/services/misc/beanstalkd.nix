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
      enable = mkEnableOption "Enable the Beanstalk work queue.";

      listen = {
        port = mkOption {
          type = types.int;
          description = "TCP port that will be used to accept client connections.";
          default = 11300;
        };

        address = mkOption {
          type = types.str;
          description = "IP address to listen on.";
          default = "127.0.0.1";
          example = "0.0.0.0";
        };
      };
    };
  };

  # implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkg ];

    systemd.services.beanstalkd = {
      description = "Beanstalk Work Queue";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        ExecStart = "${pkg}/bin/beanstalkd -l ${cfg.listen.address} -p ${toString cfg.listen.port}";
      };
    };

  };
}
