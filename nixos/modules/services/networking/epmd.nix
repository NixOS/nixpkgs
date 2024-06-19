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
    package = mkPackageOption pkgs "erlang" { };
    listenStream = mkOption
      {
        type = types.str;
        default = "[::]:4369";
        description = ''
          the listenStream used by the systemd socket.
          see https://www.freedesktop.org/software/systemd/man/systemd.socket.html#ListenStream= for more information.
          use this to change the port epmd will run on.
          if not defined, epmd will use "[::]:4369"
        '';
      };
  };

  ###### implementation
  config = mkIf cfg.enable {
    assertions = [{
      assertion = cfg.listenStream == "[::]:4369" -> config.networking.enableIPv6;
      message = "epmd listens by default on ipv6, enable ipv6 or change config.services.epmd.listenStream";
    }];
    systemd.sockets.epmd = rec {
      description = "Erlang Port Mapper Daemon Activation Socket";
      wantedBy = [ "sockets.target" ];
      before = wantedBy;
      socketConfig = {
        ListenStream = cfg.listenStream;
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

  meta.maintainers = teams.beam.members;
}
