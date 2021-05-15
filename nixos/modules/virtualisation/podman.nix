{ config, lib, pkgs, utils, ... }:
let
  cfg = config.virtualisation.podman;
  toml = pkgs.formats.toml { };

  inherit (lib) mkOption types;

  podmanPackage = (pkgs.podman.override { inherit (cfg) extraPackages; });

  # Provides a fake "docker" binary mapping to podman
  dockerCompat = pkgs.runCommandNoCC "${podmanPackage.pname}-docker-compat-${podmanPackage.version}" {
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

in
{
  imports = [
    (lib.mkRenamedOptionModule [ "virtualisation" "podman" "libpod" ] [ "virtualisation" "containers" "containersConf" ])
  ];

  meta = {
    maintainers = lib.teams.podman.members;
  };

  options.virtualisation.podman = {

    enable =
      mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option enables Podman, a daemonless container engine for
          developing, managing, and running OCI Containers on your Linux System.

          It is a drop-in replacement for the <command>docker</command> command.
        '';
      };

    dockerCompat = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Create an alias mapping <command>docker</command> to <command>podman</command>.
      '';
    };

    enableNvidia = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable use of NVidia GPUs from within podman containers.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = lib.literalExample ''
        [
          pkgs.gvisor
        ]
      '';
      description = ''
        Extra packages to be installed in the Podman wrapper.
      '';
    };

    package = lib.mkOption {
      type = types.package;
      default = podmanPackage;
      internal = true;
      description = ''
        The final Podman package (including extra packages).
      '';
    };


  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ cfg.package ]
        ++ lib.optional cfg.dockerCompat dockerCompat;

      environment.etc."cni/net.d/87-podman-bridge.conflist".source = utils.copyFile "${pkgs.podman-unwrapped.src}/cni/87-podman-bridge.conflist";

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

      systemd.sockets.podman.wantedBy = [ "sockets.target" ];

      systemd.tmpfiles.packages = [ cfg.package ];

      assertions = [
        {
          assertion = cfg.dockerCompat -> !config.virtualisation.docker.enable;
          message = "Option dockerCompat conflicts with docker";
        }
      ];
    }
  ]);
}
