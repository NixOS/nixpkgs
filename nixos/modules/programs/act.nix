{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.act;
  podmanCfg = config.virtualisation.podman;

  # act looks for the Docker socket and the rootful Podman socket before the
  # rootless one, so point it at the Podman socket of the calling user.
  podmanAct = pkgs.writeShellScriptBin "act" ''
    if [ -z "$DOCKER_HOST" ]; then
      if [ "$UID" = 0 ]; then
        export DOCKER_HOST=unix:///run/podman/podman.sock
      else
        export DOCKER_HOST="unix://''${XDG_RUNTIME_DIR:-/run/user/$UID}/podman/podman.sock"
      fi
    fi
    exec ${lib.getExe cfg.package} "$@"
  '';
in
{
  options.programs.act = {
    enable = lib.mkEnableOption "act, a tool to run GitHub Actions locally";

    package = lib.mkPackageOption pkgs "act" { };

    backend = lib.mkOption {
      type = lib.types.enum [
        "docker"
        "podman"
      ];
      default = "docker";
      description = ''
        Container engine that act runs jobs with.  The selected engine is
        enabled, and act uses it even when both engines are installed.  With
        Podman, act connects to the Podman socket of the calling user, which is
        the rootful one for root, unless {env}`DOCKER_HOST` is set.  With
        Docker, the rootful daemon is not enabled when rootless Docker is, or
        when Podman already provides the {command}`docker` command or socket.

        Upstream only supports Docker, so Podman may not work with every
        workflow.  With rootful Docker, users need to be in the `docker` group.
        When Podman provides the {command}`docker` command or socket instead,
        act uses the rootful Podman socket, which needs the `podman` group.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Wrapper must win over an unwrapped act from another module
    environment.systemPackages = [
      (if cfg.backend == "podman" then lib.hiPrio podmanAct else cfg.package)
    ];

    # Podman's Docker compatibility options conflict with rootful Docker.  Only
    # define true, so that other modules enabling Docker by default still merge.
    virtualisation.docker.enable = lib.mkIf (
      cfg.backend == "docker"
      && !(
        config.virtualisation.docker.rootless.enable
        || podmanCfg.enable && (podmanCfg.dockerCompat || podmanCfg.dockerSocket.enable)
      )
    ) (lib.mkDefault true);
    virtualisation.podman.enable = lib.mkIf (cfg.backend == "podman") (lib.mkDefault true);
  };

  meta.maintainers = with lib.maintainers; [ yiyu ];
}
