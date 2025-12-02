{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkRancherModule =
    {
      # name used in paths/bin names/etc, e.g. k3s
      name,
      # systemd service name
      serviceName ? name,
      # extra flags to pass to the binary before user-defined extraFlags
      extraBinFlags ? [ ],
      # generate manifests as JSON rather than YAML, see rke2.nix
      jsonManifests ? false,

      # which port on the local node hosts content placed in ${staticContentChartDir} on /static/
      # if null, it's assumed the content can be accessed via https://%{KUBERNETES_API}%/static/
      staticContentPort ? null,
    }:
    let
      cfg = config.services.${name};

      # Paths defined here are passed to the downstream modules as `paths`
      manifestDir = "/var/lib/rancher/${name}/server/manifests";
      imageDir = "/var/lib/rancher/${name}/agent/images";
      containerdConfigTemplateFile = "/var/lib/rancher/${name}/agent/etc/containerd/config.toml.tmpl";
      staticContentChartDir = "/var/lib/rancher/${name}/server/static/charts";

      manifestFormat = if jsonManifests then pkgs.formats.json { } else pkgs.formats.yaml { };
      # Manifests need a valid suffix to be respected
      mkManifestTarget =
        name:
        if (lib.hasSuffix ".yaml" name || lib.hasSuffix ".yml" name || lib.hasSuffix ".json" name) then
          name
        else if jsonManifests then
          name + ".json"
        else
          name + ".yaml";
      # Returns a path to the final manifest file
      mkManifestSource =
        name: manifests:
        manifestFormat.generate name (
          if builtins.isList manifests then
            {
              apiVersion = "v1";
              kind = "List";
              items = manifests;
            }
          else
            manifests
        );

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
          (manifestFormat.generate "extra-deploy-chart-manifest" x)
        # assume x is a path to a YAML file
        else
          x;

      # Generate a HelmChart custom resource.
      mkHelmChartCR =
        name: value:
        let
          chartValues = if (lib.isPath value.values) then fromYaml value.values else value.values;
          # use JSON for values as it's a subset of YAML and understood by the rancher Helm controller
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
            chart =
              if staticContentPort == null then
                "https://%{KUBERNETES_API}%/static/charts/${name}.tgz"
              else
                "https://localhost:${toString staticContentPort}/static/charts/${name}.tgz";
            bootstrap = staticContentPort != null; # needed for host network access
          };
        } value.extraFieldDefinitions;

      # Generate a HelmChart custom resource together with extraDeploy manifests.
      mkAutoDeployChartManifest = name: value: {
        # target is the final name of the link created for the manifest file
        target = mkManifestTarget name;
        inherit (value) enable package;
        # source is a store path containing the complete manifest file
        source = mkManifestSource "auto-deploy-chart-${name}" (
          lib.singleton (mkHelmChartCR name value)
          ++ builtins.map (x: fromYaml (mkExtraDeployManifest x)) value.extraDeploy
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

                **WARNING**: The values (including secrets!) specified here are exposed unencrypted
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
              inherit (manifestFormat) type;
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
                generated fields. See <https://docs.${name}.io/helm#helmchart-field-definitions>
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
                name' = "${name}-manifest-" + builtins.baseNameOf name;
                mkSource = mkManifestSource name';
              in
              lib.mkDerivedConfig options.content mkSource
            );
          };
        }
      );
    in
    {
      paths = {
        inherit
          manifestDir
          imageDir
          containerdConfigTemplateFile
          staticContentChartDir
          ;
      };

      # interface

      options = {
        enable = lib.mkEnableOption name;

        package = lib.mkPackageOption pkgs name { };

        role = lib.mkOption {
          description = "Whether ${name} should run as a server or agent.";
          default = "server";
          type = lib.types.enum [
            "server"
            "agent"
          ];
        };

        serverAddr = lib.mkOption {
          type = lib.types.str;
          description = "The ${name} server to connect to, used to join a cluster.";
          example = "https://10.0.0.10:6443";
          default = "";
        };

        token = lib.mkOption {
          type = lib.types.str;
          description = ''
            The ${name} token to use when connecting to a server.

            **WARNING**: This option will expose your token unencrypted in the world-readable nix store.
            If this is undesired use the tokenFile option instead.
          '';
          default = "";
        };

        tokenFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = "File path containing the ${name} token to use when connecting to a server.";
          default = null;
        };

        agentToken = lib.mkOption {
          type = lib.types.str;
          description = ''
            The ${name} token agents can use to connect to the server.
            This option only makes sense on server nodes (`role = server`).

            **WARNING**: This option will expose your token unencrypted in the world-readable nix store.
            If this is undesired use the tokenFile option instead.
          '';
          default = "";
        };

        agentTokenFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = ''
            File path containing the ${name} token agents can use to connect to the server.
            This option only makes sense on server nodes (`role = server`).
          '';
          default = null;
        };

        extraFlags = lib.mkOption {
          description = "Extra flags to pass to the ${name} command.";
          type = with lib.types; either str (listOf str);
          default = [ ];
          example = [
            "--etcd-expose-metrics"
            "--cluster-cidr 10.24.0.0/16"
          ];
        };

        environmentFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = ''
            File path containing environment variables for configuring the ${name} service in the format of an EnvironmentFile. See {manpage}`systemd.exec(5)`.
          '';
          default = null;
        };

        configPath = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "File path containing the ${name} YAML config. This is useful when the config is generated (for example on boot).";
        };

        disable = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Disable default components via the `--disable` flag.";
          default = [ ];
        };

        nodeName = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Node name.";
          default = null;
        };

        nodeLabel = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Registering and starting kubelet with set of labels.";
          default = [ ];
        };

        nodeTaint = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Registering kubelet with set of taints.";
          default = [ ];
        };

        nodeIP = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "IPv4/IPv6 addresses to advertise for node.";
          default = null;
        };

        selinux = lib.mkOption {
          type = lib.types.bool;
          description = "Enable SELinux in containerd.";
          default = false;
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
            Auto-deploying manifests that are linked to {file}`${manifestDir}` before ${name} starts.
            Note that deleting manifest files will not remove or otherwise modify the resources
            it created. Please use the the `--disable` flag or `.skip` files to delete/disable AddOns,
            as mentioned in the [docs](https://docs.k3s.io/installation/packaged-components#disabling-manifests).
            This option only makes sense on server nodes (`role = server`).
            Read the [auto-deploying manifests docs](https://docs.k3s.io/installation/packaged-components#auto-deploying-manifests-addons)
            for further information.

            **WARNING**: If you have multiple server nodes, and set this option on more than one server,
            it is your responsibility to ensure that files stay in sync across those nodes. AddOn content is
            not synced between nodes, and ${name} cannot guarantee correct behavior if different servers attempt
            to deploy conflicting manifests.
          '';
        };

        containerdConfigTemplate = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = lib.literalExpression ''
            # Base config
            {{ template "base" . }}

            # Add a custom runtime
            [plugins."io.containerd.grpc.v1.cri".containerd.runtimes."custom"]
              runtime_type = "io.containerd.runc.v2"
            [plugins."io.containerd.grpc.v1.cri".containerd.runtimes."custom".options]
              BinaryName = "/path/to/custom-container-runtime"
          '';
          description = ''
            Config template for containerd, to be placed at
            `/var/lib/rancher/${name}/agent/etc/containerd/config.toml.tmpl`.
            See the docs on [configuring containerd](https://docs.${name}.io/advanced#configuring-containerd).
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
            ]
          '';
          description = ''
            List of derivations that provide container images.
            All images are linked to {file}`${imageDir}` before ${name} starts and are consequently imported
            by the ${name} agent. This option only makes sense on nodes with an enabled agent.
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
            clientConnection.kubeconfig = "/var/lib/rancher/${name}/agent/kubeproxy.kubeconfig";
          };
          description = ''
            Extra configuration to add to the kube-proxy's configuration file. The subset of the kube-proxy's
            configuration that can be configured via a file is defined by the
            [KubeProxyConfiguration](https://kubernetes.io/docs/reference/config-api/kube-proxy-config.v1alpha1/)
            struct. Note that the kubeconfig param will be overriden by `clientConnection.kubeconfig`, so you must
            set the `clientConnection.kubeconfig` option if you want to use `extraKubeProxyConfig`.
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
            Auto deploying Helm charts that are installed by the ${name} Helm controller. Avoid using
            attribute names that are also used in the [](#opt-services.${name}.manifests) and
            [](#opt-services.${name}.charts) options. Manifests with the same name will override
            auto deploying charts with the same name.
            This option only makes sense on server nodes (`role = server`). See the
            [${name} Helm documentation](https://docs.${name}.io/helm) for further information.

            **WARNING**: If you have multiple server nodes, and set this option on more than one server,
            it is your responsibility to ensure that files stay in sync across those nodes. AddOn content is
            not synced between nodes, and ${name} cannot guarantee correct behavior if different servers attempt
            to deploy conflicting manifests.
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
            Packaged Helm charts that are linked to {file}`${staticContentChartDir}` before ${name} starts.
            The attribute name will be used as the link target (relative to {file}`${staticContentChartDir}`).
            The specified charts will only be placed on the file system and made available via ${
              if staticContentPort == null then
                "the Kubernetes APIServer from within the cluster"
              else
                "port ${toString staticContentPort} on server nodes"
            }. See the [](#opt-services.${name}.autoDeployCharts) option and the
            [${name} Helm controller docs](https://docs.${name}.io/helm#using-the-helm-controller)
            to deploy Helm charts. This option only makes sense on server nodes (`role = server`).
          '';
        };
      };

      # implementation

      config = {
        warnings =
          (lib.optional (cfg.role != "server" && cfg.manifests != { })
            "${name}: Auto deploying manifests are only installed on server nodes (role == server), they will be ignored by this node."
          )
          ++ (lib.optional (cfg.role != "server" && cfg.autoDeployCharts != { })
            "${name}: Auto deploying Helm charts are only installed on server nodes (role == server), they will be ignored by this node."
          )
          ++ (lib.optional (duplicateManifests != [ ])
            "${name}: The following auto deploying charts are overriden by manifests of the same name: ${toString duplicateManifests}."
          )
          ++ (lib.optional (duplicateCharts != [ ])
            "${name}: The following auto deploying charts are overriden by charts of the same name: ${toString duplicateCharts}."
          )
          ++ (lib.optional (cfg.role != "server" && cfg.charts != { })
            "${name}: Helm charts are only made available to the cluster on server nodes (role == server), they will be ignored by this node."
          )
          ++ (lib.optional (
            cfg.role == "agent" && cfg.configPath == null && cfg.serverAddr == ""
          ) "${name}: serverAddr or configPath (with 'server' key) should be set if role is 'agent'")
          ++ (lib.optional
            (cfg.role == "agent" && cfg.configPath == null && cfg.tokenFile == null && cfg.token == "")
            "${name}: token, tokenFile or configPath (with 'token' or 'token-file' keys) should be set if role is 'agent'"
          )
          ++ (lib.optional (
            cfg.role == "agent" && !(cfg.agentTokenFile != null || cfg.agentToken != "")
          ) "${name}: agentToken and agentToken should not be set if role is 'agent'");

        environment.systemPackages = [ config.services.${name}.package ];

        # Use systemd-tmpfiles to activate content
        systemd.tmpfiles.settings."10-${name}" =
          let
            # Merge manifest with manifests generated from auto deploying charts, keep only enabled manifests
            enabledManifests = lib.filterAttrs (_: v: v.enable) (cfg.autoDeployCharts // cfg.manifests);
            # Make a systemd-tmpfiles rule for a manifest
            mkManifestRule = manifest: {
              name = "${manifestDir}/${manifest.target}";
              value = {
                "L+".argument = "${manifest.source}";
              };
            };
            # Make a systemd-tmpfiles rule for a container image
            mkImageRule = image: {
              name = "${imageDir}/${image.name}";
              value = {
                "L+".argument = "${image}";
              };
            };
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
              name = "${staticContentChartDir}/${mkChartTarget target}";
              value = {
                "L+".argument = "${source}";
              };
            };
          in
          (lib.mapAttrs' (_: v: mkManifestRule v) enabledManifests)
          // (builtins.listToAttrs (map mkImageRule cfg.images))
          // (lib.optionalAttrs (cfg.containerdConfigTemplate != null) {
            ${containerdConfigTemplateFile} = {
              "L+".argument = "${pkgs.writeText "config.toml.tmpl" cfg.containerdConfigTemplate}";
            };
          })
          // (lib.mapAttrs' mkChartRule helmCharts);

        systemd.services.${serviceName} =
          let
            kubeletParams =
              (lib.optionalAttrs (cfg.gracefulNodeShutdown.enable) {
                inherit (cfg.gracefulNodeShutdown) shutdownGracePeriod shutdownGracePeriodCriticalPods;
              })
              // cfg.extraKubeletConfig;
            kubeletConfig = manifestFormat.generate "${name}-kubelet-config" (
              {
                apiVersion = "kubelet.config.k8s.io/v1beta1";
                kind = "KubeletConfiguration";
              }
              // kubeletParams
            );

            kubeProxyConfig = manifestFormat.generate "${name}-kubeProxy-config" (
              {
                apiVersion = "kubeproxy.config.k8s.io/v1alpha1";
                kind = "KubeProxyConfiguration";
              }
              // cfg.extraKubeProxyConfig
            );
          in
          {
            description = "${name} service";
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
              TimeoutStartSec = 0;
              EnvironmentFile = cfg.environmentFile;
              ExecStart = lib.concatStringsSep " \\\n " (
                [ "${cfg.package}/bin/${name} ${cfg.role}" ]
                ++ (lib.optional (cfg.serverAddr != "") "--server ${cfg.serverAddr}")
                ++ (lib.optional (cfg.token != "") "--token ${cfg.token}")
                ++ (lib.optional (cfg.tokenFile != null) "--token-file ${cfg.tokenFile}")
                ++ (lib.optional (cfg.agentToken != "") "--agent-token ${cfg.agentToken}")
                ++ (lib.optional (cfg.agentTokenFile != null) "--agent-token-file ${cfg.agentTokenFile}")
                ++ (lib.optional (cfg.configPath != null) "--config ${cfg.configPath}")
                ++ (map (d: "--disable=${d}") cfg.disable)
                ++ (lib.optional (cfg.nodeName != null) "--node-name=${cfg.nodeName}")
                ++ (lib.optionals (cfg.nodeLabel != [ ]) (map (l: "--node-label=${l}") cfg.nodeLabel))
                ++ (lib.optionals (cfg.nodeTaint != [ ]) (map (t: "--node-taint=${t}") cfg.nodeTaint))
                ++ (lib.optional (cfg.nodeIP != null) "--node-ip=${cfg.nodeIP}")
                ++ (lib.optional cfg.selinux "--selinux")
                ++ (lib.optional (kubeletParams != { }) "--kubelet-arg=config=${kubeletConfig}")
                ++ (lib.optional (cfg.extraKubeProxyConfig != { }) "--kube-proxy-arg=config=${kubeProxyConfig}")
                ++ extraBinFlags
                ++ (lib.flatten cfg.extraFlags)
              );
            };
          };
      };
    };
in
{
  imports =
    # pass mkRancherModule explicitly instead of via
    # _modules.args to prevent infinite recursion
    let
      args = {
        inherit config lib;
        inherit mkRancherModule;
      };
    in
    [
      (import ./k3s.nix args)
      (import ./rke2.nix args)
    ];

  meta.maintainers = pkgs.rke2.meta.maintainers ++ lib.teams.k3s.members;
}
