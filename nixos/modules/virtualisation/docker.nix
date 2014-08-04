# Systemd services for docker.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.docker;

in

{
  ###### interface

  options.virtualisation.docker = {
    enable =
      mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            This option enables docker, a daemon that manages
            linux containers. Users in the "docker" group can interact with
            the daemon (e.g. to start or stop containers) using the
            <command>docker</command> command line tool.
          '';
      };
    socketActivation =
      mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            This option enables docker with socket activation. I.e. docker will
            start when first called by client.

            Note: This is false by default because systemd lower than 214 that
            nixos uses so far, doesn't support SocketGroup option, so socket
            created by docker has root group now. This will likely be changed
            in future.  So set this option explicitly to false if you wish.
          '';
      };
    extraOptions =
      mkOption {
        type = types.str;
        default = "";
        description =
          ''
            The extra command-line options to pass to
            <command>docker</command> daemon.
          '';
      };


  };

  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    { environment.systemPackages = [ pkgs.docker ];
    }
    (mkIf cfg.socketActivation {

      systemd.services.docker = {
        description = "Docker Application Container Engine";
        after = [ "network.target" "docker.socket" ];
        requires = [ "docker.socket" ];
        serviceConfig = {
          ExecStart = "${pkgs.docker}/bin/docker --daemon=true --host=fd:// --group=docker ${cfg.extraOptions}";
          #  I'm not sure if that limits aren't too high, but it's what
          #  goes in config bundled with docker itself
          LimitNOFILE = 1048576;
          LimitNPROC = 1048576;
        };
      };

      systemd.sockets.docker = {
        description = "Docker Socket for the API";
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = "/var/run/docker.sock";
          SocketMode = "0660";
          SocketUser = "root";
          SocketGroup = "docker";
        };
      };
    })
    (mkIf (!cfg.socketActivation) {

      systemd.services.docker = {
        description = "Docker Application Container Engine";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.docker}/bin/docker --daemon=true --group=docker ${cfg.extraOptions}";
          #  I'm not sure if that limits aren't too high, but it's what
          #  goes in config bundled with docker itself
          LimitNOFILE = 1048576;
          LimitNPROC = 1048576;
        };

        # Presumably some containers are running we don't want to interrupt
        restartIfChanged = false;
      };
    })
  ]);

}
