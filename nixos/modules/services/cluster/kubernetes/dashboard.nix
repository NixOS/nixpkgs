{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.kubernetes.addons.dashboard;

  name = "gcr.io/google_containers/kubernetes-dashboard-amd64";
	version = "v1.8.2";

  image = pkgs.dockerTools.pullImage {
    imageName = name;
    imageTag = version;
    sha256 = "11h0fz3wxp0f10fsyqaxjm7l2qg7xws50dv5iwlck5gb1fjmajad";
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
        apiVersion = "apps/v1beta1";
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
                #"scheduler.alpha.kubernetes.io/tolerations" = ''[{"key":"CriticalAddonsOnly", "operator":"Exists"}]'';
              };
            };
            spec = {
              containers = [{
                name = "kubernetes-dashboard";
                image = "${name}:${version}";
                ports = [{
                  containerPort = 9090;
                  protocol = "TCP";
                }];
                resources = {
                  limits = {
                    cpu = "100m";
                    memory = "250Mi";
                  };
                  requests = {
                    cpu = "100m";
                    memory = "50Mi";
                  };
                };
                livenessProbe = {
                  httpGet = {
                    path = "/";
                    port = 9090;
                  };
                  initialDelaySeconds = 30;
                  timeoutSeconds = 30;
                };
              }];
              serviceAccountName = "kubernetes-dashboard";
              tolerations = [{
                key = "node-role.kubernetes.io/master";
                effect = "NoSchedule";
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
            port = 80;
            targetPort = 9090;
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
    } // (optionalAttrs cfg.enableRBAC {
      kubernetes-dashboard-crb = {
        apiVersion = "rbac.authorization.k8s.io/v1beta1";
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
