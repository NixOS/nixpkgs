{ config, pkgs, lib, ... }:

with lib;

let
  version = "1.5.0";
  cfg = config.services.kubernetes.addons.dns;
  ports = {
    dns = 10053;
    health = 10054;
    metrics = 10055;
  };
in {
  options.services.kubernetes.addons.dns = {
    enable = mkEnableOption "kubernetes dns addon";

    clusterIp = mkOption {
      description = "Dns addon clusterIP";

      # this default is also what kubernetes users
      default = (
        concatStringsSep "." (
          take 3 (splitString "." config.services.kubernetes.apiserver.serviceClusterIpRange
        ))
      ) + ".254";
      type = types.str;
    };

    clusterDomain = mkOption {
      description = "Dns cluster domain";
      default = "cluster.local";
      type = types.str;
    };

    replicas = mkOption {
      description = "Number of DNS pod replicas to deploy in the cluster.";
      default = 2;
      type = types.int;
    };

    reconcileMode = mkOption {
      description = ''
        Controls the addon manager reconciliation mode for the DNS addon.

        Setting reconcile mode to EnsureExists makes it possible to tailor DNS behavior by editing the coredns ConfigMap.

        See: <link xlink:href="https://github.com/kubernetes/kubernetes/blob/master/cluster/addons/addon-manager/README.md"/>.
      '';
      default = "Reconcile";
      type = types.enum [ "Reconcile" "EnsureExists" ];
    };

    coredns = mkOption {
      description = "Docker image to seed for the CoreDNS container.";
      type = types.attrs;
      default = {
        imageName = "coredns/coredns";
        imageDigest = "sha256:e83beb5e43f8513fa735e77ffc5859640baea30a882a11cc75c4c3244a737d3c";
        finalImageTag = version;
        sha256 = "15sbmhrxjxidj0j0cccn1qxpg6al175w43m6ngspl0mc132zqc9q";
      };
    };
  };

  config = mkIf cfg.enable {
    services.kubernetes.kubelet.seedDockerImages =
      singleton (pkgs.dockerTools.pullImage cfg.coredns);

    services.kubernetes.addonManager.bootstrapAddons = {
      coredns-cr = {
        apiVersion = "rbac.authorization.k8s.io/v1beta1";
        kind = "ClusterRole";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "kube-dns";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/bootstrapping" = "rbac-defaults";
          };
          name = "system:coredns";
        };
        rules = [
          {
            apiGroups = [ "" ];
            resources = [ "endpoints" "services" "pods" "namespaces" ];
            verbs = [ "list" "watch" ];
          }
          {
            apiGroups = [ "" ];
            resources = [ "nodes" ];
            verbs = [ "get" ];
          }
        ];
      };

      coredns-crb = {
        apiVersion = "rbac.authorization.k8s.io/v1beta1";
        kind = "ClusterRoleBinding";
        metadata = {
          annotations = {
            "rbac.authorization.kubernetes.io/autoupdate" = "true";
          };
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "kube-dns";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/bootstrapping" = "rbac-defaults";
          };
          name = "system:coredns";
        };
        roleRef = {
          apiGroup = "rbac.authorization.k8s.io";
          kind = "ClusterRole";
          name = "system:coredns";
        };
        subjects = [
          {
            kind = "ServiceAccount";
            name = "coredns";
            namespace = "kube-system";
          }
        ];
      };
    };

    services.kubernetes.addonManager.addons = {
      coredns-sa = {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "kube-dns";
            "kubernetes.io/cluster-service" = "true";
          };
          name = "coredns";
          namespace = "kube-system";
        };
      };

      coredns-cm = {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = cfg.reconcileMode;
            "k8s-app" = "kube-dns";
            "kubernetes.io/cluster-service" = "true";
          };
          name = "coredns";
          namespace = "kube-system";
        };
        data = {
          Corefile = ".:${toString ports.dns} {
            errors
            health :${toString ports.health}
            kubernetes ${cfg.clusterDomain} in-addr.arpa ip6.arpa {
              pods insecure
              upstream
              fallthrough in-addr.arpa ip6.arpa
            }
            prometheus :${toString ports.metrics}
            forward . /etc/resolv.conf
            cache 30
            loop
            reload
            loadbalance
          }";
        };
      };

      coredns-deploy = {
        apiVersion = "extensions/v1beta1";
        kind = "Deployment";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = cfg.reconcileMode;
            "k8s-app" = "kube-dns";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/name" = "CoreDNS";
          };
          name = "coredns";
          namespace = "kube-system";
        };
        spec = {
          replicas = cfg.replicas;
          selector = {
            matchLabels = { k8s-app = "kube-dns"; };
          };
          strategy = {
            rollingUpdate = { maxUnavailable = 1; };
            type = "RollingUpdate";
          };
          template = {
            metadata = {
              labels = {
                k8s-app = "kube-dns";
              };
            };
            spec = {
              containers = [
                {
                  args = [ "-conf" "/etc/coredns/Corefile" ];
                  image = with cfg.coredns; "${imageName}:${finalImageTag}";
                  imagePullPolicy = "Never";
                  livenessProbe = {
                    failureThreshold = 5;
                    httpGet = {
                      path = "/health";
                      port = ports.health;
                      scheme = "HTTP";
                    };
                    initialDelaySeconds = 60;
                    successThreshold = 1;
                    timeoutSeconds = 5;
                  };
                  name = "coredns";
                  ports = [
                    {
                      containerPort = ports.dns;
                      name = "dns";
                      protocol = "UDP";
                    }
                    {
                      containerPort = ports.dns;
                      name = "dns-tcp";
                      protocol = "TCP";
                    }
                    {
                      containerPort = ports.metrics;
                      name = "metrics";
                      protocol = "TCP";
                    }
                  ];
                  resources = {
                    limits = {
                      memory = "170Mi";
                    };
                    requests = {
                      cpu = "100m";
                      memory = "70Mi";
                    };
                  };
                  securityContext = {
                    allowPrivilegeEscalation = false;
                    capabilities = {
                      drop = [ "all" ];
                    };
                    readOnlyRootFilesystem = true;
                  };
                  volumeMounts = [
                    {
                      mountPath = "/etc/coredns";
                      name = "config-volume";
                      readOnly = true;
                    }
                  ];
                }
              ];
              dnsPolicy = "Default";
              nodeSelector = {
                "beta.kubernetes.io/os" = "linux";
              };
              serviceAccountName = "coredns";
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
                    items = [
                      {
                        key = "Corefile";
                        path = "Corefile";
                      }
                    ];
                    name = "coredns";
                  };
                  name = "config-volume";
                }
              ];
            };
          };
        };
      };

      coredns-svc = {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          annotations = {
            "prometheus.io/port" = toString ports.metrics;
            "prometheus.io/scrape" = "true";
          };
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "kube-dns";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/name" = "CoreDNS";
          };
          name = "kube-dns";
          namespace = "kube-system";
        };
        spec = {
          clusterIP = cfg.clusterIp;
          ports = [
            {
              name = "dns";
              port = 53;
              targetPort = ports.dns;
              protocol = "UDP";
            }
            {
              name = "dns-tcp";
              port = 53;
              targetPort = ports.dns;
              protocol = "TCP";
            }
          ];
          selector = { k8s-app = "kube-dns"; };
        };
      };
    };

    services.kubernetes.kubelet.clusterDns = mkDefault cfg.clusterIp;
  };
}
