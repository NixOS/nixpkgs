{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.docker-containers;

  dockerContainer =
    { name, config, ... }: {

      options = {
        image = mkOption {
          type = types.str;
          description = "Docker image to run.";
        };
        cmd = mkOption {
          type =  with types; listOf string;
          default = [];
          description = "Commandline arguments to pass to the image's entrypoint.";
        };
        entrypoint = mkOption {
          type = types.nullOr types.string;
          description = "Overwrite the default entrypoint of the image.";
          default = null;
        };
        volumes = mkOption {
          type = with types; listOf string;
          default = [];
          description = "List of volumes to attach to this container.";
          example = [
            "volume_name:/path/inside/container"
            "/path/on/host:/path/inside/container"
          ];
        };
        extraDockerOptions = mkOption {
          type = with types; listOf string;
          default = [];
          description = "Extra options for `docker run`.";
          example = ["--network=host"];
        };
      };
    };

  mkService = name: container:
    let containerName = "nixos-${name}"; in {
      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" "docker.socket" ];
      requires = [ "docker.service" "docker.socket" ];
      script = lib.concatStringsSep " " ([
        "exec ${pkgs.docker}/bin/docker run"
        "--rm"
        "--name=${containerName}"
      ] ++ lib.optional (! isNull container.entrypoint)
        "--entrypoint=${lib.escapeShellArg container.entrypoint}"
        ++ (map (v: "-v ${lib.escapeShellArg v}") container.volumes)
        ++ [
          (lib.escapeShellArgs container.extraDockerOptions)
          container.image
        ]
      );
      scriptArgs = lib.escapeShellArgs container.cmd;
      preStop = "${pkgs.docker}/bin/docker stop ${containerName}";
      reload = "${pkgs.docker}/bin/docker restart ${containerName}";
      serviceConfig = {
        ExecStartPre = "-${pkgs.docker}/bin/docker rm -f ${containerName}";
        ExecStopPost = "-${pkgs.docker}/bin/docker rm -f ${containerName}";
        TimeoutStartSec = 0;
        TimeoutStopSec = 120;
        Restart = "always";
      };
    };

in {

  options.docker-containers = mkOption {
    default = {};
    type = types.attrsOf (types.submodule dockerContainer);
    description = "Docker containers to run.";
  };

  config = {

    systemd.services = lib.mapAttrs' (n: v: lib.nameValuePair "docker-${n}" (mkService n v)) cfg;

    virtualisation.docker.enable = true;

  };

}
