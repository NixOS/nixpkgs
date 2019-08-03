{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.epmd;

in

{
  ###### interface
  options.services.epmd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable socket activation for Erlang Port Mapper Daemon (epmd),
        which acts as a name server on all hosts involved in distributed
        Erlang computations.
      '';
    };
    package = mkOption {
      type = types.package;
      default = pkgs.erlang;
      description = ''
        The Erlang package to use to get epmd binary. That way you can re-use
        an Erlang runtime that is already installed for other purposes.
      '';
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    systemd.sockets.epmd = rec {
      description = "Erlang Port Mapper Daemon Activation Socket";
      wantedBy = [ "sockets.target" ];
      before = wantedBy;
      socketConfig = {
        ListenStream = "4369";
        Accept = "false";
      };
    };

    systemd.services.epmd = {
      description = "Erlang Port Mapper Daemon";
      after = [ "network.target" ];
      requires = [ "epmd.socket" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${cfg.package}/bin/epmd -systemd";
        Type = "notify";
      };
    };
  };
}
