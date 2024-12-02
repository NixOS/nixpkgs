{ config, lib, pkgs, ... }:
let

  cfg = config.services.eternal-terminal;

in

{

  ###### interface

  options = {

    services.eternal-terminal = {

      enable = lib.mkEnableOption "Eternal Terminal server";

      port = lib.mkOption {
        default = 2022;
        type = lib.types.port;
        description = ''
          The port the server should listen on. Will use the server's default (2022) if not specified.

          Make sure to open this port in the firewall if necessary.
        '';
      };

      verbosity = lib.mkOption {
        default = 0;
        type = lib.types.enum (lib.range 0 9);
        description = ''
          The verbosity level (0-9).
        '';
      };

      silent = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          If enabled, disables all logging.
        '';
      };

      logSize = lib.mkOption {
        default = 20971520;
        type = lib.types.int;
        description = ''
          The maximum log size.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    # We need to ensure the et package is fully installed because
    # the (remote) et client runs the `etterminal` binary when it
    # connects.
    environment.systemPackages = [ pkgs.eternal-terminal ];

    systemd.services = {
      eternal-terminal = {
        description = "Eternal Terminal server.";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${pkgs.eternal-terminal}/bin/etserver --daemon --cfgfile=${pkgs.writeText "et.cfg" ''
            ; et.cfg : Config file for Eternal Terminal
            ;

            [Networking]
            port = ${toString cfg.port}

            [Debug]
            verbose = ${toString cfg.verbosity}
            silent = ${if cfg.silent then "1" else "0"}
            logsize = ${toString cfg.logSize}
          ''}";
          Restart = "on-failure";
          KillMode = "process";
        };
      };
    };
  };

  meta = {
    maintainers = [ ];
  };
}
