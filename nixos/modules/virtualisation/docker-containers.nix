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
          example = "library/hello-world";
        };

        cmd = mkOption {
          type =  with types; listOf str;
          default = [];
          description = "Commandline arguments to pass to the image's entrypoint.";
        };

        entrypoint = mkOption {
          type = with types; nullOr str;
          description = "Overwrite the default entrypoint of the image.";
          default = null;
        };

        environment = mkOption {
          type = with types; attrsOf str;
          default = {};
          description = "Environment variables to set for this container.";
          example = {
            DATABASE_HOST = "db.example.com";
            DATABASE_PORT = "3306";
          };
        };

        log-driver = mkOption {
          type = types.str;
          default = "none";
          description = ''
            Logging driver for the container.  The default of "none" means that
            the container's logs will be handled as part of the systemd unit.
            Setting this to "journald" will result in duplicate logging, but
            the container's logs will be visible to the `docker logs` command.
          '';
        };

        ports = mkOption {
          type = with types; attrsOf str;
          default = {};
          description = "Network ports to forward from the host to this container.";
          example = {
            "8080" = "9000/tcp";
          };
        };

        user = mkOption {
          type = with types; nullOr str;
          default = null;
          description = ''
            Override the username or UID (and optionally groupname or GID) used
            in the container.
          '';
          example = "nobody:nogroup";
        };

        volumes = mkOption {
          # Note: these are "src:dst" lists so it's possible for `src`
          # to refer to a /nix/store path, and for `dst` to include
          # mount options.
          type = with types; listOf str;
          default = [];
          description = "List of volumes to attach to this container.";
          example = [
            "volume_name:/path/inside/container"
            "/path/on/host:/path/inside/container"
          ];
        };

        workdir = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "Override the default working directory for the container.";
          example = "/var/lib/hello_world";
        };

        extraDockerOptions = mkOption {
          type = with types; listOf str;
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
      script = concatStringsSep " \\\n  " ([
        "exec ${pkgs.docker}/bin/docker run"
        "--rm"
        "--name=${containerName}"
        "--log-driver=${container.log-driver}"
      ] ++ optional (! isNull container.entrypoint)
        "--entrypoint=${escapeShellArg container.entrypoint}"
        ++ (mapAttrsToList (k: v: "-e ${escapeShellArg k}=${escapeShellArg v}") container.environment)
        ++ (mapAttrsToList (k: v: "-p ${escapeShellArg k}:${escapeShellArg v}") container.ports)
        ++ optional (! isNull container.user) "-u ${escapeShellArg container.user}"
        ++ (map (v: "-v ${escapeShellArg v}") container.volumes)
        ++ optional (! isNull container.workdir) "-w ${escapeShellArg container.workdir}"
        # I know escapeShellArgs exists; this results in prettier output
        ++ map escapeShellArg container.extraDockerOptions
        ++ [container.image]
      );
      scriptArgs = escapeShellArgs container.cmd;
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

    systemd.services = mapAttrs' (n: v: nameValuePair "docker-${n}" (mkService n v)) cfg;

    virtualisation.docker.enable = true;

  };

}
