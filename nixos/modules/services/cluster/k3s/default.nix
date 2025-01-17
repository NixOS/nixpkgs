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

  manifestModule =
    let
      mkTarget =
        name: if (lib.hasSuffix ".yaml" name || lib.hasSuffix ".yml" name) then name else name + ".yaml";
    in
    lib.types.submodule (
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
            example = lib.literalExpression "manifest.yaml";
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
          target = lib.mkDefault (mkTarget name);
          source = lib.mkIf (config.content != null) (
            let
              name' = "k3s-manifest-" + builtins.baseNameOf name;
              docName = "k3s-manifest-doc-" + builtins.baseNameOf name;
              yamlDocSeparator = builtins.toFile "yaml-doc-separator" "\n---\n";
              mkYaml = name: x: (pkgs.formats.yaml { }).generate name x;
              mkSource =
                value:
                if builtins.isList value then
                  pkgs.concatText name' (
                    lib.concatMap (x: [
                      yamlDocSeparator
                      (mkYaml docName x)
                    ]) value
                  )
                else
                  mkYaml name' value;
            in
            lib.mkDerivedConfig options.content mkSource
          );
        };
      }
    );

  enabledManifests = lib.filter (m: m.enable) (lib.attrValues cfg.manifests);
  linkManifestEntry = m: "${pkgs.coreutils-full}/bin/ln -sfn ${m.source} ${manifestDir}/${m.target}";
  linkImageEntry = image: "${pkgs.coreutils-full}/bin/ln -sfn ${image} ${imageDir}/${image.name}";
  linkChartEntry =
    let
      mkTarget = name: if (lib.hasSuffix ".tgz" name) then name else name + ".tgz";
    in
    name: value:
    "${pkgs.coreutils-full}/bin/ln -sfn ${value} ${chartDir}/${mkTarget (builtins.baseNameOf name)}";

  activateK3sContent = pkgs.writeShellScript "activate-k3s-content" ''
    ${lib.optionalString (
      builtins.length enabledManifests > 0
    ) "${pkgs.coreutils-full}/bin/mkdir -p ${manifestDir}"}
    ${lib.optionalString (cfg.charts != { }) "${pkgs.coreutils-full}/bin/mkdir -p ${chartDir}"}
    ${lib.optionalString (
      builtins.length cfg.images > 0
    ) "${pkgs.coreutils-full}/bin/mkdir -p ${imageDir}"}

    ${builtins.concatStringsSep "\n" (map linkManifestEntry enabledManifests)}
    ${builtins.concatStringsSep "\n" (lib.mapAttrsToList linkChartEntry cfg.charts)}
    ${builtins.concatStringsSep "\n" (map linkImageEntry cfg.images)}

    ${lib.optionalString (cfg.containerdConfigTemplate != null) ''
      mkdir -p $(dirname ${containerdConfigTemplateFile})
      ${pkgs.coreutils-full}/bin/ln -sfn ${pkgs.writeText "config.toml.tmpl" cfg.containerdConfigTemplate} ${containerdConfigTemplateFile}
    ''}
  '';
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
        "--no-deploy traefik"
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
        File path containing environment variables for configuring the k3s service in the format of an EnvironmentFile. See systemd.exec(5).
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
          }
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
        Kubernetes APIServer from within the cluster, you may use the
        [k3s Helm controller](https://docs.k3s.io/helm#using-the-helm-controller)
        to deploy the charts. This option only makes sense on server nodes
        (`role = server`).
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

          config.services.k3s.package.airgapImages
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
      ++ (lib.optional (
        cfg.disableAgent && cfg.images != [ ]
      ) "k3s: Images are only imported on nodes with an enabled agent, they will be ignored by this node")
      ++ (lib.optional (
        cfg.role == "agent" && cfg.configPath == null && cfg.serverAddr == ""
      ) "k3s: ServerAddr or configPath (with 'server' key) should be set if role is 'agent'")
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
          ExecStartPre = activateK3sContent;
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
