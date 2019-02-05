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
          literalExample = ''
            ["--port=9000"]
          '';
        };

        entrypoint = mkOption {
          type = with types; nullOr str;
          description = "Overwrite the default entrypoint of the image.";
          default = null;
          example = "/bin/my-app";
        };

        environment = mkOption {
          type = with types; attrsOf str;
          default = {};
          description = "Environment variables to set for this container.";
          literalExample = ''
            {
              DATABASE_HOST = "db.example.com";
              DATABASE_PORT = "3306";
            }
        '';
        };

        log-driver = mkOption {
          type = types.str;
          default = "none";
          description = ''
            Logging driver for the container.  The default of
            <literal>"none"</literal> means that the container's logs will be
            handled as part of the systemd unit.  Setting this to
            <literal>"journald"</literal> will result in duplicate logging, but
            the container's logs will be visible to the <command>docker
            logs</command> command.

            For more details and a full list of logging drivers, refer to the
            <a href="https://docs.docker.com/engine/reference/run/#logging-drivers---log-driver">
            Docker engine documentation</a>
          '';
        };

        ports = mkOption {
          type = with types; attrsOf str;
          default = {};
          description = "Network ports to forward from the host to this container.";
          literalExample = ''
            {
              # "port_on_host" = "port_in_container"
              "8080" = "9000/tcp";
            }
          '';
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
          description = ''
            List of volumes to attach to this container.

            Note that this is a list of <literal>"src:dst"</literal> strings to
            allow for <literal>src</literal> to refer to
            <literal>/nix/store</literal> paths, which would difficult with an
            attribute set.  There are also a variety of mount options available
            as a third field; please refer to the
            <a href="https://docs.docker.com/engine/reference/run/#volume-shared-filesystems">
            docker engine documentation</a> for details.
          '';
          literalExample = ''
            [
              "volume_name:/path/inside/container"
              "/path/on/host:/path/inside/container"
            ]
          '';
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
          description = "Extra options for <command>docker run</command>.";
          literalExample = ''
            ["--network=host"]
          '';
        };
      };
    };

  mkService = name: container: {
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "docker.socket" ];
    requires = [ "docker.service" "docker.socket" ];
    serviceConfig = {
      ExecStart = concatStringsSep " \\\n  " ([
        "${pkgs.docker}/bin/docker run"
        "--rm"
        "--name=%n"
        "--log-driver=${container.log-driver}"
      ] ++ optional (! isNull container.entrypoint)
        "--entrypoint=${escapeShellArg container.entrypoint}"
        ++ (mapAttrsToList (k: v: "-e ${escapeShellArg k}=${escapeShellArg v}") container.environment)
        ++ (mapAttrsToList (k: v: "-p ${escapeShellArg k}:${escapeShellArg v}") container.ports)
        ++ optional (! isNull container.user) "-u ${escapeShellArg container.user}"
        ++ (map (v: "-v ${escapeShellArg v}") container.volumes)
        ++ optional (! isNull container.workdir) "-w ${escapeShellArg container.workdir}"
        ++ map escapeShellArg container.extraDockerOptions
        ++ [container.image]
        ++ map escapeShellArg container.cmd
      );
      ExecStartPre = "-${pkgs.docker}/bin/docker rm -f %n";
      ExecStop = "${pkgs.docker}/bin/docker stop %n";
      ExecStopPost = "-${pkgs.docker}/bin/docker rm -f %n";
      ExecReload = "${pkgs.docker}/bin/docker restart %n";
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
