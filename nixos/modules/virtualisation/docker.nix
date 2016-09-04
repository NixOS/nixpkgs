# Systemd services for docker.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.docker;
  pro = config.networking.proxy.default;
  proxy_env = optionalAttrs (pro != null) { Environment = "\"http_proxy=${pro}\""; };

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
        default = true;
        description =
          ''
            This option enables docker with socket activation. I.e. docker will
            start when first called by client.
          '';
      };
    storageDriver =
      mkOption {
        type = types.enum ["aufs" "btrfs" "devicemapper" "overlay" "zfs"];
        default = "devicemapper";
        description =
          ''
            This option determines which Docker storage driver to use.
          '';
      };
    extraOptions =
      mkOption {
        type = types.separatedString " ";
        default = "";
        description =
          ''
            The extra command-line options to pass to
            <command>docker</command> daemon.
          '';
      };

    postStart =
      mkOption {
        type = types.lines;
        default = ''
          while ! [ -e /var/run/docker.sock ]; do
            sleep 0.1
          done
        '';
        description = ''
          The postStart phase of the systemd service. You may need to
          override this if you are passing in flags to docker which
          don't cause the socket file to be created. This option is ignored
          if socket activation is used.
        '';
      };


  };

  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    { environment.systemPackages = [ pkgs.docker ];
      users.extraGroups.docker.gid = config.ids.gids.docker;
      systemd.services.docker = {
        description = "Docker Application Container Engine";
        wantedBy = optional (!cfg.socketActivation) "multi-user.target";
        after = [ "network.target" ] ++ (optional cfg.socketActivation "docker.socket") ;
        requires = optional cfg.socketActivation "docker.socket";
        serviceConfig = {
          ExecStart = "${pkgs.docker}/bin/docker daemon --group=docker --storage-driver=${cfg.storageDriver} ${optionalString cfg.socketActivation "--host=fd://"} ${cfg.extraOptions}";
          #  I'm not sure if that limits aren't too high, but it's what
          #  goes in config bundled with docker itself
          LimitNOFILE = 1048576;
          LimitNPROC = 1048576;
        } // proxy_env;

        path = [ pkgs.kmod ] ++ (optional (cfg.storageDriver == "zfs") pkgs.zfs);

        postStart = if cfg.socketActivation then "" else cfg.postStart;

        # Presumably some containers are running we don't want to interrupt
        restartIfChanged = false;
      };
    }
    (mkIf cfg.socketActivation {
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
  ]);

}
