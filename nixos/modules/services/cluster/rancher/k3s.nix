{
  config,
  lib,
  mkRancherModule,
  ...
}:
let
  cfg = config.services.k3s;
  baseModule = mkRancherModule {
    name = "k3s";
    extraBinFlags =
      (lib.optional cfg.clusterInit "--cluster-init")
      ++ (lib.optional cfg.disableAgent "--disable-agent");
  };

  removeOption =
    config: instruction:
    lib.mkRemovedOptionModule (
      [
        "services"
        "k3s"
      ]
      ++ config
    ) instruction;
in
{
  imports = [ (removeOption [ "docker" ] "k3s docker option is no longer supported.") ];

  # interface

  options.services.k3s = lib.recursiveUpdate baseModule.options {

    # option overrides

    role.description = ''
      Whether k3s should run as a server or agent.

      If it's a server:

      - By default it also runs workloads as an agent.
      - Starts by default as a standalone server using an embedded sqlite datastore.
      - Configure `clusterInit = true` to switch over to embedded etcd datastore and enable HA mode.
      - Configure `serverAddr` to join an already-initialized HA cluster.

      If it's an agent:

      - `serverAddr` is required.
    '';

    serverAddr.description = ''
      The k3s server to connect to.

      Servers and agents need to communicate each other. Read
      [the networking docs](https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/#networking)
      to know how to configure the firewall.
    '';

    disable.description = ''
      Disable default components, see the [K3s documentation](https://docs.k3s.io/installation/packaged-components#using-the---disable-flag).
    '';

    images = {
      example = lib.literalExpression ''
        [
          (pkgs.dockerTools.pullImage {
            imageName = "docker.io/bitnami/keycloak";
            imageDigest = "sha256:714dfadc66a8e3adea6609bda350345bd3711657b7ef3cf2e8015b526bac2d6b";
            hash = "sha256-IM2BLZ0EdKIZcRWOtuFY9TogZJXCpKtPZnMnPsGlq0Y=";
            finalImageTag = "21.1.2-debian-11-r0";
          })

          config.services.k3s.package.airgap-images
        ]
      '';
      description = ''
        List of derivations that provide container images.
        All images are linked to {file}`${baseModule.paths.imageDir}` before k3s starts and are consequently imported
        by the k3s agent. Consider importing the k3s airgap images archive of the k3s package in
        use, if you want to pre-provision this node with all k3s container images. This option
        only makes sense on nodes with an enabled agent.
      '';
    };

    # k3s-specific options

    clusterInit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Initialize HA cluster using an embedded etcd datastore.

        If this option is `false` and `role` is `server`

        On a server that was using the default embedded sqlite backend,
        enabling this option will migrate to an embedded etcd DB.

        If an HA cluster using the embedded etcd datastore was already initialized,
        this option has no effect.

        This option only makes sense in a server that is not connecting to another server.

        If you are configuring an HA cluster with an embedded etcd,
        the 1st server must have `clusterInit = true`
        and other servers must connect to it using `serverAddr`.
      '';
    };

    disableAgent = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Only run the server. This option only makes sense for a server.";
    };
  };

  # implementation

  config = lib.mkIf cfg.enable (
    lib.recursiveUpdate baseModule.config {
      warnings = (
        lib.optional (
          cfg.disableAgent && cfg.images != [ ]
        ) "k3s: Images are only imported on nodes with an enabled agent, they will be ignored by this node."
      );

      assertions = [
        {
          assertion = cfg.role == "agent" -> !cfg.disableAgent;
          message = "k3s: disableAgent must be false if role is 'agent'";
        }
        {
          assertion = cfg.role == "agent" -> !cfg.clusterInit;
          message = "k3s: clusterInit must be false if role is 'agent'";
        }
      ];
    }
  );
}
