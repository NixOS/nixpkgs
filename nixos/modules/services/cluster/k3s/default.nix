{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkRancherModule =
    {
      # name used in paths/names, e.g. k3s
      name ? null,
      # extra flags to pass to the binary before user-defined extraFlags
      extraBinFlags ? [ ],
    }:
    let
      cfg = config.services.${name};
      manifestDir = "/var/lib/rancher/${name}/server/manifests";
      imageDir = "/var/lib/rancher/${name}/agent/images";
      containerdConfigTemplateFile = "/var/lib/rancher/${name}/agent/etc/containerd/config.toml.tmpl";

      yamlFormat = pkgs.formats.yaml { };
      yamlDocSeparator = builtins.toFile "yaml-doc-separator" "\n---\n";
      # Manifests need a valid YAML suffix to be respected
      mkManifestTarget =
        name: if (lib.hasSuffix ".yaml" name || lib.hasSuffix ".yml" name) then name else name + ".yaml";
      # Produces a list containing all duplicate manifest names
      duplicateManifests = lib.intersectLists (builtins.attrNames cfg.autoDeployCharts) (
        builtins.attrNames cfg.manifests
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
            chart = "https://%{KUBERNETES_API}%/static/charts/${name}.tgz";
          };
        } value.extraFieldDefinitions;

      # Generate a HelmChart custom resource together with extraDeploy manifests. This
      # generates possibly a multi document YAML file that the auto deploy mechanism
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
                name' = "${name}-manifest-" + builtins.baseNameOf name;
                docName = "${name}-manifest-doc-" + builtins.baseNameOf name;
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
      paths = { inherit manifestDir imageDir containerdConfigTemplateFile; };

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

            WARNING: This option will expose your token unencrypted in the world-readable nix store.
            If this is undesired use the tokenFile option instead.
          '';
          default = "";
        };

        tokenFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = "File path containing ${name} token to use when connecting to the server.";
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
            attribute names that are also used in the [](#opt-services.${name}.manifests) option.
            Manifests with the same name will override auto deploying charts with the same name.
            This option only makes sense on server nodes (`role = server`). See the
            [${name} Helm documentation](https://docs.${name}.io/helm) for further information.
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
          ++ (lib.optional (
            cfg.role == "agent" && cfg.configPath == null && cfg.serverAddr == ""
          ) "${name}: serverAddr or configPath (with 'server' key) should be set if role is 'agent'")
          ++ (lib.optional
            (cfg.role == "agent" && cfg.configPath == null && cfg.tokenFile == null && cfg.token == "")
            "${name}: Token or tokenFile or configPath (with 'token' or 'token-file' keys) should be set if role is 'agent'"
          );

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
          in
          (lib.mapAttrs' (_: v: mkManifestRule v) enabledManifests)
          // (builtins.listToAttrs (map mkImageRule cfg.images))
          // (lib.optionalAttrs (cfg.containerdConfigTemplate != null) {
            ${containerdConfigTemplateFile} = {
              "L+".argument = "${pkgs.writeText "config.toml.tmpl" cfg.containerdConfigTemplate}";
            };
          });

        systemd.services.${name} =
          let
            kubeletParams =
              (lib.optionalAttrs (cfg.gracefulNodeShutdown.enable) {
                inherit (cfg.gracefulNodeShutdown) shutdownGracePeriod shutdownGracePeriodCriticalPods;
              })
              // cfg.extraKubeletConfig;
            kubeletConfig = (pkgs.formats.yaml { }).generate "${name}-kubelet-config" (
              {
                apiVersion = "kubelet.config.k8s.io/v1beta1";
                kind = "KubeletConfiguration";
              }
              // kubeletParams
            );

            kubeProxyConfig = (pkgs.formats.yaml { }).generate "${name}-kubeProxy-config" (
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
              EnvironmentFile = cfg.environmentFile;
              ExecStart = lib.concatStringsSep " \\\n " (
                [ "${cfg.package}/bin/${name} ${cfg.role}" ]
                ++ (lib.optional (cfg.serverAddr != "") "--server ${cfg.serverAddr}")
                ++ (lib.optional (cfg.token != "") "--token ${cfg.token}")
                ++ (lib.optional (cfg.tokenFile != null) "--token-file ${cfg.tokenFile}")
                ++ (lib.optional (cfg.configPath != null) "--config ${cfg.configPath}")
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
    builtins.map (
      f:
      import f {
        inherit config lib;
        inherit mkRancherModule;
      }
    ) [ ./k3s.nix ];

  meta.maintainers =
    with lib.maintainers;
    [ azey7f ] # modules only
    ++ lib.teams.k3s.members;
}
