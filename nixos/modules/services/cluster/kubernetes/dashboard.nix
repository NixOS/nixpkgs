{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.kubernetes.addons.dashboard;

  name = "k8s.gcr.io/kubernetes-dashboard-amd64";
  version = "v1.8.3";

  image = pkgs.dockerTools.pullImage {
    imageName = name;
    imageDigest = "sha256:dc4026c1b595435ef5527ca598e1e9c4343076926d7d62b365c44831395adbd0";
    finalImageTag = version;
    sha256 = "18ajcg0q1vignfjk2sm4xj4wzphfz8wah69ps8dklqfvv0164mc8";
  };
in {
  options.services.kubernetes.addons.dashboard = {
    enable = mkEnableOption "kubernetes dashboard addon";

    enableRBAC = mkOption {
      description = "Whether to enable role based access control is enabled for kubernetes dashboard";
      type = types.bool;
      default = elem "RBAC" config.services.kubernetes.apiserver.authorizationMode;
    };
  };

  config = mkIf cfg.enable {
    services.kubernetes.kubelet.seedDockerImages = [image];

    services.kubernetes.addonManager.addons = {
      kubernetes-dashboard-deployment = {
        kind = "Deployment";
        apiVersion = "apps/v1";
        metadata = {
          labels = {
            k8s-addon = "kubernetes-dashboard.addons.k8s.io";
            k8s-app = "kubernetes-dashboard";
            version = version;
            "kubernetes.io/cluster-service" = "true";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard";
          namespace = "kube-system";
        };
        spec = {
          replicas = 1;
          revisionHistoryLimit = 10;
          selector.matchLabels."k8s-app" = "kubernetes-dashboard";
          template = {
            metadata = {
              labels = {
                k8s-addon = "kubernetes-dashboard.addons.k8s.io";
                k8s-app = "kubernetes-dashboard";
                version = version;
                "kubernetes.io/cluster-service" = "true";
              };
              annotations = {
                "scheduler.alpha.kubernetes.io/critical-pod" = "";
              };
            };
            spec = {
              priorityClassName = "system-cluster-critical";
              containers = [{
                name = "kubernetes-dashboard";
                image = "${name}:${version}";
                ports = [{
                  containerPort = 8443;
                  protocol = "TCP";
                }];
                resources = {
                  limits = {
                    cpu = "100m";
                    memory = "300Mi";
                  };
                  requests = {
                    cpu = "100m";
                    memory = "100Mi";
                  };
                };
                args = ["--auto-generate-certificates"];
                volumeMounts = [{
                  name = "tmp-volume";
                  mountPath = "/tmp";
                } {
                  name = "kubernetes-dashboard-certs";
                  mountPath = "/certs";
                }];
                livenessProbe = {
                  httpGet = {
                    scheme = "HTTPS";
                    path = "/";
                    port = 8443;
                  };
                  initialDelaySeconds = 30;
                  timeoutSeconds = 30;
                };
              }];
              volumes = [{
                name = "kubernetes-dashboard-certs";
                secret = {
                  secretName = "kubernetes-dashboard-certs";
                };
              } {
                name = "tmp-volume";
                emptyDir = {};
              }];
              serviceAccountName = "kubernetes-dashboard";
              tolerations = [{
                key = "node-role.kubernetes.io/master";
                effect = "NoSchedule";
              } {
                key = "CriticalAddonsOnly";
                operator = "Exists";
              }];
            };
          };
        };
      };

      kubernetes-dashboard-svc = {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          labels = {
            k8s-addon = "kubernetes-dashboard.addons.k8s.io";
            k8s-app = "kubernetes-dashboard";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/name" = "KubeDashboard";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard";
          namespace  = "kube-system";
        };
        spec = {
          ports = [{
            port = 443;
            targetPort = 8443;
          }];
          selector.k8s-app = "kubernetes-dashboard";
        };
      };

      kubernetes-dashboard-sa = {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            k8s-addon = "kubernetes-dashboard.addons.k8s.io";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
          name = "kubernetes-dashboard";
          namespace = "kube-system";
        };
      };
      kubernetes-dashboard-sec-certs = {
        apiVersion = "v1";
        kind = "Secret";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            # Allows editing resource and makes sure it is created first.
            "addonmanager.kubernetes.io/mode" = "EnsureExists";
          };
          name = "kubernetes-dashboard-certs";
          namespace = "kube-system";
        };
        type = "Opaque";
      };
      kubernetes-dashboard-sec-kholder = {
        apiVersion = "v1";
        kind = "Secret";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            # Allows editing resource and makes sure it is created first.
            "addonmanager.kubernetes.io/mode" = "EnsureExists";
          };
          name = "kubernetes-dashboard-key-holder";
          namespace = "kube-system";
        };
        type = "Opaque";
      };
      kubernetes-dashboard-cm = {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          labels = {
            k8s-app = "kubernetes-dashboard";
            # Allows editing resource and makes sure it is created first.
            "addonmanager.kubernetes.io/mode" = "EnsureExists";
          };
          name = "kubernetes-dashboard-settings";
          namespace = "kube-system";
        };
      };
    } // (optionalAttrs cfg.enableRBAC {
      kubernetes-dashboard-crb = {
        apiVersion = "rbac.authorization.k8s.io/v1";
        kind = "ClusterRoleBinding";
        metadata = {
          name = "kubernetes-dashboard";
          labels = {
            k8s-app = "kubernetes-dashboard";
            k8s-addon = "kubernetes-dashboard.addons.k8s.io";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "cluster-admin";
        };
        subjects = [{
          kind = "ServiceAccount";
          name = "kubernetes-dashboard";
          namespace = "kube-system";
        }];
      };
    });
  };
}
