{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.virtualisation.oci-containers;
  proxy_env = config.networking.proxy.envVars;

  defaultBackend = options.virtualisation.oci-containers.backend.default;

  containerOptions =
    { ... }: {

      options = {

        image = mkOption {
          type = with types; str;
          description = "OCI image to run.";
          example = "library/hello-world";
        };

        imageFile = mkOption {
          type = with types; nullOr package;
          default = null;
          description = ''
            Path to an image file to load before running the image. This can
            be used to bypass pulling the image from the registry.

            The <literal>image</literal> attribute must match the name and
            tag of the image contained in this file, as they will be used to
            run the container with that image. If they do not match, the
            image will be pulled from the registry as usual.
          '';
          example = literalExpression "pkgs.dockerTools.buildImage {...};";
        };

        login = {

          username = mkOption {
            type = with types; nullOr str;
            default = null;
            description = "Username for login.";
          };

          passwordFile = mkOption {
            type = with types; nullOr str;
            default = null;
            description = "Path to file containing password.";
            example = "/etc/nixos/dockerhub-password.txt";
          };

          registry = mkOption {
            type = with types; nullOr str;
            default = null;
            description = "Registry where to login to.";
            example = "https://docker.pkg.github.com";
          };

        };

        cmd = mkOption {
          type =  with types; listOf str;
          default = [];
          description = "Commandline arguments to pass to the image's entrypoint.";
          example = literalExpression ''
            ["--port=9000"]
          '';
        };

        entrypoint = mkOption {
          type = with types; nullOr str;
          description = "Override the default entrypoint of the image.";
          default = null;
          example = "/bin/my-app";
        };

        environment = mkOption {
          type = with types; attrsOf str;
          default = {};
          description = "Environment variables to set for this container.";
          example = literalExpression ''
            {
              DATABASE_HOST = "db.example.com";
              DATABASE_PORT = "3306";
            }
        '';
        };

        environmentFiles = mkOption {
          type = with types; listOf path;
          default = [];
          description = "Environment files for this container.";
          example = literalExpression ''
            [
              /path/to/.env
              /path/to/.env.secret
            ]
        '';
        };

        log-driver = mkOption {
          type = types.str;
          default = "journald";
          description = ''
            Logging driver for the container.  The default of
            <literal>"journald"</literal> means that the container's logs will be
            handled as part of the systemd unit.

            For more details and a full list of logging drivers, refer to respective backends documentation.

            For Docker:
            <link xlink:href="https://docs.docker.com/engine/reference/run/#logging-drivers---log-driver">Docker engine documentation</link>

            For Podman:
            Refer to the docker-run(1) man page.
          '';
        };

        ports = mkOption {
          type = with types; listOf str;
          default = [];
          description = ''
            Network ports to publish from the container to the outer host.

            Valid formats:

            <itemizedlist>
              <listitem>
                <para>
                  <literal>&lt;ip&gt;:&lt;hostPort&gt;:&lt;containerPort&gt;</literal>
                </para>
              </listitem>
              <listitem>
                <para>
                  <literal>&lt;ip&gt;::&lt;containerPort&gt;</literal>
                </para>
              </listitem>
              <listitem>
                <para>
                  <literal>&lt;hostPort&gt;:&lt;containerPort&gt;</literal>
                </para>
              </listitem>
              <listitem>
                <para>
                  <literal>&lt;containerPort&gt;</literal>
                </para>
              </listitem>
            </itemizedlist>

            Both <literal>hostPort</literal> and
            <literal>containerPort</literal> can be specified as a range of
            ports.  When specifying ranges for both, the number of container
            ports in the range must match the number of host ports in the
            range.  Example: <literal>1234-1236:1234-1236/tcp</literal>

            When specifying a range for <literal>hostPort</literal> only, the
            <literal>containerPort</literal> must <emphasis>not</emphasis> be a
            range.  In this case, the container port is published somewhere
            within the specified <literal>hostPort</literal> range.  Example:
            <literal>1234-1236:1234/tcp</literal>

            Refer to the
            <link xlink:href="https://docs.docker.com/engine/reference/run/#expose-incoming-ports">
            Docker engine documentation</link> for full details.
          '';
          example = literalExpression ''
            [
              "8080:9000"
            ]
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
          type = with types; listOf str;
          default = [];
          description = ''
            List of volumes to attach to this container.

            Note that this is a list of <literal>"src:dst"</literal> strings to
            allow for <literal>src</literal> to refer to
            <literal>/nix/store</literal> paths, which would be difficult with an
            attribute set.  There are also a variety of mount options available
            as a third field; please refer to the
            <link xlink:href="https://docs.docker.com/engine/reference/run/#volume-shared-filesystems">
            docker engine documentation</link> for details.
          '';
          example = literalExpression ''
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

        dependsOn = mkOption {
          type = with types; listOf str;
          default = [];
          description = ''
            Define which other containers this one depends on. They will be added to both After and Requires for the unit.

            Use the same name as the attribute under <literal>virtualisation.oci-containers.containers</literal>.
          '';
          example = literalExpression ''
            virtualisation.oci-containers.containers = {
              node1 = {};
              node2 = {
                dependsOn = [ "node1" ];
              }
            }
          '';
        };

        extraOptions = mkOption {
          type = with types; listOf str;
          default = [];
          description = "Extra options for <command>${defaultBackend} run</command>.";
          example = literalExpression ''
            ["--network=host"]
          '';
        };

        autoStart = mkOption {
          type = types.bool;
          default = true;
          description = ''
            When enabled, the container is automatically started on boot.
            If this option is set to false, the container has to be started on-demand via its service.
          '';
        };
      };
    };

  isValidLogin = login: login.username != null && login.passwordFile != null && login.registry != null;

  mkService = name: container: let
    dependsOn = map (x: "${cfg.backend}-${x}.service") container.dependsOn;
  in {
    wantedBy = [] ++ optional (container.autoStart) "multi-user.target";
    after = lib.optionals (cfg.backend == "docker") [ "docker.service" "docker.socket" ] ++ dependsOn;
    requires = dependsOn;
    environment = proxy_env;

    path =
      if cfg.backend == "docker" then [ config.virtualisation.docker.package ]
      else if cfg.backend == "podman" then [ config.virtualisation.podman.package ]
      else throw "Unhandled backend: ${cfg.backend}";

    preStart = ''
      ${cfg.backend} rm -f ${name} || true
      ${optionalString (isValidLogin container.login) ''
        cat ${container.login.passwordFile} | \
          ${cfg.backend} login \
            ${container.login.registry} \
            --username ${container.login.username} \
            --password-stdin
        ''}
      ${optionalString (container.imageFile != null) ''
        ${cfg.backend} load -i ${container.imageFile}
        ''}
      '';

    script = concatStringsSep " \\\n  " ([
      "exec ${cfg.backend} run"
      "--rm"
      "--name=${escapeShellArg name}"
      "--log-driver=${container.log-driver}"
    ] ++ optional (container.entrypoint != null)
      "--entrypoint=${escapeShellArg container.entrypoint}"
      ++ (mapAttrsToList (k: v: "-e ${escapeShellArg k}=${escapeShellArg v}") container.environment)
      ++ map (f: "--env-file ${escapeShellArg f}") container.environmentFiles
      ++ map (p: "-p ${escapeShellArg p}") container.ports
      ++ optional (container.user != null) "-u ${escapeShellArg container.user}"
      ++ map (v: "-v ${escapeShellArg v}") container.volumes
      ++ optional (container.workdir != null) "-w ${escapeShellArg container.workdir}"
      ++ map escapeShellArg container.extraOptions
      ++ [container.image]
      ++ map escapeShellArg container.cmd
    );

    preStop = "[ $SERVICE_RESULT = success ] || ${cfg.backend} stop ${name}";
    postStop = "${cfg.backend} rm -f ${name} || true";

    serviceConfig = {
      ### There is no generalized way of supporting `reload` for docker
      ### containers. Some containers may respond well to SIGHUP sent to their
      ### init process, but it is not guaranteed; some apps have other reload
      ### mechanisms, some don't have a reload signal at all, and some docker
      ### images just have broken signal handling.  The best compromise in this
      ### case is probably to leave ExecReload undefined, so `systemctl reload`
      ### will at least result in an error instead of potentially undefined
      ### behaviour.
      ###
      ### Advanced users can still override this part of the unit to implement
      ### a custom reload handler, since the result of all this is a normal
      ### systemd service from the perspective of the NixOS module system.
      ###
      # ExecReload = ...;
      ###

      TimeoutStartSec = 0;
      TimeoutStopSec = 120;
      Restart = "always";
    };
  };

in {
  imports = [
    (
      lib.mkChangedOptionModule
      [ "docker-containers"  ]
      [ "virtualisation" "oci-containers" ]
      (oldcfg: {
        backend = "docker";
        containers = lib.mapAttrs (n: v: builtins.removeAttrs (v // {
          extraOptions = v.extraDockerOptions or [];
        }) [ "extraDockerOptions" ]) oldcfg.docker-containers;
      })
    )
  ];

  options.virtualisation.oci-containers = {

    backend = mkOption {
      type = types.enum [ "podman" "docker" ];
      default =
        # TODO: Once https://github.com/NixOS/nixpkgs/issues/77925 is resolved default to podman
        # if versionAtLeast config.system.stateVersion "20.09" then "podman"
        # else "docker";
        "docker";
      description = "The underlying Docker implementation to use.";
    };

    containers = mkOption {
      default = {};
      type = types.attrsOf (types.submodule containerOptions);
      description = "OCI (Docker) containers to run as systemd services.";
    };

  };

  config = lib.mkIf (cfg.containers != {}) (lib.mkMerge [
    {
      systemd.services = mapAttrs' (n: v: nameValuePair "${cfg.backend}-${n}" (mkService n v)) cfg.containers;
    }
    (lib.mkIf (cfg.backend == "podman") {
      virtualisation.podman.enable = true;
    })
    (lib.mkIf (cfg.backend == "docker") {
      virtualisation.docker.enable = true;
    })
  ]);

}
