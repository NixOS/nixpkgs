# Systemd services for docker.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.docker;
  proxy_env = config.networking.proxy.envVars;
  settingsFormat = pkgs.formats.json {};
  daemonSettingsFile = settingsFormat.generate "daemon.json" cfg.daemon.settings;
in

{
  ###### interface

  options.virtualisation.docker = {
    enable =
      mkOption {
        type = types.bool;
        default = false;
        description =
          lib.mdDoc ''
            This option enables docker, a daemon that manages
            linux containers. Users in the "docker" group can interact with
            the daemon (e.g. to start or stop containers) using the
            {command}`docker` command line tool.
          '';
      };

    listenOptions =
      mkOption {
        type = types.listOf types.str;
        default = ["/run/docker.sock"];
        description =
          lib.mdDoc ''
            A list of unix and tcp docker should listen to. The format follows
            ListenStream as described in systemd.socket(5).
          '';
      };

    enableOnBoot =
      mkOption {
        type = types.bool;
        default = true;
        description =
          lib.mdDoc ''
            When enabled dockerd is started on boot. This is required for
            containers which are created with the
            `--restart=always` flag to work. If this option is
            disabled, docker might be started on demand by socket activation.
          '';
      };

    daemon.settings =
      mkOption {
        type = settingsFormat.type;
        default = { };
        example = {
          ipv6 = true;
          "fixed-cidr-v6" = "fd00::/80";
        };
        description = lib.mdDoc ''
          Configuration for docker daemon. The attributes are serialized to JSON used as daemon.conf.
          See https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file
        '';
      };

    enableNvidia =
      mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable nvidia-docker wrapper, supporting NVIDIA GPUs inside docker containers.
        '';
      };

    liveRestore =
      mkOption {
        type = types.bool;
        default = true;
        description =
          lib.mdDoc ''
            Allow dockerd to be restarted without affecting running container.
            This option is incompatible with docker swarm.
          '';
      };

    storageDriver =
      mkOption {
        type = types.nullOr (types.enum ["aufs" "btrfs" "devicemapper" "overlay" "overlay2" "zfs"]);
        default = null;
        description =
          lib.mdDoc ''
            This option determines which Docker storage driver to use. By default
            it let's docker automatically choose preferred storage driver.
          '';
      };

    logDriver =
      mkOption {
        type = types.enum ["none" "json-file" "syslog" "journald" "gelf" "fluentd" "awslogs" "splunk" "etwlogs" "gcplogs" "local"];
        default = "journald";
        description =
          lib.mdDoc ''
            This option determines which Docker log driver to use.
          '';
      };

    extraOptions =
      mkOption {
        type = types.separatedString " ";
        default = "";
        description =
          lib.mdDoc ''
            The extra command-line options to pass to
            {command}`docker` daemon.
          '';
      };

    autoPrune = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to periodically prune Docker resources. If enabled, a
          systemd timer will run `docker system prune -f`
          as specified by the `dates` option.
        '';
      };

      flags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--all" ];
        description = lib.mdDoc ''
          Any additional flags passed to {command}`docker system prune`.
        '';
      };

      dates = mkOption {
        default = "weekly";
        type = types.str;
        description = lib.mdDoc ''
          Specification (in the format described by
          {manpage}`systemd.time(7)`) of the time at
          which the prune will occur.
        '';
      };
    };

    package = mkPackageOption pkgs "docker" { };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "with pkgs; [ criu ]";
      description = lib.mdDoc ''
        Extra packages to add to PATH for the docker daemon process.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable (mkMerge [{
      boot.kernelModules = [ "bridge" "veth" "br_netfilter" "xt_nat" ];
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = mkOverride 98 true;
        "net.ipv4.conf.default.forwarding" = mkOverride 98 true;
      };
      environment.systemPackages = [ cfg.package ]
        ++ optional cfg.enableNvidia pkgs.nvidia-docker;
      users.groups.docker.gid = config.ids.gids.docker;
      systemd.packages = [ cfg.package ];

      systemd.services.docker = {
        wantedBy = optional cfg.enableOnBoot "multi-user.target";
        after = [ "network.target" "docker.socket" ];
        requires = [ "docker.socket" ];
        environment = proxy_env;
        serviceConfig = {
          Type = "notify";
          ExecStart = [
            ""
            ''
              ${cfg.package}/bin/dockerd \
                --config-file=${daemonSettingsFile} \
                ${cfg.extraOptions}
            ''];
          ExecReload=[
            ""
            "${pkgs.procps}/bin/kill -s HUP $MAINPID"
          ];
        };

        path = [ pkgs.kmod ] ++ optional (cfg.storageDriver == "zfs") pkgs.zfs
          ++ optional cfg.enableNvidia pkgs.nvidia-docker
          ++ cfg.extraPackages;
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

      systemd.services.docker-prune = {
        description = "Prune docker resources";

        restartIfChanged = false;
        unitConfig.X-StopOnRemoval = false;

        serviceConfig.Type = "oneshot";

        script = ''
          ${cfg.package}/bin/docker system prune -f ${toString cfg.autoPrune.flags}
        '';

        startAt = optional cfg.autoPrune.enable cfg.autoPrune.dates;
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
      };

      assertions = [
        { assertion = cfg.enableNvidia && pkgs.stdenv.isx86_64 -> config.hardware.opengl.driSupport32Bit or false;
          message = "Option enableNvidia on x86_64 requires 32bit support libraries";
        }];

      virtualisation.docker.daemon.settings = {
        group = "docker";
        hosts = [ "fd://" ];
        log-driver = mkDefault cfg.logDriver;
        storage-driver = mkIf (cfg.storageDriver != null) (mkDefault cfg.storageDriver);
        live-restore = mkDefault cfg.liveRestore;
        runtimes = mkIf cfg.enableNvidia {
          nvidia = {
            path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
          };
        };
      };
    }
  ]);

  imports = [
    (mkRemovedOptionModule ["virtualisation" "docker" "socketActivation"] "This option was removed and socket activation is now always active")
  ];

}
