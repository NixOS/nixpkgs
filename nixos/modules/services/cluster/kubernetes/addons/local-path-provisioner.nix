{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.kubernetes.addons.local-path-provisioner;

  helperImage = pkgs.dockerTools.buildLayeredImage {
    name = "busybox";
    contents = [ pkgs.busybox ];
  };

  package = pkgs.buildGoPackage rec {
    name = "local-path-provisioner-${version}";
    version = "0.0.5";
    src = pkgs.fetchFromGitHub {
      owner = "rancher";
      repo = "local-path-provisioner";
      rev = "v${version}";
      sha256 = "1bvk8w3avd4v824jcnpr0w7z93b6awdqsc31y5lnh3dcc3apjpp6";
    };
    patches = [ ./0001-Change-ImagePullPolicy-to-IfNotPresent.patch ];
    goPackagePath = "github.com/rancher/local-path-provisioner";
  };

  image = pkgs.dockerTools.buildLayeredImage {
    name = "local-path-provisioner";
    contents = [ package ];
    extraCommands = ''
      mkdir tmp
      chmod 1777 tmp
    '';
  };
in {
  options.services.kubernetes.addons.local-path-provisioner = {
    enable = mkEnableOption "kubernetes local-path-provisioner addon";

    image = mkOption {
      description = "Docker image to seed for the CoreDNS container.";
      type = types.package;
      default = image;
    };

    storageClass = {
      name = mkOption {
        description = "Name of the storage class";
        type = types.str;
        default = "local-path";
      };

      isDefault = mkOption {
        description = "Whether this is a default storage class";
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    services.kubernetes.kubelet.seedDockerImages = [ cfg.image helperImage ];

    services.kubernetes.addonManager.bootstrapAddons = {
      local-path-provisioner-cr = {
        apiVersion = "rbac.authorization.k8s.io/v1beta1";
        kind = "ClusterRole";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "local-path-provisioner";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/bootstrapping" = "rbac-defaults";
          };
          name = "system:local-path-provisioner";
        };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [ "nodes" "persistentvolumeclaims" ];
            verbs = [  "get" "list" "watch" ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "endpoints" "persistentvolumes" "pods" ];
            verbs = [ "*" ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "events" ];
            verbs = [ "create" "patch" ];
          }
          {
            apiGroups = [ "storage.k8s.io" ];
            resources = [ "storageclasses" ];
            verbs = [ "get" "list" "watch" ];
          }
        ];
      };

      local-path-provisioner-crb = {
        apiVersion = "rbac.authorization.k8s.io/v1beta1";
        kind = "ClusterRoleBinding";
        metadata = {
          annotations = {
            "rbac.authorization.kubernetes.io/autoupdate" = "true";
          };
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "local-path-provisioner";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/bootstrapping" = "rbac-defaults";
          };
          name = "system:local-path-provisioner";
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "system:local-path-provisioner";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "local-path-provisioner";
            namespace = "kube-system";
          }
        ];
      };

      local-path-provisioner-sc = {
        apiVersion = "storage.k8s.io/v1";
        kind = "StorageClass";
        metadata = {
          name = cfg.storageClass.name;
          namespace = "kube-system";
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "local-path-provisioner";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/name" = "local-path-provisioner";
          };
          annotations = {
            "storageclass.kubernetes.io/is-default-class" = if cfg.storageClass.isDefault then "true" else "false";
          };
        };
        provisioner = "rancher.io/local-path";
        volumeBindingMode = "WaitForFirstConsumer";
        reclaimPolicy = "Delete";
      };
    };

    services.kubernetes.addonManager.addons = {
      local-path-provisioner-sa = {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "local-path-provisioner";
            "kubernetes.io/cluster-service" = "true";
          };
          name = "local-path-provisioner";
          namespace = "kube-system";
        };
      };

      local-path-provisioner-cm = {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "local-path-provisioner";
            "kubernetes.io/cluster-service" = "true";
          };
          name = "local-path-provisioner";
          namespace = "kube-system";
        };
        data = {
          "config.json" = builtins.toJSON {
            nodePathMap = [{
              node = "DEFAULT_PATH_FOR_NON_LISTED_NODES";
              paths = ["/opt/local-path-provisioner"];
            }];
          };
        };
      };

      local-path-provisioner-deploy = {
        apiVersion = "extensions/v1beta1";
        kind = "Deployment";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "local-path-provisioner";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/name" = "local-path-provisioner";
          };
          name = "local-path-provisioner";
          namespace = "kube-system";
        };
        spec = {
          replicas = 1;
          selector = {
            matchLabels.k8s-app = "local-path-provisioner";
          };
          template = {
            metadata = {
              labels = {
                k8s-app = "local-path-provisioner";
              };
            };
            spec = {
              containers = [
                {
                  command = [
                    "local-path-provisioner"
                    "--debug"
                    "start"
                    "--config"
                    "/etc/config/config.json"
                    "--namespace"
                    "kube-system"
                    "--helper-image"
                    "${helperImage.imageName}:${helperImage.imageTag}"
                  ];
                  image = with cfg.image; "${imageName}:${imageTag}";
                  imagePullPolicy = "Never";
                  name = "local-path-provisioner";
                  resources = {
                    limits = {
                      memory = "50Mi";
                    };
                    requests = {
                      cpu = "100m";
                      memory = "50Mi";
                    };
                  };
                  volumeMounts = [
                    {
                      mountPath = "/etc/config";
                      name = "config-volume";
                      readOnly = true;
                    }
                  ];
                }
              ];
              serviceAccountName = "local-path-provisioner";
              tolerations = [
                {
                  effect = "NoSchedule";
                  key = "node-role.kubernetes.io/master";
                }
                {
                  key = "CriticalAddonsOnly";
                  operator = "Exists";
                }
              ];
              volumes = [
                {
                  configMap = {
                    name = "local-path-provisioner";
                  };
                  name = "config-volume";
                }
              ];
            };
          };
        };
      };
    };
  };
}
