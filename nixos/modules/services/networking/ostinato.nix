{
  config,
  lib,
  pkgs,
  ...
}:

let
  pkg = pkgs.ostinato;
  cfg = config.services.ostinato;
  configFile = pkgs.writeText "drone.ini" ''
    [General]
    RateAccuracy=${cfg.rateAccuracy}

    [RpcServer]
    Address=${cfg.rpcServer.address}

    [PortList]
    Include=${lib.concatStringsSep "," cfg.portList.include}
    Exclude=${lib.concatStringsSep "," cfg.portList.exclude}
  '';

in
{

  ###### interface

  options = {

    services.ostinato = {

      enable = lib.mkEnableOption "Ostinato agent-controller (Drone)";

      port = lib.mkOption {
        type = lib.types.port;
        default = 7878;
        description = ''
          Port to listen on.
        '';
      };

      rateAccuracy = lib.mkOption {
        type = lib.types.enum [
          "High"
          "Low"
        ];
        default = "High";
        description = ''
          To ensure that the actual transmit rate is as close as possible to
          the configured transmit rate, Drone runs a busy-wait loop.
          While this provides the maximum accuracy possible, the CPU
          utilization is 100% while the transmit is on. You can however,
          sacrifice the accuracy to reduce the CPU load.
        '';
      };

      rpcServer = {
        address = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = ''
            By default, the Drone RPC server will listen on all interfaces and
            local IPv4 addresses for incoming connections from clients.  Specify
            a single IPv4 or IPv6 address if you want to restrict that.
            To listen on any IPv6 address, use ::
          '';
        };
      };

      portList = {
        include = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "eth*"
            "lo*"
          ];
          description = ''
            For a port to pass the filter and appear on the port list managed
            by drone, it be allowed by this include list.
          '';
        };
        exclude = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "usbmon*"
            "eth0"
          ];
          description = ''
            A list of ports does not appear on the port list managed by drone.
          '';
        };
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkg ];

    systemd.services.drone = {
      description = "Ostinato agent-controller";
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${pkg}/bin/drone ${toString cfg.port} ${configFile}
      '';
    };

  };

}
