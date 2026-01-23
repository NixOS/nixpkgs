# Systemd services for docker.

{
  config,
  lib,
  utils,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.virtualisation.docker;
  proxy_env = config.networking.proxy.envVars;
  settingsFormat = pkgs.formats.json { };
  daemonSettingsFile = settingsFormat.generate "daemon.json" cfg.daemon.settings;
in

{
  ###### interface

  options.virtualisation.docker = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables docker, a daemon that manages
        linux containers. Users in the "docker" group can interact with
        the daemon (e.g. to start or stop containers) using the
        {command}`docker` command line tool.
      '';
    };

    listenOptions = mkOption {
      type = types.listOf types.str;
      default = [ "/run/docker.sock" ];
      description = ''
        A list of unix and tcp docker should listen to. The format follows
        ListenStream as described in {manpage}`systemd.socket(5)`.
      '';
    };

    enableOnBoot = mkOption {
      type = types.bool;
      default = true;
      description = ''
        When enabled dockerd is started on boot. This is required for
        containers which are created with the
        `--restart=always` flag to work. If this option is
        disabled, docker might be started on demand by socket activation.
      '';
    };

    daemon.settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          live-restore = mkOption {
            type = types.bool;
            # Prior to NixOS 24.11, this was set to true by default, while upstream defaulted to false.
            # Keep the option unset to follow upstream defaults
            default = versionOlder config.system.stateVersion "24.11";
            defaultText = literalExpression "lib.versionOlder config.system.stateVersion \"24.11\"";
            description = ''
              Allow dockerd to be restarted without affecting running container.
              This option is incompatible with docker swarm.
            '';
          };
        };
      };
      default = { };
      example = {
        ipv6 = true;
        "live-restore" = true;
        "fixed-cidr-v6" = "fd00::/80";
      };
      description = ''
        Configuration for docker daemon. The attributes are serialized to JSON used as daemon.conf.
        See <https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file>
      '';
    };

    enableNvidia = mkOption {
      type = types.bool;
      default = false;
      description = ''
        **Deprecated**, please use hardware.nvidia-container-toolkit.enable instead.

        Enable Nvidia GPU support inside docker containers.
      '';
    };

    storageDriver = mkOption {
      type = types.nullOr (
        types.enum [
          "aufs"
          "btrfs"
          "devicemapper"
          "overlay"
          "overlay2"
          "zfs"
        ]
      );
      default = null;
      description = ''
        This option determines which Docker
        [storage driver](https://docs.docker.com/storage/storagedriver/select-storage-driver/)
        to use.
        By default it lets docker automatically choose the preferred storage
        driver.
        However, it is recommended to specify a storage driver explicitly, as
        docker's default varies over versions.

        ::: {.warning}
        Changing the storage driver will cause any existing containers
        and images to become inaccessible.
        :::
      '';
    };

    logDriver = mkOption {
      type = types.enum [
        "none"
        "json-file"
        "syslog"
        "journald"
        "gelf"
        "fluentd"
        "awslogs"
        "splunk"
        "etwlogs"
        "gcplogs"
        "local"
      ];
      default = "journald";
      description = ''
        This option determines which Docker log driver to use.
      '';
    };

    extraOptions = mkOption {
      type = types.separatedString " ";
      default = "";
      description = ''
        The extra command-line options to pass to
        {command}`docker` daemon.
      '';
    };

    autoPrune = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to periodically prune Docker resources. If enabled, a
          systemd timer will run `docker system prune -f`
          as specified by the `dates` option.
        '';
      };

      flags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--all" ];
        description = ''
          Any additional flags passed to {command}`docker system prune`.
        '';
      };

      dates = mkOption {
        default = "weekly";
        type = types.str;
        description = ''
          Specification (in the format described by
          {manpage}`systemd.time(7)`) of the time at
          which the prune will occur.
        '';
      };

      randomizedDelaySec = mkOption {
        default = "0";
        type = types.singleLineStr;
        example = "45min";
        description = ''
          Add a randomized delay before each auto prune.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

      persistent = mkOption {
        default = true;
        type = types.bool;
        example = false;
        description = ''
          Takes a boolean argument. If true, the time when the service
          unit was last triggered is stored on disk. When the timer is
          activated, the service unit is triggered immediately if it
          would have been triggered at least once during the time when
          the timer was inactive. Such triggering is nonetheless
          subject to the delay imposed by RandomizedDelaySec=. This is
          useful to catch up on missed runs of the service when the
          system was powered down.
        '';
      };
    };

    package = mkPackageOption pkgs "docker" { };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "with pkgs; [ criu ]";
      description = ''
        Extra packages to add to PATH for the docker daemon process.
      '';
    };
  };

  imports = [
    (mkRemovedOptionModule [
      "virtualisation"
      "docker"
      "socketActivation"
    ] "This option was removed and socket activation is now always active")
    (mkAliasOptionModule
      [ "virtualisation" "docker" "liveRestore" ]
      [ "virtualisation" "docker" "daemon" "settings" "live-restore" ]
    )
  ];

  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    {
      boot.kernelModules = [
        "bridge"
        "veth"
        "br_netfilter"
        "xt_nat"
      ];
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = mkOverride 98 true;
        "net.ipv4.conf.default.forwarding" = mkOverride 98 true;
      };
      environment.systemPackages = [ cfg.package ];
      users.groups.docker.gid = config.ids.gids.docker;
      systemd.packages = [ cfg.package ];

      # Docker 25.0.0 supports CDI by default
      # (https://docs.docker.com/engine/release-notes/25.0/#new). Encourage
      # moving to CDI as opposed to having deprecated runtime
      # wrappers.
      warnings =
        lib.optionals (cfg.enableNvidia && (lib.strings.versionAtLeast cfg.package.version "25"))
          [
            ''
              You have set virtualisation.docker.enableNvidia. This option is deprecated, please set hardware.nvidia-container-toolkit.enable instead.
            ''
          ];

      systemd.services.docker = {
        wantedBy = optional cfg.enableOnBoot "multi-user.target";
        after = [
          "network.target"
          "docker.socket"
        ];
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
            ''
          ];
          ExecReload = [
            ""
            "${pkgs.procps}/bin/kill -s HUP $MAINPID"
          ];
        };

        path = [
          pkgs.kmod
        ]
        ++ optional (cfg.storageDriver == "zfs") config.boot.zfs.package
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

        serviceConfig = {
          Type = "oneshot";
          ExecStart = utils.escapeSystemdExecArgs (
            [
              (lib.getExe cfg.package)
              "system"
              "prune"
              "-f"
            ]
            ++ cfg.autoPrune.flags
          );
        };

        startAt = optional cfg.autoPrune.enable cfg.autoPrune.dates;
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
      };

      systemd.timers.docker-prune = mkIf cfg.autoPrune.enable {
        timerConfig = {
          RandomizedDelaySec = cfg.autoPrune.randomizedDelaySec;
          Persistent = cfg.autoPrune.persistent;
        };
      };

      assertions = [
        {
          assertion =
            cfg.enableNvidia && pkgs.stdenv.hostPlatform.isx86_64
            -> config.hardware.graphics.enable32Bit or false;
          message = "Option enableNvidia on x86_64 requires 32-bit support libraries";
        }
      ];

      virtualisation.docker.daemon.settings = {
        group = "docker";
        hosts = [ "fd://" ];
        log-driver = mkDefault cfg.logDriver;
        storage-driver = mkIf (cfg.storageDriver != null) (mkDefault cfg.storageDriver);
        runtimes = mkIf cfg.enableNvidia {
          nvidia = {
            # Use the legacy nvidia-container-runtime wrapper to allow
            # the `--runtime=nvidia` approach to expose
            # GPU's. Starting with Docker > 25, CDI can be used
            # instead, removing the need for runtime wrappers.
            path = lib.getExe' (lib.getOutput "tools" config.hardware.nvidia-container-toolkit.package) "nvidia-container-runtime";
          };
        };
      };
    }
  ]);
}
