{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.eternal-terminal;

in

{

  ###### interface

  options = {

    services.eternal-terminal = {

      enable = mkEnableOption (lib.mdDoc "Eternal Terminal server");

      port = mkOption {
        default = 2022;
        type = types.int;
        description = lib.mdDoc ''
          The port the server should listen on. Will use the server's default (2022) if not specified.

          Make sure to open this port in the firewall if necessary.
        '';
      };

      verbosity = mkOption {
        default = 0;
        type = types.enum (lib.range 0 9);
        description = lib.mdDoc ''
          The verbosity level (0-9).
        '';
      };

      silent = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          If enabled, disables all logging.
        '';
      };

      logSize = mkOption {
        default = 20971520;
        type = types.int;
        description = lib.mdDoc ''
          The maximum log size.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

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
    maintainers = with lib.maintainers; [ ];
  };
}
