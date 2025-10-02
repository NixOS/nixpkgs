{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.k3s;
  removeOption =
    config: instruction:
    lib.mkRemovedOptionModule (
      [
        "services"
        "k3s"
      ]
      ++ config
    ) instruction;

  manifestDir = "/var/lib/rancher/k3s/server/manifests";
  chartDir = "/var/lib/rancher/k3s/server/static/charts";
  imageDir = "/var/lib/rancher/k3s/agent/images";
  containerdConfigTemplateFile = "/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl";
  yamlFormat = pkgs.formats.yaml { };
  yamlDocSeparator = builtins.toFile "yaml-doc-separator" "\n---\n";
  # Manifests need a valid YAML suffix to be respected by k3s
  mkManifestTarget =
    name: if (lib.hasSuffix ".yaml" name || lib.hasSuffix ".yml" name) then name else name + ".yaml";
  # Produces a list containing all duplicate manifest names
  duplicateManifests = lib.intersectLists (builtins.attrNames cfg.autoDeployCharts) (
    builtins.attrNames cfg.manifests
  );
  # Produces a list containing all duplicate chart names
  duplicateCharts = lib.intersectLists (builtins.attrNames cfg.autoDeployCharts) (
    builtins.attrNames cfg.charts
  );

  # Converts YAML -> JSON -> Nix
  fromYaml =
    path:
    builtins.fromJSON (
      builtins.readFile (
        pkgs.runCommand "${path}-converted.json" { nativeBuildInputs = [ pkgs.yq-go ]; } ''
          yq --no-colors --output-format json ${path} > $out
        ''
      )
    );

  # Replace prefixes and characters that are problematic in file names
  cleanHelmChartName =
    name:
    let
      woPrefix = lib.removePrefix "https://" (lib.removePrefix "oci://" name);
    in
    lib.replaceStrings
      [
        "/"
        ":"
      ]
      [
        "-"
        "-"
      ]
      woPrefix;

  # Fetch a Helm chart from a public registry. This only supports a basic Helm pull.
  fetchHelm =
    {
      name,
      repo,
      version,
      hash ? lib.fakeHash,
    }:
    let
      isOci = lib.hasPrefix "oci://" repo;
      pullCmd = if isOci then repo else "--repo ${repo} ${name}";
      name' = if isOci then "${repo}-${version}" else "${repo}-${name}-${version}";
    in
    pkgs.runCommand (cleanHelmChartName "${name'}.tgz")
      {
        inherit (lib.fetchers.normalizeHash { } { inherit hash; }) outputHash outputHashAlgo;
        impureEnvVars = lib.fetchers.proxyImpureEnvVars;
        nativeBuildInputs = with pkgs; [
          kubernetes-helm
          cacert
          # Helm requires HOME to refer to a writable dir
          writableTmpDirAsHomeHook
        ];
      }
      ''
        helm pull ${pullCmd} --version ${version}
        mv ./*.tgz $out
      '';

  # Returns the path to a YAML manifest file
  mkExtraDeployManifest =
    x:
    # x is a derivation that provides a YAML file
    if lib.isDerivation x then
      x.outPath
    # x is an attribute set that needs to be converted to a YAML file
    else if builtins.isAttrs x then
      (yamlFormat.generate "extra-deploy-chart-manifest" x)
    # assume x is a path to a YAML file
    else
      x;

  # Generate a HelmChart custom resource.
  mkHelmChartCR =
    name: value:
    let
      chartValues = if (lib.isPath value.values) then fromYaml value.values else value.values;
      # use JSON for values as it's a subset of YAML and understood by the k3s Helm controller
      valuesContent = builtins.toJSON chartValues;
    in
    # merge with extraFieldDefinitions to allow setting advanced values and overwrite generated
    # values
    lib.recursiveUpdate {
      apiVersion = "helm.cattle.io/v1";
      kind = "HelmChart";
      metadata = {
        inherit name;
        namespace = "kube-system";
      };
      spec = {
        inherit valuesContent;
        inherit (value) targetNamespace createNamespace;
        chart = "https://%{KUBERNETES_API}%/static/charts/${name}.tgz";
      };
    } value.extraFieldDefinitions;

  # Generate a HelmChart custom resource together with extraDeploy manifests. This
  # generates possibly a multi document YAML file that the auto deploy mechanism of k3s
  # deploys.
  mkAutoDeployChartManifest = name: value: {
    # target is the final name of the link created for the manifest file
    target = mkManifestTarget name;
    inherit (value) enable package;
    # source is a store path containing the complete manifest file
    source = pkgs.concatText "auto-deploy-chart-${name}.yaml" (
      [
        (yamlFormat.generate "helm-chart-manifest-${name}.yaml" (mkHelmChartCR name value))
      ]
      # alternate the YAML doc separator (---) and extraDeploy manifests to create
      # multi document YAMLs
      ++ (lib.concatMap (x: [
        yamlDocSeparator
        (mkExtraDeployManifest x)
      ]) value.extraDeploy)
    );
  };

  autoDeployChartsModule = lib.types.submodule (
    { config, ... }:
    {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          example = false;
          description = ''
            Whether to enable the installation of this Helm chart. Note that setting
            this option to `false` will not uninstall the chart from the cluster, if
            it was previously installed. Please use the the `--disable` flag or `.skip`
            files to delete/disable Helm charts, as mentioned in the
            [docs](https://docs.k3s.io/installation/packaged-components#disabling-manifests).
          '';
        };

        repo = lib.mkOption {
          type = lib.types.nonEmptyStr;
          example = "https://kubernetes.github.io/ingress-nginx";
          description = ''
            The repo of the Helm chart. Only has an effect if `package` is not set.
            The Helm chart is fetched during build time and placed as a `.tgz` archive on the
            filesystem.
          '';
        };

        name = lib.mkOption {
          type = lib.types.nonEmptyStr;
          example = "ingress-nginx";
          description = ''
            The name of the Helm chart. Only has an effect if `package` is not set.
            The Helm chart is fetched during build time and placed as a `.tgz` archive on the
            filesystem.
          '';
        };

        version = lib.mkOption {
          type = lib.types.nonEmptyStr;
          example = "4.7.0";
          description = ''
            The version of the Helm chart. Only has an effect if `package` is not set.
            The Helm chart is fetched during build time and placed as a `.tgz` archive on the
            filesystem.
          '';
        };

        hash = lib.mkOption {
          type = lib.types.str;
          example = "sha256-ej+vpPNdiOoXsaj1jyRpWLisJgWo8EqX+Z5VbpSjsPA=";
          default = "";
          description = ''
            The hash of the packaged Helm chart. Only has an effect if `package` is not set.
            The Helm chart is fetched during build time and placed as a `.tgz` archive on the
            filesystem.
          '';
        };

        package = lib.mkOption {
          type = with lib.types; either path package;
          example = lib.literalExpression "../my-helm-chart.tgz";
          description = ''
            The packaged Helm chart. Overwrites the options `repo`, `name`, `version`
            and `hash` in case of conflicts.
          '';
        };

        targetNamespace = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "default";
          example = "kube-system";
          description = "The namespace in which the Helm chart gets installed.";
        };

        createNamespace = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Whether to create the target namespace if not present.";
        };

        values = lib.mkOption {
          type = with lib.types; either path attrs;
          default = { };
          example = {
            replicaCount = 3;
            hostName = "my-host";
            server = {
              name = "nginx";
              port = 80;
            };
          };
          description = ''
            Override default chart values via Nix expressions. This is equivalent to setting
            values in a `values.yaml` file.

            WARNING: The values (including secrets!) specified here are exposed unencrypted
            in the world-readable nix store.
          '';
        };

        extraDeploy = lib.mkOption {
          type = with lib.types; listOf (either path attrs);
          default = [ ];
          example = lib.literalExpression ''
            [
              ../manifests/my-extra-deployment.yaml
              {
                apiVersion = "v1";
                kind = "Service";
                metadata = {
                  name = "app-service";
                };
                spec = {
                  selector = {
                    "app.kubernetes.io/name" = "MyApp";
                  };
                  ports = [
                    {
                      name = "name-of-service-port";
                      protocol = "TCP";
                      port = 80;
                      targetPort = "http-web-svc";
                    }
                  ];
                };
              }
            ];
          '';
          description = "List of extra Kubernetes manifests to deploy with this Helm chart.";
        };

        extraFieldDefinitions = lib.mkOption {
          inherit (yamlFormat) type;
          default = { };
          example = {
            spec = {
              bootstrap = true;
              helmVersion = "v2";
              backOffLimit = 3;
              jobImage = "custom-helm-controller:v0.0.1";
            };
          };
          description = ''
            Extra HelmChart field definitions that are merged with the rest of the HelmChart
            custom resource. This can be used to set advanced fields or to overwrite
            generated fields. See <https://docs.k3s.io/helm#helmchart-field-definitions>
            for possible fields.
          '';
        };
      };

      config.package = lib.mkDefault (fetchHelm {
        inherit (config)
          repo
          name
          version
          hash
          ;
      });
    }
  );

  manifestModule = lib.types.submodule (
    {
      name,
      config,
      options,
      ...
    }:
    {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether this manifest file should be generated.";
        };

        target = lib.mkOption {
          type = lib.types.nonEmptyStr;
          example = "manifest.yaml";
          description = ''
            Name of the symlink (relative to {file}`${manifestDir}`).
            Defaults to the attribute name.
          '';
        };

        content = lib.mkOption {
          type = with lib.types; nullOr (either attrs (listOf attrs));
          default = null;
          description = ''
            Content of the manifest file. A single attribute set will
            generate a single document YAML file. A list of attribute sets
            will generate multiple documents separated by `---` in a single
            YAML file.
          '';
        };

        source = lib.mkOption {
          type = lib.types.path;
          example = lib.literalExpression "./manifests/app.yaml";
          description = ''
            Path of the source `.yaml` file.
          '';
        };
      };

      config = {
        target = lib.mkDefault (mkManifestTarget name);
        source = lib.mkIf (config.content != null) (
          let
            name' = "k3s-manifest-" + builtins.baseNameOf name;
            docName = "k3s-manifest-doc-" + builtins.baseNameOf name;
            mkSource =
              value:
              if builtins.isList value then
                pkgs.concatText name' (
                  lib.concatMap (x: [
                    yamlDocSeparator
                    (yamlFormat.generate docName x)
                  ]) value
                )
              else
                yamlFormat.generate name' value;
          in
          lib.mkDerivedConfig options.content mkSource
        );
      };
    }
  );
in
{
  imports = [ (removeOption [ "docker" ] "k3s docker option is no longer supported.") ];

  # interface
  options.services.k3s = {
    enable = lib.mkEnableOption "k3s";

    package = lib.mkPackageOption pkgs "k3s" { };

    role = lib.mkOption {
      description = ''
        Whether k3s should run as a server or agent.

        If it's a server:

        - By default it also runs workloads as an agent.
        - Starts by default as a standalone server using an embedded sqlite datastore.
        - Configure `clusterInit = true` to switch over to embedded etcd datastore and enable HA mode.
        - Configure `serverAddr` to join an already-initialized HA cluster.

        If it's an agent:

        - `serverAddr` is required.
      '';
      default = "server";
      type = lib.types.enum [
        "server"
        "agent"
      ];
    };

    serverAddr = lib.mkOption {
      type = lib.types.str;
      description = ''
        The k3s server to connect to.

        Servers and agents need to communicate each other. Read
        [the networking docs](https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/#networking)
        to know how to configure the firewall.
      '';
      example = "https://10.0.0.10:6443";
      default = "";
    };

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

    token = lib.mkOption {
      type = lib.types.str;
      description = ''
        The k3s token to use when connecting to a server.

        WARNING: This option will expose store your token unencrypted world-readable in the nix store.
        If this is undesired use the tokenFile option instead.
      '';
      default = "";
    };

    tokenFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "File path containing k3s token to use when connecting to the server.";
      default = null;
    };

    extraFlags = lib.mkOption {
      description = "Extra flags to pass to the k3s command.";
      type = with lib.types; either str (listOf str);
      default = [ ];
      example = [
        "--disable traefik"
        "--cluster-cidr 10.24.0.0/16"
      ];
    };

    disableAgent = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Only run the server. This option only makes sense for a server.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = ''
        File path containing environment variables for configuring the k3s service in the format of an EnvironmentFile. See {manpage}`systemd.exec(5)`.
      '';
      default = null;
    };

    configPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "File path containing the k3s YAML config. This is useful when the config is generated (for example on boot).";
    };

    manifests = lib.mkOption {
      type = lib.types.attrsOf manifestModule;
      default = { };
      example = lib.literalExpression ''
        {
          deployment.source = ../manifests/deployment.yaml;
          my-service = {
            enable = false;
            target = "app-service.yaml";
            content = {
              apiVersion = "v1";
              kind = "Service";
              metadata = {
                name = "app-service";
              };
              spec = {
                selector = {
                  "app.kubernetes.io/name" = "MyApp";
                };
                ports = [
                  {
                    name = "name-of-service-port";
                    protocol = "TCP";
                    port = 80;
                    targetPort = "http-web-svc";
                  }
                ];
              };
            };
          };

          nginx.content = [
            {
              apiVersion = "v1";
              kind = "Pod";
              metadata = {
                name = "nginx";
                labels = {
                  "app.kubernetes.io/name" = "MyApp";
                };
              };
              spec = {
                containers = [
                  {
                    name = "nginx";
                    image = "nginx:1.14.2";
                    ports = [
                      {
                        containerPort = 80;
                        name = "http-web-svc";
                      }
                    ];
                  }
                ];
              };
            }
            {
              apiVersion = "v1";
              kind = "Service";
              metadata = {
                name = "nginx-service";
              };
              spec = {
                selector = {
                  "app.kubernetes.io/name" = "MyApp";
                };
                ports = [
                  {
                    name = "name-of-service-port";
                    protocol = "TCP";
                    port = 80;
                    targetPort = "http-web-svc";
                  }
                ];
              };
            }
          ];
        };
      '';
      description = ''
        Auto-deploying manifests that are linked to {file}`${manifestDir}` before k3s starts.
        Note that deleting manifest files will not remove or otherwise modify the resources
        it created. Please use the the `--disable` flag or `.skip` files to delete/disable AddOns,
        as mentioned in the [docs](https://docs.k3s.io/installation/packaged-components#disabling-manifests).
        This option only makes sense on server nodes (`role = server`).
        Read the [auto-deploying manifests docs](https://docs.k3s.io/installation/packaged-components#auto-deploying-manifests-addons)
        for further information.
      '';
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

    containerdConfigTemplate = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = lib.literalExpression ''
        # Base K3s config
        {{ template "base" . }}

        # Add a custom runtime
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes."custom"]
          runtime_type = "io.containerd.runc.v2"
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes."custom".options]
          BinaryName = "/path/to/custom-container-runtime"
      '';
      description = ''
        Config template for containerd, to be placed at
        `/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl`.
        See the K3s docs on [configuring containerd](https://docs.k3s.io/advanced#configuring-containerd).
      '';
    };

    images = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
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
        All images are linked to {file}`${imageDir}` before k3s starts and consequently imported
        by the k3s agent. Consider importing the k3s airgap images archive of the k3s package in
        use, if you want to pre-provision this node with all k3s container images. This option
        only makes sense on nodes with an enabled agent.
      '';
    };

    gracefulNodeShutdown = {
      enable = lib.mkEnableOption ''
        graceful node shutdowns where the kubelet attempts to detect
        node system shutdown and terminates pods running on the node. See the
        [documentation](https://kubernetes.io/docs/concepts/cluster-administration/node-shutdown/#graceful-node-shutdown)
        for further information.
      '';

      shutdownGracePeriod = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "30s";
        example = "1m30s";
        description = ''
          Specifies the total duration that the node should delay the shutdown by. This is the total
          grace period for pod termination for both regular and critical pods.
        '';
      };

      shutdownGracePeriodCriticalPods = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "10s";
        example = "15s";
        description = ''
          Specifies the duration used to terminate critical pods during a node shutdown. This should be
          less than `shutdownGracePeriod`.
        '';
      };
    };

    extraKubeletConfig = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      example = {
        podsPerCore = 3;
        memoryThrottlingFactor = 0.69;
        containerLogMaxSize = "5Mi";
      };
      description = ''
        Extra configuration to add to the kubelet's configuration file. The subset of the kubelet's
        configuration that can be configured via a file is defined by the
        [KubeletConfiguration](https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/)
        struct. See the
        [documentation](https://kubernetes.io/docs/tasks/administer-cluster/kubelet-config-file/)
        for further information.
      '';
    };

    extraKubeProxyConfig = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      example = {
        mode = "nftables";
        clientConnection.kubeconfig = "/var/lib/rancher/k3s/agent/kubeproxy.kubeconfig";
      };
      description = ''
        Extra configuration to add to the kube-proxy's configuration file. The subset of the kube-proxy's
        configuration that can be configured via a file is defined by the
        [KubeProxyConfiguration](https://kubernetes.io/docs/reference/config-api/kube-proxy-config.v1alpha1/)
        struct. Note that the kubeconfig param will be override by `clientConnection.kubeconfig`, so you must
        set the `clientConnection.kubeconfig` if you want to use `extraKubeProxyConfig`.
      '';
    };

    autoDeployCharts = lib.mkOption {
      type = lib.types.attrsOf autoDeployChartsModule;
      apply = lib.mapAttrs mkAutoDeployChartManifest;
      default = { };
      example = lib.literalExpression ''
        {
          harbor = {
            name = "harbor";
            repo = "https://helm.goharbor.io";
            version = "1.14.0";
            hash = "sha256-fMP7q1MIbvzPGS9My91vbQ1d3OJMjwc+o8YE/BXZaYU=";
            values = {
              existingSecretAdminPassword = "harbor-admin";
              expose = {
                tls = {
                  enabled = true;
                  certSource = "secret";
                  secret.secretName = "my-tls-secret";
                };
                ingress = {
                  hosts.core = "example.com";
                  className = "nginx";
                };
              };
            };
          };
          nginx = {
            repo = "oci://registry-1.docker.io/bitnamicharts/nginx";
            version = "20.0.0";
            hash = "sha256-sy+tzB+i9jIl/tqOMzzuhVhTU4EZVsoSBtPznxF/36c=";
          };
          custom-chart = {
            package = ../charts/my-chart.tgz;
            values = ../values/my-values.yaml;
            extraFieldDefinitions = {
              spec.timeout = "60s";
            };
          };
        }
      '';
      description = ''
        Auto deploying Helm charts that are installed by the k3s Helm controller. Avoid to use
        attribute names that are also used in the [](#opt-services.k3s.manifests) and
        [](#opt-services.k3s.charts) options. Manifests with the same name will override
        auto deploying charts with the same name. Similiarly, charts with the same name will
        overwrite the Helm chart contained in auto deploying charts. This option only makes
        sense on server nodes (`role = server`). See the
        [k3s Helm documentation](https://docs.k3s.io/helm) for further information.
      '';
    };
  };

  # implementation

  config = lib.mkIf cfg.enable {
    warnings =
      (lib.optional (cfg.role != "server" && cfg.manifests != { })
        "k3s: Auto deploying manifests are only installed on server nodes (role == server), they will be ignored by this node."
      )
      ++ (lib.optional (cfg.role != "server" && cfg.charts != { })
        "k3s: Helm charts are only made available to the cluster on server nodes (role == server), they will be ignored by this node."
      )
      ++ (lib.optional (cfg.role != "server" && cfg.autoDeployCharts != { })
        "k3s: Auto deploying Helm charts are only installed on server nodes (role == server), they will be ignored by this node."
      )
      ++ (lib.optional (duplicateManifests != [ ])
        "k3s: The following auto deploying charts are overriden by manifests of the same name: ${toString duplicateManifests}."
      )
      ++ (lib.optional (duplicateCharts != [ ])
        "k3s: The following auto deploying charts are overriden by charts of the same name: ${toString duplicateCharts}."
      )
      ++ (lib.optional (
        cfg.disableAgent && cfg.images != [ ]
      ) "k3s: Images are only imported on nodes with an enabled agent, they will be ignored by this node")
      ++ (lib.optional (
        cfg.role == "agent" && cfg.configPath == null && cfg.serverAddr == ""
      ) "k3s: serverAddr or configPath (with 'server' key) should be set if role is 'agent'")
      ++ (lib.optional
        (cfg.role == "agent" && cfg.configPath == null && cfg.tokenFile == null && cfg.token == "")
        "k3s: Token or tokenFile or configPath (with 'token' or 'token-file' keys) should be set if role is 'agent'"
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

    environment.systemPackages = [ config.services.k3s.package ];

    # Use systemd-tmpfiles to activate k3s content
    systemd.tmpfiles.settings."10-k3s" =
      let
        # Merge manifest with manifests generated from auto deploying charts, keep only enabled manifests
        enabledManifests = lib.filterAttrs (_: v: v.enable) (cfg.autoDeployCharts // cfg.manifests);
        # Merge charts with charts contained in enabled auto deploying charts
        helmCharts =
          (lib.concatMapAttrs (n: v: { ${n} = v.package; }) (
            lib.filterAttrs (_: v: v.enable) cfg.autoDeployCharts
          ))
          // cfg.charts;
        # Make a systemd-tmpfiles rule for a manifest
        mkManifestRule = manifest: {
          name = "${manifestDir}/${manifest.target}";
          value = {
            "L+".argument = "${manifest.source}";
          };
        };
        # Ensure that all chart targets have a .tgz suffix
        mkChartTarget = name: if (lib.hasSuffix ".tgz" name) then name else name + ".tgz";
        # Make a systemd-tmpfiles rule for a chart
        mkChartRule = target: source: {
          name = "${chartDir}/${mkChartTarget target}";
          value = {
            "L+".argument = "${source}";
          };
        };
        # Make a systemd-tmpfiles rule for a container image
        mkImageRule = image: {
          name = "${imageDir}/${image.name}";
          value = {
            "L+".argument = "${image}";
          };
        };
      in
      (lib.mapAttrs' (_: v: mkManifestRule v) enabledManifests)
      // (lib.mapAttrs' (n: v: mkChartRule n v) helmCharts)
      // (builtins.listToAttrs (map mkImageRule cfg.images))
      // (lib.optionalAttrs (cfg.containerdConfigTemplate != null) {
        ${containerdConfigTemplateFile} = {
          "L+".argument = "${pkgs.writeText "config.toml.tmpl" cfg.containerdConfigTemplate}";
        };
      });

    systemd.services.k3s =
      let
        kubeletParams =
          (lib.optionalAttrs (cfg.gracefulNodeShutdown.enable) {
            inherit (cfg.gracefulNodeShutdown) shutdownGracePeriod shutdownGracePeriodCriticalPods;
          })
          // cfg.extraKubeletConfig;
        kubeletConfig = (pkgs.formats.yaml { }).generate "k3s-kubelet-config" (
          {
            apiVersion = "kubelet.config.k8s.io/v1beta1";
            kind = "KubeletConfiguration";
          }
          // kubeletParams
        );

        kubeProxyConfig = (pkgs.formats.yaml { }).generate "k3s-kubeProxy-config" (
          {
            apiVersion = "kubeproxy.config.k8s.io/v1alpha1";
            kind = "KubeProxyConfiguration";
          }
          // cfg.extraKubeProxyConfig
        );
      in
      {
        description = "k3s service";
        after = [
          "firewall.service"
          "network-online.target"
        ];
        wants = [
          "firewall.service"
          "network-online.target"
        ];
        wantedBy = [ "multi-user.target" ];
        path = lib.optional config.boot.zfs.enabled config.boot.zfs.package;
        serviceConfig = {
          # See: https://github.com/rancher/k3s/blob/dddbd16305284ae4bd14c0aade892412310d7edc/install.sh#L197
          Type = if cfg.role == "agent" then "exec" else "notify";
          KillMode = "process";
          Delegate = "yes";
          Restart = "always";
          RestartSec = "5s";
          LimitNOFILE = 1048576;
          LimitNPROC = "infinity";
          LimitCORE = "infinity";
          TasksMax = "infinity";
          EnvironmentFile = cfg.environmentFile;
          ExecStart = lib.concatStringsSep " \\\n " (
            [ "${cfg.package}/bin/k3s ${cfg.role}" ]
            ++ (lib.optional cfg.clusterInit "--cluster-init")
            ++ (lib.optional cfg.disableAgent "--disable-agent")
            ++ (lib.optional (cfg.serverAddr != "") "--server ${cfg.serverAddr}")
            ++ (lib.optional (cfg.token != "") "--token ${cfg.token}")
            ++ (lib.optional (cfg.tokenFile != null) "--token-file ${cfg.tokenFile}")
            ++ (lib.optional (cfg.configPath != null) "--config ${cfg.configPath}")
            ++ (lib.optional (kubeletParams != { }) "--kubelet-arg=config=${kubeletConfig}")
            ++ (lib.optional (cfg.extraKubeProxyConfig != { }) "--kube-proxy-arg=config=${kubeProxyConfig}")
            ++ (lib.flatten cfg.extraFlags)
          );
        };
      };
  };

  meta.maintainers = lib.teams.k3s.members;
}
