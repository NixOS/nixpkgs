# Systemd services for docker.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.docker;
  proxy_env = config.networking.proxy.envVars;

  inherit (builtins) attrNames;

  mkUncreateMaybe = networks: volumes: ''
    set -euo pipefail

    nexisting=$(${pkgs.coreutils}/bin/mktemp)
    nwanted=$(${pkgs.coreutils}/bin/mktemp)
    vexisting=$(${pkgs.coreutils}/bin/mktemp)
    vwanted=$(${pkgs.coreutils}/bin/mktemp)

    cleanup() {
      rm -f "$nexisting" "$nwanted" "$vexisting" "$vwanted"
    }
    trap cleanup EXIT

    ${pkgs.docker}/bin/docker network ls --format '{{.Name}}' > "$nexisting"
    echo -e "bridge\nhost\nnone\n${concatStringsSep "\n" networks}" > "$nwanted"

    ${pkgs.docker}/bin/docker volume ls --format '{{.Name}}' > "$vexisting"
    echo -e "${concatStringsSep "\n" volumes}" > "$vwanted"

    nsuperfluous="$(${pkgs.gnugrep}/bin/grep -vxF -f $nwanted $nexisting || true)"
    vsuperfluous="$(${pkgs.gnugrep}/bin/grep -vxF -f $vwanted $vexisting || true)"

    while read -r net; do
      if [[ ! -z "$net" ]]; then
        echo -n "Removed superfluous Docker network: "
        ${pkgs.docker}/bin/docker network rm "$net" || true
      fi
    done <<< "$nsuperfluous"

    while read -r vol; do
      if [[ ! -z "$vol" ]]; then
        echo -n "Removed superfluous Docker volume: "
        ${pkgs.docker}/bin/docker volume rm "$vol" || true
      fi
    done <<< "$vsuperfluous"
  '';

  mkNetworkOpts = opts: concatStringsSep " "
    ([ "--driver=${opts.driver}" ]
    ++ optional (cfg ? subnet && cfg.subnet != null) "--subnet=${opts.subnet}"
    ++ optional (cfg ? ip-range && cfg.ip-range != null) "--ip-range=${opts.ip-range}"
    ++ optional (cfg ? gateway && cfg.gateway != null) "--gateway=${opts.gateway}"
    ++ optional (cfg ? ipv6 && cfg.ipv6) "--ipv6"
    ++ optional (cfg ? internal && cfg.internal) "--internal");


  mkNetwork = name: opts: ''
    if [[ $(${pkgs.docker}/bin/docker network ls --quiet --filter name=${name} | wc -c) -eq 0 ]]; then
      echo "*** docker network create ${mkNetworkOpts opts} ${name}"
      ${pkgs.docker}/bin/docker network create ${mkNetworkOpts opts} ${name}
    fi
  '';

  mkVolume = name: ''
    if [[ $(${pkgs.docker}/bin/docker volume ls --quiet --filter name=${name} | wc -c) -eq 0 ]]; then
      echo "*** docker volume create ${name}"
      ${pkgs.docker}/bin/docker volume create ${name}
    fi
  '';
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
        default = ["/run/docker.sock"];
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
            containers which are created with the
            <literal>--restart=always</literal> flag to work. If this option is
            disabled, docker might be started on demand by socket activation.
          '';
      };

    enableNvidia =
      mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable nvidia-docker wrapper, supporting NVIDIA GPUs inside docker containers.
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

    logLevel =
      mkOption {
        type = types.enum ["debug" "info" "warn" "error" "fatal"];
        default = "info";
        description =
          ''
            This option determines the log level for the Docker daemon.
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

    autoPrune = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to periodically prune Docker resources. If enabled, a
          systemd timer will run <literal>docker system prune -f</literal>
          as specified by the <literal>dates</literal> option.
        '';
      };

      flags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--all" ];
        description = ''
          Any additional flags passed to <command>docker system prune</command>.
        '';
      };

      dates = mkOption {
        default = "weekly";
        type = types.str;
        description = ''
          Specification (in the format described by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>) of the time at
          which the prune will occur.
        '';
      };
    };

    package = mkOption {
      default = pkgs.docker;
      type = types.package;
      example = pkgs.docker-edge;
      description = ''
        Docker package to be used in the module.
      '';
    };

    volumes = mkOption {
      default = [];
      type = types.listOf types.str;
      example = [ "volume_1" "volume_2" ];
      description = ''
        A list of named volumes that should be created.
      '';
    };


    networks = mkOption {
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          driver = mkOption {
            default = "bridge";
            type = types.str;
            example = "overlay";
            description = ''
              Driver to manage the network. One of bridge, or overlay.
            '';
          };

          subnet = mkOption {
            default = null;
            type = types.nullOr types.str;
            example = "172.28.0.0/16";
            description = ''
              Subnet in CIDR format that represents a network segment.
            '';
          };

          ip-range = mkOption {
            default = null;
            type = types.nullOr types.str;
            example = "172.28.5.0/24";
            description = ''
              Allocate container ip from a sub-range.
            '';
          };

          gateway = mkOption {
            default = null;
            type = types.nullOr types.str;
            example = "172.28.5.254";
            description = ''
              IPv4 or IPv6 Gateway for the master subnet.
            '';
          };

          ipv6 = mkOption {
            default = false;
            type = types.bool;
            example = true;
            description = ''
              Enable IPv6 networking.
            '';
          };

          internal = mkOption {
            default = false;
            type = types.bool;
            example = true;
            description = ''
              Restrict external access to the network.
            '';
          };
        };
      });

      example = {
        my-network = {
          driver = "bridge";
          subnet = "172.28.0.0/16";
          ip-range = "172.28.5.0/24";
          gateway = "172.28.5.254";
        };
      };

      description = ''
        A list of named networks to be created.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable (mkMerge [{
      environment.systemPackages = [ cfg.package ]
        ++ optional cfg.enableNvidia pkgs.nvidia-docker;
      users.groups.docker.gid = config.ids.gids.docker;
      systemd.packages = [ cfg.package ];

      systemd.services.docker = {
        wantedBy = optional cfg.enableOnBoot "multi-user.target";
        environment = proxy_env;

        postStart = mkUncreateMaybe (attrNames cfg.networks) cfg.volumes
                  + concatStrings (mapAttrsToList mkNetwork cfg.networks)
                  + concatStrings (map mkVolume cfg.volumes);

        serviceConfig = {
          ExecStart = [
            ""
            ''
              ${cfg.package}/bin/dockerd \
                --group=docker \
                --host=fd:// \
                --log-driver=${cfg.logDriver} \
                --log-level=${cfg.logLevel} \
                ${optionalString (cfg.storageDriver != null) "--storage-driver=${cfg.storageDriver}"} \
                ${optionalString cfg.liveRestore "--live-restore" } \
                ${optionalString cfg.enableNvidia "--add-runtime nvidia=${pkgs.nvidia-docker}/bin/nvidia-container-runtime" } \
                ${cfg.extraOptions}
            ''];

          ExecReload=[
            ""
            "${pkgs.procps}/bin/kill -s HUP $MAINPID"
          ];
        };

        path = [ pkgs.kmod ] ++ optional (cfg.storageDriver == "zfs") pkgs.zfs
          ++ optional cfg.enableNvidia pkgs.nvidia-docker;
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
      };

      assertions = [
        { assertion = cfg.enableNvidia -> config.hardware.opengl.driSupport32Bit or false;
          message = "Option enableNvidia requires 32bit support libraries";
        }];
    }
    (mkIf cfg.enableNvidia {
      environment.etc."nvidia-container-runtime/config.toml".source = "${pkgs.nvidia-docker}/etc/config.toml";
    })
  ]);

  imports = [
    (mkRemovedOptionModule ["virtualisation" "docker" "socketActivation"] "This option was removed in favor of starting docker at boot")
  ];

}
