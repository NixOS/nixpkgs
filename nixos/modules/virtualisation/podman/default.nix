{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.podman;
  json = pkgs.formats.json { };

  inherit (lib) mkOption types;

  podmanPackage = pkgs.podman.override {
    extraPackages =
      cfg.extraPackages
      # setuid shadow
      ++ [ "/run/wrappers" ]
      ++ lib.optional (config.boot.supportedFilesystems.zfs or false) config.boot.zfs.package;
    extraRuntimes =
      [ pkgs.runc ]
      ++ lib.optionals
        (
          config.virtualisation.containers.containersConf.settings.network.default_rootless_network_cmd or ""
          == "slirp4netns"
        )
        (
          with pkgs;
          [
            slirp4netns
          ]
        );
  };

  # Provides a fake "docker" binary mapping to podman
  dockerCompat =
    pkgs.runCommand "${podmanPackage.pname}-docker-compat-${podmanPackage.version}"
      {
        outputs = [
          "out"
          "man"
        ];
        inherit (podmanPackage) meta;
        preferLocalBuild = true;
      }
      ''
        mkdir -p $out/bin
        ln -s ${podmanPackage}/bin/podman $out/bin/docker

        mkdir -p $man/share/man/man1
        for f in ${podmanPackage.man}/share/man/man1/*; do
          basename=$(basename $f | sed s/podman/docker/g)
          ln -s $f $man/share/man/man1/$basename
        done
      '';

in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "virtualisation"
      "podman"
      "defaultNetwork"
      "dnsname"
    ] "Use virtualisation.podman.defaultNetwork.settings.dns_enabled instead.")
    (lib.mkRemovedOptionModule [
      "virtualisation"
      "podman"
      "defaultNetwork"
      "extraPlugins"
    ] "Netavark isn't compatible with CNI plugins.")
    ./network-socket.nix
  ];

  meta = {
    maintainers = lib.teams.podman.members;
  };

  options.virtualisation.podman = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This option enables Podman, a daemonless container engine for
        developing, managing, and running OCI Containers on your Linux System.

        It is a drop-in replacement for the {command}`docker` command.
      '';
    };

    dockerSocket.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Make the Podman socket available in place of the Docker socket, so
        Docker tools can find the Podman socket.

        Podman implements the Docker API.

        Users must be in the `podman` group in order to connect. As
        with Docker, members of this group can gain root access.
      '';
    };

    dockerCompat = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Create an alias mapping {command}`docker` to {command}`podman`.
      '';
    };

    enableNvidia = mkOption {
      type = types.bool;
      default = false;
      description = ''
        **Deprecated**, please use hardware.nvidia-container-toolkit.enable instead.

        Enable use of Nvidia GPUs from within podman containers.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = lib.literalExpression ''
        [
          pkgs.gvisor
        ]
      '';
      description = ''
        Extra packages to be installed in the Podman wrapper.
      '';
    };

    autoPrune = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to periodically prune Podman resources. If enabled, a
          systemd timer will run `podman system prune -f`
          as specified by the `dates` option.
        '';
      };

      flags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "--all" ];
        description = ''
          Any additional flags passed to {command}`podman system prune`.
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
    };

    package = lib.mkOption {
      type = types.package;
      default = podmanPackage;
      internal = true;
      description = ''
        The final Podman package (including extra packages).
      '';
    };

    defaultNetwork.settings = lib.mkOption {
      type = json.type;
      default = { };
      example = lib.literalExpression "{ dns_enabled = true; }";
      description = ''
        Settings for podman's default network.
      '';
    };

  };

  config =
    let
      networkConfig = (
        {
          dns_enabled = false;
          driver = "bridge";
          id = "0000000000000000000000000000000000000000000000000000000000000000";
          internal = false;
          ipam_options = {
            driver = "host-local";
          };
          ipv6_enabled = false;
          name = "podman";
          network_interface = "podman0";
          subnets = [
            {
              gateway = "10.88.0.1";
              subnet = "10.88.0.0/16";
            }
          ];
        }
        // cfg.defaultNetwork.settings
      );
      inherit (networkConfig) dns_enabled network_interface;
    in
    lib.mkIf cfg.enable {
      warnings = lib.optionals cfg.enableNvidia [
        ''
          You have set virtualisation.podman.enableNvidia. This option is deprecated, please set hardware.nvidia-container-toolkit.enable instead.
        ''
      ];

      environment.systemPackages = [ cfg.package ] ++ lib.optional cfg.dockerCompat dockerCompat;

      # https://github.com/containers/podman/blob/097cc6eb6dd8e598c0e8676d21267b4edb11e144/docs/tutorials/basic_networking.md#default-network
      environment.etc."containers/networks/podman.json" = lib.mkIf (cfg.defaultNetwork.settings != { }) {
        source = json.generate "podman.json" networkConfig;
      };

      # containers cannot reach aardvark-dns otherwise
      networking.firewall.interfaces.${network_interface}.allowedUDPPorts = lib.mkIf dns_enabled [ 53 ];

      virtualisation.containers = {
        enable = true; # Enable common /etc/containers configuration
        containersConf.settings = {
          network.network_backend = "netavark";
        };
      };

      systemd.packages = [ cfg.package ];

      systemd.services.podman-prune = {
        description = "Prune podman resources";

        restartIfChanged = false;
        unitConfig.X-StopOnRemoval = false;

        serviceConfig.Type = "oneshot";

        script = ''
          ${cfg.package}/bin/podman system prune -f ${toString cfg.autoPrune.flags}
        '';

        startAt = lib.optional cfg.autoPrune.enable cfg.autoPrune.dates;
        after = [ "podman.service" ];
        requires = [ "podman.service" ];
      };

      systemd.services.podman.environment = config.networking.proxy.envVars;
      systemd.sockets.podman.wantedBy = [ "sockets.target" ];
      systemd.sockets.podman.socketConfig.SocketGroup = "podman";
      # Podman does not support multiple sockets, as of podman 5.0.2, so we use
      # a symlink. Unfortunately this does not let us use an alternate group,
      # such as `docker`.
      systemd.sockets.podman.socketConfig.Symlinks = lib.mkIf cfg.dockerSocket.enable [
        "/run/docker.sock"
      ];

      systemd.user.services.podman.environment = config.networking.proxy.envVars;
      systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];

      systemd.timers.podman-prune.timerConfig = lib.mkIf cfg.autoPrune.enable {
        Persistent = true;
        RandomizedDelaySec = 1800;
      };

      systemd.tmpfiles.packages = [
        # The /run/podman rule interferes with our podman group, so we remove
        # it and let the systemd socket logic take care of it.
        (pkgs.runCommand "podman-tmpfiles-nixos"
          {
            package = cfg.package;
            preferLocalBuild = true;
          }
          ''
            mkdir -p $out/lib/tmpfiles.d/
            grep -v 'D! /run/podman 0700 root root' \
              <$package/lib/tmpfiles.d/podman.conf \
              >$out/lib/tmpfiles.d/podman.conf
          ''
        )
      ];

      users.groups.podman = { };

      assertions = [
        {
          assertion = cfg.dockerCompat -> !config.virtualisation.docker.enable;
          message = "Option dockerCompat conflicts with docker";
        }
        {
          assertion = cfg.dockerSocket.enable -> !config.virtualisation.docker.enable;
          message = ''
            The options virtualisation.podman.dockerSocket.enable and virtualisation.docker.enable conflict, because only one can serve the socket.
          '';
        }
      ];
    };
}
