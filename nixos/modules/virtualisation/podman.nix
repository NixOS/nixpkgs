{ config, lib, pkgs, ... }:
let
  cfg = config.virtualisation.podman;

  inherit (lib) mkOption types;

  # Provides a fake "docker" binary mapping to podman
  dockerCompat = pkgs.runCommandNoCC "${pkgs.podman.pname}-docker-compat-${pkgs.podman.version}" {
    outputs = [ "out" "bin" "man" ];
    inherit (pkgs.podman) meta;
  } ''
    mkdir $out

    mkdir -p $bin/bin
    ln -s ${pkgs.podman.bin}/bin/podman $bin/bin/docker

    mkdir -p $man/share/man/man1
    for f in ${pkgs.podman.man}/share/man/man1/*; do
      basename=$(basename $f | sed s/podman/docker/g)
      ln -s $f $man/share/man/man1/$basename
    done
  '';

  # Copy configuration files to avoid having the entire sources in the system closure
  copyFile = filePath: pkgs.runCommandNoCC (builtins.unsafeDiscardStringContext (builtins.baseNameOf filePath)) {} ''
    cp ${filePath} $out
  '';

in
{
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

  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.podman # Docker compat
      pkgs.runc # Default container runtime
      pkgs.crun # Default container runtime (cgroups v2)
      pkgs.conmon # Container runtime monitor
      pkgs.slirp4netns # User-mode networking for unprivileged namespaces
      pkgs.fuse-overlayfs # CoW for images, much faster than default vfs
      pkgs.utillinux # nsenter
      pkgs.cni-plugins # Networking plugins
      pkgs.iptables
    ]
    ++ lib.optional cfg.dockerCompat dockerCompat;

    environment.etc."cni/net.d/87-podman-bridge.conflist".source = copyFile "${pkgs.podman.src}/cni/87-podman-bridge.conflist";

    virtualisation.containers.enable = true;

  };

}
