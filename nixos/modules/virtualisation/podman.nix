{ config, lib, pkgs, utils, ... }:
let
  cfg = config.virtualisation.podman;
  toml = pkgs.formats.toml { };
  nvidia-docker = pkgs.nvidia-docker.override { containerRuntimePath = "${pkgs.runc}/bin/runc"; };

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
        containersConf.extraConfig = lib.optionalString cfg.enableNvidia
          (builtins.readFile (toml.generate "podman.nvidia.containers.conf" {
            engine = {
              conmon_env_vars = [ "PATH=${lib.makeBinPath [ nvidia-docker ]}" ];
              runtimes.nvidia = [ "${nvidia-docker}/bin/nvidia-container-runtime" ];
            };
          }));
      };

      assertions = [
        {
          assertion = cfg.dockerCompat -> !config.virtualisation.docker.enable;
          message = "Option dockerCompat conflicts with docker";
        }
        {
          assertion = cfg.enableNvidia -> !config.virtualisation.docker.enableNvidia;
          message = "Option enableNvidia conflicts with docker.enableNvidia";
        }
      ];
    }
    (lib.mkIf cfg.enableNvidia {
      environment.etc."nvidia-container-runtime/config.toml".source = "${nvidia-docker}/etc/podman-config.toml";
    })
  ]);
}
