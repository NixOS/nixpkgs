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

  chartDir = "/var/lib/rancher/k3s/server/static/charts";
  # Produces a list containing all duplicate chart names
  duplicateCharts = lib.intersectLists (builtins.attrNames cfg.autoDeployCharts) (
    builtins.attrNames cfg.charts
  );
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
        All images are linked to {file}`${baseModule.imageDir}` before k3s starts and are consequently imported
        by the k3s agent. Consider importing the k3s airgap images archive of the k3s package in
        use, if you want to pre-provision this node with all k3s container images. This option
        only makes sense on nodes with an enabled agent.
      '';
    };

    autoDeployCharts.description = ''
      Auto deploying Helm charts that are installed by the k3s Helm controller. Avoid using
      attribute names that are also used in the [](#opt-services.k3s.manifests) and
      [](#opt-services.k3s.charts) options. Manifests with the same name will override
      auto deploying charts with the same name. Similiarly, charts with the same name will
      overwrite the Helm chart contained in auto deploying charts. This option only makes
      sense on server nodes (`role = server`). See the
      [k3s Helm documentation](https://docs.k3s.io/helm) for further information.
    '';

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

    charts = lib.mkOption {
      type = with lib.types; attrsOf (either path package);
      default = { };
      example = lib.literalExpression ''
        nginx = ../charts/my-nginx-chart.tgz;
        redis = ../charts/my-redis-chart.tgz;
      '';
      description = ''
        Packaged Helm charts that are linked to {file}`${chartDir}` before k3s starts.
        The attribute name will be used as the link target (relative to {file}`${chartDir}`).
        The specified charts will only be placed on the file system and made available to the
        Kubernetes APIServer from within the cluster. See the [](#opt-services.k3s.autoDeployCharts)
        option and the [k3s Helm controller docs](https://docs.k3s.io/helm#using-the-helm-controller)
        to deploy Helm charts. This option only makes sense on server nodes (`role = server`).
      '';
    };
  };

  # implementation

  config = lib.mkIf cfg.enable (
    lib.recursiveUpdate baseModule.config {
      warnings =
        (lib.optional (cfg.role != "server" && cfg.charts != { })
          "k3s: Helm charts are only made available to the cluster on server nodes (role == server), they will be ignored by this node."
        )
        ++ (lib.optional (duplicateCharts != [ ])
          "k3s: The following auto deploying charts are overriden by charts of the same name: ${toString duplicateCharts}."
        )
        ++ (lib.optional (cfg.disableAgent && cfg.images != [ ])
          "k3s: Images are only imported on nodes with an enabled agent, they will be ignored by this node."
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

      systemd.tmpfiles.settings."10-k3s" =
        let
          # Merge charts with charts contained in enabled auto deploying charts
          helmCharts =
            (lib.concatMapAttrs (n: v: { ${n} = v.package; }) (
              lib.filterAttrs (_: v: v.enable) cfg.autoDeployCharts
            ))
            // cfg.charts;
          # Ensure that all chart targets have a .tgz suffix
          mkChartTarget = name: if (lib.hasSuffix ".tgz" name) then name else name + ".tgz";
          # Make a systemd-tmpfiles rule for a chart
          mkChartRule = target: source: {
            name = "${chartDir}/${mkChartTarget target}";
            value = {
              "L+".argument = "${source}";
            };
          };
        in
        lib.mapAttrs' (n: v: mkChartRule n v) helmCharts;
    }
  );
}
