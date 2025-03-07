{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
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

  enabledManifests = with builtins; filter (m: m.enable) (attrValues cfg.manifests);
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
  '';
in
{
  imports = [ (removeOption [ "docker" ] "k3s docker option is no longer supported.") ];

  # interface
  options.services.k3s = {
    enable = mkEnableOption "k3s";

    package = mkPackageOption pkgs "k3s" { };

    role = mkOption {
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
      type = types.enum [
        "server"
        "agent"
      ];
    };

    serverAddr = mkOption {
      type = types.str;
      description = ''
        The k3s server to connect to.

        Servers and agents need to communicate each other. Read
        [the networking docs](https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/#networking)
        to know how to configure the firewall.
      '';
      example = "https://10.0.0.10:6443";
      default = "";
    };

    clusterInit = mkOption {
      type = types.bool;
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

    token = mkOption {
      type = types.str;
      description = ''
        The k3s token to use when connecting to a server.

        WARNING: This option will expose store your token unencrypted world-readable in the nix store.
        If this is undesired use the tokenFile option instead.
      '';
      default = "";
    };

    tokenFile = mkOption {
      type = types.nullOr types.path;
      description = "File path containing k3s token to use when connecting to the server.";
      default = null;
    };

    extraFlags = mkOption {
      description = "Extra flags to pass to the k3s command.";
      type = types.str;
      default = "";
      example = "--no-deploy traefik --cluster-cidr 10.24.0.0/16";
    };

    disableAgent = mkOption {
      type = types.bool;
      default = false;
      description = "Only run the server. This option only makes sense for a server.";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      description = ''
        File path containing environment variables for configuring the k3s service in the format of an EnvironmentFile. See systemd.exec(5).
      '';
      default = null;
    };

    configPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "File path containing the k3s YAML config. This is useful when the config is generated (for example on boot).";
    };

    manifests = mkOption {
      type = types.attrsOf manifestModule;
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

    charts = mkOption {
      type = with types; attrsOf (either path package);
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

    images = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = lib.literalExpression ''
        [
          (pkgs.dockerTools.pullImage {
            imageName = "docker.io/bitnami/keycloak";
            imageDigest = "sha256:714dfadc66a8e3adea6609bda350345bd3711657b7ef3cf2e8015b526bac2d6b";
            sha256 = "0imblp0kw9vkcr7sp962jmj20fpmb3hvd3hmf4cs4x04klnq3k90";
            finalImageTag = "21.1.2-debian-11-r0";
          })
        ]
      '';
      description = ''
        List of derivations that provide container images.
        All images are linked to {file}`${imageDir}` before k3s starts and consequently imported
        by the k3s agent. This option only makes sense on nodes with an enabled agent.
      '';
    };
  };

  # implementation

  config = mkIf cfg.enable {
    warnings =
      (lib.optional (cfg.role != "server" && cfg.manifests != { })
        "k3s: Auto deploying manifests are only installed on server nodes (role == server), they will be ignored by this node."
      )
      ++ (lib.optional (cfg.role != "server" && cfg.charts != { })
        "k3s: Helm charts are only made available to the cluster on server nodes (role == server), they will be ignored by this node."
      )
      ++ (lib.optional (cfg.disableAgent && cfg.images != [ ])
        "k3s: Images are only imported on nodes with an enabled agent, they will be ignored by this node"
      );

    assertions = [
      {
        assertion = cfg.role == "agent" -> (cfg.configPath != null || cfg.serverAddr != "");
        message = "serverAddr or configPath (with 'server' key) should be set if role is 'agent'";
      }
      {
        assertion =
          cfg.role == "agent" -> cfg.configPath != null || cfg.tokenFile != null || cfg.token != "";
        message = "token or tokenFile or configPath (with 'token' or 'token-file' keys) should be set if role is 'agent'";
      }
      {
        assertion = cfg.role == "agent" -> !cfg.disableAgent;
        message = "disableAgent must be false if role is 'agent'";
      }
      {
        assertion = cfg.role == "agent" -> !cfg.clusterInit;
        message = "clusterInit must be false if role is 'agent'";
      }
    ];

    environment.systemPackages = [ config.services.k3s.package ];

    systemd.services.k3s = {
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
      path = optional config.boot.zfs.enabled config.boot.zfs.package;
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
        ExecStart = concatStringsSep " \\\n " (
          [ "${cfg.package}/bin/k3s ${cfg.role}" ]
          ++ (optional cfg.clusterInit "--cluster-init")
          ++ (optional cfg.disableAgent "--disable-agent")
          ++ (optional (cfg.serverAddr != "") "--server ${cfg.serverAddr}")
          ++ (optional (cfg.token != "") "--token ${cfg.token}")
          ++ (optional (cfg.tokenFile != null) "--token-file ${cfg.tokenFile}")
          ++ (optional (cfg.configPath != null) "--config ${cfg.configPath}")
          ++ [ cfg.extraFlags ]
        );
      };
    };
  };

  meta.maintainers = lib.teams.k3s.members;
}
