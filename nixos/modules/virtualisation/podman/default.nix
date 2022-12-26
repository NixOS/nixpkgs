{ config, lib, pkgs, ... }:
let
  cfg = config.virtualisation.podman;
  toml = pkgs.formats.toml { };
  json = pkgs.formats.json { };

  inherit (lib) mkOption types;

  podmanPackage = (pkgs.podman.override {
    extraPackages = cfg.extraPackages
      ++ lib.optional (builtins.elem "zfs" config.boot.supportedFilesystems) config.boot.zfs.package;
  });

  # Provides a fake "docker" binary mapping to podman
  dockerCompat = pkgs.runCommand "${podmanPackage.pname}-docker-compat-${podmanPackage.version}"
    {
      outputs = [ "out" "man" ];
      inherit (podmanPackage) meta;
    } ''
    mkdir -p $out/bin
    ln -s ${podmanPackage}/bin/podman $out/bin/docker

    mkdir -p $man/share/man/man1
    for f in ${podmanPackage.man}/share/man/man1/*; do
      basename=$(basename $f | sed s/podman/docker/g)
      ln -s $f $man/share/man/man1/$basename
    done
  '';

  net-conflist = pkgs.runCommand "87-podman-bridge.conflist"
    {
      nativeBuildInputs = [ pkgs.jq ];
      extraPlugins = builtins.toJSON cfg.defaultNetwork.extraPlugins;
      jqScript = ''
        . + { "plugins": (.plugins + $extraPlugins) }
      '';
    } ''
    jq <${cfg.package}/etc/cni/net.d/87-podman-bridge.conflist \
      --argjson extraPlugins "$extraPlugins" \
      "$jqScript" \
      >$out
  '';

in
{
  imports = [
    ./dnsname.nix
    ./network-socket.nix
  ];

  meta = {
    maintainers = lib.teams.podman.members;
  };

  options.virtualisation.podman = {

    enable =
      mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          This option enables Podman, a daemonless container engine for
          developing, managing, and running OCI Containers on your Linux System.

          It is a drop-in replacement for the {command}`docker` command.
        '';
      };

    dockerSocket.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
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
      description = lib.mdDoc ''
        Create an alias mapping {command}`docker` to {command}`podman`.
      '';
    };

    enableNvidia = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable use of NVidia GPUs from within podman containers.
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
      description = lib.mdDoc ''
        Extra packages to be installed in the Podman wrapper.
      '';
    };

    autoPrune = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to periodically prune Podman resources. If enabled, a
          systemd timer will run `podman system prune -f`
          as specified by the `dates` option.
        '';
      };

      flags = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--all" ];
        description = lib.mdDoc ''
          Any additional flags passed to {command}`podman system prune`.
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

    package = lib.mkOption {
      type = types.package;
      default = podmanPackage;
      internal = true;
      description = lib.mdDoc ''
        The final Podman package (including extra packages).
      '';
    };

    defaultNetwork.extraPlugins = lib.mkOption {
      type = types.listOf json.type;
      default = [ ];
      description = lib.mdDoc ''
        Extra CNI plugin configurations to add to podman's default network.
      '';
    };

  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ cfg.package ]
        ++ lib.optional cfg.dockerCompat dockerCompat;

      environment.etc."cni/net.d/87-podman-bridge.conflist".source = net-conflist;

      virtualisation.containers = {
        enable = true; # Enable common /etc/containers configuration
        containersConf.settings = lib.optionalAttrs cfg.enableNvidia {
          engine = {
            conmon_env_vars = [ "PATH=${lib.makeBinPath [ pkgs.nvidia-podman ]}" ];
            runtimes.nvidia = [ "${pkgs.nvidia-podman}/bin/nvidia-container-runtime" ];
          };
        };
      };

      systemd.packages = [ cfg.package ];

      systemd.services.podman.serviceConfig = {
        ExecStart = [ "" "${cfg.package}/bin/podman $LOGGING system service" ];
      };

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

      systemd.sockets.podman.wantedBy = [ "sockets.target" ];
      systemd.sockets.podman.socketConfig.SocketGroup = "podman";

      systemd.user.services.podman.serviceConfig = {
        ExecStart = [ "" "${cfg.package}/bin/podman $LOGGING system service" ];
      };

      systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];

      systemd.tmpfiles.packages = [
        # The /run/podman rule interferes with our podman group, so we remove
        # it and let the systemd socket logic take care of it.
        (pkgs.runCommand "podman-tmpfiles-nixos" { package = cfg.package; } ''
          mkdir -p $out/lib/tmpfiles.d/
          grep -v 'D! /run/podman 0700 root root' \
            <$package/lib/tmpfiles.d/podman.conf \
            >$out/lib/tmpfiles.d/podman.conf
        '')
      ];

      systemd.tmpfiles.rules =
        lib.optionals cfg.dockerSocket.enable [
          "L! /run/docker.sock - - - - /run/podman/podman.sock"
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
    }
  ]);
}
