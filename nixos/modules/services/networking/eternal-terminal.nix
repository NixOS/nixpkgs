{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.eternal-terminal;

in

{

  ###### interface

  options = {

    services.eternal-terminal = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable the Eternal Terminal server.
        '';
      };

      port = mkOption {
        default = null;
        type = types.nullOr types.int;
        description = ''
          The port the server should listen on. Will use the server's default (2022) if not specified.
        '';
      };

      verbosity = mkOption {
        default = 0;
        type = types.int;
        description = ''
          The verbosity level (0-9).
        '';
      };

      silence = mkOption {
        default = 0;
        type = types.int;
        description = ''
          Silence.
        '';
      };

      logSize = mkOption {
        default = 20971520;
        type = types.int;
        description = ''
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
        after = [ "syslog.target" "network.target" ];
        serviceConfig = {
          Type = "forking";
          ExecStart = "${pkgs.eternal-terminal}/bin/etserver --daemon --cfgfile=${pkgs.writeText "et.cfg" ''
            ; et.cfg : Config file for Eternal Terminal
            ;

            ${optionalString (cfg.port != null) ''
              [Networking]
              port = ${toString cfg.port}
            ''}
            [Debug]
            verbose = ${toString cfg.verbosity}
            silent = ${toString cfg.silence}
            logsize = ${toString cfg.logSize}
          ''}";
          Restart = "on-failure";
          KillMode = "process";
        };
      };
    };
  };
}
