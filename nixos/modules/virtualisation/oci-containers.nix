{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.virtualisation.oci-containers;
  proxy_env = config.networking.proxy.envVars;

  defaultBackend = options.virtualisation.oci-containers.backend.default;

  containerOptions =
    { ... }:
    {

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

            The `image` attribute must match the name and
            tag of the image contained in this file, as they will be used to
            run the container with that image. If they do not match, the
            image will be pulled from the registry as usual.
          '';
          example = literalExpression "pkgs.dockerTools.buildImage {...};";
        };

        imageStream = mkOption {
          type = with types; nullOr package;
          default = null;
          description = ''
            Path to a script that streams the desired image on standard output.

            This option is mainly intended for use with
            `pkgs.dockerTools.streamLayeredImage` so that the intermediate
            image archive does not need to be stored in the Nix store.  For
            larger images this optimization can significantly reduce Nix store
            churn compared to using the `imageFile` option, because you don't
            have to store a new copy of the image archive in the Nix store
            every time you change the image.  Instead, if you stream the image
            then you only need to build and store the layers that differ from
            the previous image.
          '';
          example = literalExpression "pkgs.dockerTools.streamLayeredImage {...};";
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
          type = with types; listOf str;
          default = [ ];
          description = "Commandline arguments to pass to the image's entrypoint.";
          example = literalExpression ''
            ["--port=9000"]
          '';
        };

        labels = mkOption {
          type = with types; attrsOf str;
          default = { };
          description = "Labels to attach to the container at runtime.";
          example = literalExpression ''
            {
              "traefik.https.routers.example.rule" = "Host(`example.container`)";
            }
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
          default = { };
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
          default = [ ];
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
            `"journald"` means that the container's logs will be
            handled as part of the systemd unit.

            For more details and a full list of logging drivers, refer to respective backends documentation.

            For Docker:
            [Docker engine documentation](https://docs.docker.com/engine/logging/configure/)

            For Podman:
            Refer to the docker-run(1) man page.
          '';
        };

        ports = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = ''
            Network ports to publish from the container to the outer host.

            Valid formats:
            - `<ip>:<hostPort>:<containerPort>`
            - `<ip>::<containerPort>`
            - `<hostPort>:<containerPort>`
            - `<containerPort>`

            Both `hostPort` and `containerPort` can be specified as a range of
            ports.  When specifying ranges for both, the number of container
            ports in the range must match the number of host ports in the
            range.  Example: `1234-1236:1234-1236/tcp`

            When specifying a range for `hostPort` only, the `containerPort`
            must *not* be a range.  In this case, the container port is published
            somewhere within the specified `hostPort` range.
            Example: `1234-1236:1234/tcp`

            Publishing a port bypasses the NixOS firewall. If the port is not
            supposed to be shared on the network, make sure to publish the
            port to localhost.
            Example: `127.0.0.1:1234:1234`

            Refer to the
            [Docker engine documentation](https://docs.docker.com/engine/network/#published-ports) for full details.
          '';
          example = literalExpression ''
            [
              "127.0.0.1:8080:9000"
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
          default = [ ];
          description = ''
            List of volumes to attach to this container.

            Note that this is a list of `"src:dst"` strings to
            allow for `src` to refer to `/nix/store` paths, which
            would be difficult with an attribute set.  There are
            also a variety of mount options available as a third
            field; please refer to the
            [docker engine documentation](https://docs.docker.com/engine/storage/volumes/) for details.
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
          default = [ ];
          description = ''
            Define which other containers this one depends on. They will be added to both After and Requires for the unit.

            Use the same name as the attribute under `virtualisation.oci-containers.containers`.
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

        hostname = mkOption {
          type = with types; nullOr str;
          default = null;
          description = "The hostname of the container.";
          example = "hello-world";
        };

        preRunExtraOptions = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = "Extra options for {command}`${defaultBackend}` that go before the `run` argument.";
          example = [
            "--runtime"
            "runsc"
          ];
        };

        extraOptions = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = "Extra options for {command}`${defaultBackend} run`.";
          example = literalExpression ''
            ["--network=host"]
          '';
        };

        autoStart = mkOption {
          type = with types; bool;
          default = true;
          description = ''
            When enabled, the container is automatically started on boot.
            If this option is set to false, the container has to be started on-demand via its service.
          '';
        };

        pull = mkOption {
          type =
            with types;
            enum [
              "always"
              "missing"
              "never"
              "newer"
            ];
          default = "missing";
          description = ''
            Image pull policy for the container. Must be one of: always, missing, never, newer
          '';
        };

        capAdd = mkOption {
          type = with types; lazyAttrsOf (nullOr bool);
          default = { };
          description = ''
            Capabilities to add to container
          '';
          example = literalExpression ''
            {
              SYS_ADMIN = true;
            {
          '';
        };

        capDrop = mkOption {
          type = with types; lazyAttrsOf (nullOr bool);
          default = { };
          description = ''
            Capabilities to drop from container
          '';
          example = literalExpression ''
            {
              SYS_ADMIN = true;
            {
          '';
        };

        devices = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = ''
            List of devices to attach to this container.
          '';
          example = literalExpression ''
            [
              "/dev/dri:/dev/dri"
            ]
          '';
        };

        privileged = mkOption {
          type = with types; bool;
          default = false;
          description = ''
            Give extended privileges to the container
          '';
        };

        networks = mkOption {
          type = with types; listOf str;
          default = [ ];
          description = ''
            Networks to attach the container to
          '';
        };
      };
    };

  isValidLogin =
    login: login.username != null && login.passwordFile != null && login.registry != null;

  mkService =
    name: container:
    let
      dependsOn = map (x: "${cfg.backend}-${x}.service") container.dependsOn;
      escapedName = escapeShellArg name;
      preStartScript = pkgs.writeShellApplication {
        name = "pre-start";
        runtimeInputs = [ ];
        text = ''
          ${cfg.backend} rm -f ${name} || true
          ${optionalString (isValidLogin container.login) ''
            # try logging in, if it fails, check if image exists locally
            ${cfg.backend} login \
            ${container.login.registry} \
            --username ${container.login.username} \
            --password-stdin < ${container.login.passwordFile} \
            || ${cfg.backend} image inspect ${container.image} >/dev/null \
            || { echo "image doesn't exist locally and login failed" >&2 ; exit 1; }
          ''}
          ${optionalString (container.imageFile != null) ''
            ${cfg.backend} load -i ${container.imageFile}
          ''}
          ${optionalString (container.imageStream != null) ''
            ${container.imageStream} | ${cfg.backend} load
          ''}
          ${optionalString (cfg.backend == "podman") ''
            rm -f /run/podman-${escapedName}.ctr-id
          ''}
        '';
      };
    in
    {
      wantedBy = [ ] ++ optional (container.autoStart) "multi-user.target";
      wants = lib.optional (
        container.imageFile == null && container.imageStream == null
      ) "network-online.target";
      after =
        lib.optionals (cfg.backend == "docker") [
          "docker.service"
          "docker.socket"
        ]
        # if imageFile or imageStream is not set, the service needs the network to download the image from the registry
        ++ lib.optionals (container.imageFile == null && container.imageStream == null) [
          "network-online.target"
        ]
        ++ dependsOn;
      requires = dependsOn;
      environment = proxy_env;

      path =
        if cfg.backend == "docker" then
          [ config.virtualisation.docker.package ]
        else if cfg.backend == "podman" then
          [ config.virtualisation.podman.package ]
        else
          throw "Unhandled backend: ${cfg.backend}";

      script = concatStringsSep " \\\n  " (
        [
          "exec ${cfg.backend} "
        ]
        ++ map escapeShellArg container.preRunExtraOptions
        ++ [
          "run"
          "--rm"
          "--name=${escapedName}"
          "--log-driver=${container.log-driver}"
        ]
        ++ optional (container.entrypoint != null) "--entrypoint=${escapeShellArg container.entrypoint}"
        ++ optional (container.hostname != null) "--hostname=${escapeShellArg container.hostname}"
        ++ lib.optionals (cfg.backend == "podman") [
          "--cidfile=/run/podman-${escapedName}.ctr-id"
          "--cgroups=no-conmon"
          "--sdnotify=conmon"
          "-d"
          "--replace"
        ]
        ++ (mapAttrsToList (k: v: "-e ${escapeShellArg k}=${escapeShellArg v}") container.environment)
        ++ map (f: "--env-file ${escapeShellArg f}") container.environmentFiles
        ++ map (p: "-p ${escapeShellArg p}") container.ports
        ++ optional (container.user != null) "-u ${escapeShellArg container.user}"
        ++ map (v: "-v ${escapeShellArg v}") container.volumes
        ++ (mapAttrsToList (k: v: "-l ${escapeShellArg k}=${escapeShellArg v}") container.labels)
        ++ optional (container.workdir != null) "-w ${escapeShellArg container.workdir}"
        ++ optional (container.privileged) "--privileged"
        ++ mapAttrsToList (k: _: "--cap-add=${escapeShellArg k}") (
          filterAttrs (_: v: v == true) container.capAdd
        )
        ++ mapAttrsToList (k: _: "--cap-drop=${escapeShellArg k}") (
          filterAttrs (_: v: v == true) container.capDrop
        )
        ++ map (d: "--device=${escapeShellArg d}") container.devices
        ++ map (n: "--network=${escapeShellArg n}") container.networks
        ++ [ "--pull ${escapeShellArg container.pull}" ]
        ++ map escapeShellArg container.extraOptions
        ++ [ container.image ]
        ++ map escapeShellArg container.cmd
      );

      preStop =
        if cfg.backend == "podman" then
          "podman stop --ignore --cidfile=/run/podman-${escapedName}.ctr-id"
        else
          "${cfg.backend} stop ${name} || true";

      postStop =
        if cfg.backend == "podman" then
          "podman rm -f --ignore --cidfile=/run/podman-${escapedName}.ctr-id"
        else
          "${cfg.backend} rm -f ${name} || true";

      serviceConfig =
        {
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
          ExecStartPre = [ "${preStartScript}/bin/pre-start" ];
          TimeoutStartSec = 0;
          TimeoutStopSec = 120;
          Restart = "always";
        }
        // optionalAttrs (cfg.backend == "podman") {
          Environment = "PODMAN_SYSTEMD_UNIT=podman-${name}.service";
          Type = "notify";
          NotifyAccess = "all";
        };
    };

in
{
  imports = [
    (lib.mkChangedOptionModule [ "docker-containers" ] [ "virtualisation" "oci-containers" ] (oldcfg: {
      backend = "docker";
      containers = lib.mapAttrs (
        n: v:
        builtins.removeAttrs (
          v
          // {
            extraOptions = v.extraDockerOptions or [ ];
          }
        ) [ "extraDockerOptions" ]
      ) oldcfg.docker-containers;
    }))
  ];

  options.virtualisation.oci-containers = {

    backend = mkOption {
      type = types.enum [
        "podman"
        "docker"
      ];
      default = if versionAtLeast config.system.stateVersion "22.05" then "podman" else "docker";
      description = "The underlying Docker implementation to use.";
    };

    containers = mkOption {
      default = { };
      type = types.attrsOf (types.submodule containerOptions);
      description = "OCI (Docker) containers to run as systemd services.";
    };

  };

  config = lib.mkIf (cfg.containers != { }) (
    lib.mkMerge [
      {
        systemd.services = mapAttrs' (
          n: v: nameValuePair "${cfg.backend}-${n}" (mkService n v)
        ) cfg.containers;

        assertions =
          let
            toAssertion =
              _:
              { imageFile, imageStream, ... }:
              {
                assertion = imageFile == null || imageStream == null;

                message = "You can only define one of imageFile and imageStream";
              };

          in
          lib.mapAttrsToList toAssertion cfg.containers;
      }
      (lib.mkIf (cfg.backend == "podman") {
        virtualisation.podman.enable = true;
      })
      (lib.mkIf (cfg.backend == "docker") {
        virtualisation.docker.enable = true;
      })
    ]
  );

}
