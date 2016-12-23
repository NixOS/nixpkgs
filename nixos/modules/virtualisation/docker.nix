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

    listenOptions =
      mkOption {
        type = types.listOf types.str;
        default = ["/var/run/docker.sock"];
        description =
          ''
            A list of unix and tcp docker should listen to. The format follows
            ListenStream as described in systemd.socket(5).
          '';
      };

    enableOnBoot =
      mkOption {
        type = types.bool;
        default = true;
        description =
          ''
            When enabled dockerd is started on boot. This is required for
            container, which are created with the
            <literal>--restart=always</literal> flag, to work. If this option is
            disabled, docker might be started on demand by socket activation.
          '';
      };

    liveRestore =
      mkOption {
        type = types.bool;
        default = true;
        description =
          ''
            Allow dockerd to be restarted without affecting running container.
            This option is incompatible with docker swarm.
          '';
      };

    storageDriver =
      mkOption {
        type = types.nullOr (types.enum ["aufs" "btrfs" "devicemapper" "overlay" "overlay2" "zfs"]);
        default = null;
        description =
          ''
            This option determines which Docker storage driver to use. By default
            it let's docker automatically choose preferred storage driver.
          '';
      };

    logDriver =
      mkOption {
        type = types.enum ["none" "json-file" "syslog" "journald" "gelf" "fluentd" "awslogs" "splunk" "etwlogs" "gcplogs"];
        default = "journald";
        description =
          ''
            This option determines which Docker log driver to use.
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
  };

  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    { environment.systemPackages = [ pkgs.docker ];
      users.extraGroups.docker.gid = config.ids.gids.docker;
      # this unit follows the one provided by upstream see: https://github.com/docker/docker/blob/master/contrib/init/systemd/docker.service
      # comments below reflect experience from upstream.
      systemd.services.docker = {
        description = "Docker Application Container Engine";
        wantedBy = optional cfg.enableOnBoot "multi-user.target";
        after = [ "network.target" "docker.socket" ];
        requires = ["docker.socket"];
        serviceConfig = {
          # the default is not to use systemd for cgroups because the delegate issues still
          # exists and systemd currently does not support the cgroup feature set required
          # for containers run by docker
          ExecStart = ''${pkgs.docker}/bin/dockerd \
            --group=docker \
            --host=fd:// \
            --log-driver=${cfg.logDriver} \
            ${optionalString (cfg.storageDriver != null) "--storage-driver=${cfg.storageDriver}"} \
            ${optionalString cfg.liveRestore "--live-restore" } \
            ${cfg.extraOptions}
          '';
          Type="notify";
          ExecReload="${pkgs.procps}/bin/kill -s HUP $MAINPID";
          LimitNOFILE = 1048576;
          # Having non-zero Limit*s causes performance problems due to accounting overhead
          # in the kernel. We recommend using cgroups to do container-local accounting.
          LimitNPROC="infinity";
          LimitCORE="infinity";
          TasksMax="infinity";
          TimeoutStartSec=0;
          # set delegate yes so that systemd does not reset the cgroups of docker containers
          Delegate="yes";
          # kill only the docker process, not all processes in the cgroup
          KillMode="process";
        } // proxy_env;

        path = [ pkgs.kmod ] ++ (optional (cfg.storageDriver == "zfs") pkgs.zfs);
      };
      systemd.sockets.docker = {
        description = "Docker Socket for the API";
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = cfg.listenOptions;
          SocketMode = "0660";
          SocketUser = "root";
          SocketGroup = "docker";
        };
      };
    }
  ]);

}
