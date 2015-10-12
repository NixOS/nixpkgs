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
          don't cause the socket file to be created.
        '';
      };


  };

  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    { environment.systemPackages = [ pkgs.docker ];
      users.extraGroups.docker.gid = config.ids.gids.docker;
    }
    (mkIf cfg.socketActivation {

      systemd.services.docker = {
        description = "Docker Application Container Engine";
        after = [ "network.target" "docker.socket" ];
        requires = [ "docker.socket" ];
        serviceConfig = {
          ExecStart = "${pkgs.docker}/bin/docker daemon --host=fd:// --group=docker --storage-driver=${cfg.storageDriver} ${cfg.extraOptions}";
          #  I'm not sure if that limits aren't too high, but it's what
          #  goes in config bundled with docker itself
          LimitNOFILE = 1048576;
          LimitNPROC = 1048576;
        } // proxy_env;
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
          ExecStart = "${pkgs.docker}/bin/docker daemon --group=docker --storage-driver=${cfg.storageDriver} ${cfg.extraOptions}";
          #  I'm not sure if that limits aren't too high, but it's what
          #  goes in config bundled with docker itself
          LimitNOFILE = 1048576;
          LimitNPROC = 1048576;
        } // proxy_env;

        path = [ pkgs.kmod ] ++ (optional (cfg.storageDriver == "zfs") pkgs.zfs);
        environment.MODULE_DIR = "/run/current-system/kernel-modules/lib/modules";

        postStart = cfg.postStart;

        # Presumably some containers are running we don't want to interrupt
        restartIfChanged = false;
      };
    })
  ]);

}
