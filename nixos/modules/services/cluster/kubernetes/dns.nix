{ config, pkgs, lib, ... }:

with lib;

let
  version = "1.14.10";

  k8s-dns-kube-dns = pkgs.dockerTools.pullImage {
    imageName = "k8s.gcr.io/k8s-dns-kube-dns-amd64";
    imageDigest = "sha256:b99fc3eee2a9f052f7eb4cc00f15eb12fc405fa41019baa2d6b79847ae7284a8";
    finalImageTag = version;
    sha256 = "0x583znk9smqn0fix7ld8sm5jgaxhqhx3fq97b1wkqm7iwhvl3pj";
  };

  k8s-dns-dnsmasq-nanny = pkgs.dockerTools.pullImage {
    imageName = "k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64";
    imageDigest = "sha256:bbb2a290a568125b3b996028958eb773f33b5b87a6b37bf38a28f8b62dddb3c8";
    finalImageTag = version;
    sha256 = "1fihml7s2mfwgac51cbqpylkwbivc8nyhgi4vb820s83zvl8a6y1";
  };

  k8s-dns-sidecar = pkgs.dockerTools.pullImage {
    imageName = "k8s.gcr.io/k8s-dns-sidecar-amd64";
    imageDigest = "sha256:4f1ab957f87b94a5ec1edc26fae50da2175461f00afecf68940c4aa079bd08a4";
    finalImageTag = version;
    sha256 = "08l1bv5jgrhvjzpqpbinrkgvv52snc4fzyd8ya9v18ns2klyz7m0";
  };

  cfg = config.services.kubernetes.addons.dns;
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
  };

  config = mkIf cfg.enable {
    services.kubernetes.kubelet.seedDockerImages = [
      k8s-dns-kube-dns
      k8s-dns-dnsmasq-nanny
      k8s-dns-sidecar
    ];

    services.kubernetes.addonManager.addons = {
      kubedns-deployment = {
        apiVersion = "extensions/v1beta1";
        kind = "Deployment";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "kube-dns";
            "kubernetes.io/cluster-service" = "true";
          };
          name = "kube-dns";
          namespace = "kube-system";
        };
        spec = {
          selector.matchLabels."k8s-app" = "kube-dns";
          strategy = {
            rollingUpdate = {
              maxSurge = "10%";
              maxUnavailable = 0;
            };
          };
          template = {
            metadata = {
              annotations."scheduler.alpha.kubernetes.io/critical-pod" = "";
              labels.k8s-app = "kube-dns";
            };
            spec = {
              priorityClassName = "system-cluster-critical";
              containers = [
                {
                  name = "kubedns";
                  image = "k8s.gcr.io/k8s-dns-kube-dns-amd64:${version}";
                  resources = {
                    limits.memory = "170Mi";
                    requests = {
                      cpu = "100m";
                      memory = "70Mi";
                    };
                  };
                  livenessProbe = {
                    failureThreshold = 5;
                    httpGet = {
                      path = "/healthcheck/kubedns";
                      port = 10054;
                      scheme = "HTTP";
                    };
                    initialDelaySeconds = 60;
                    successThreshold = 1;
                    timeoutSeconds = 5;
                  };
                  readinessProbe = {
                    httpGet = {
                      path = "/readiness";
                      port = 8081;
                      scheme = "HTTP";
                    };
                    initialDelaySeconds = 3;
                    timeoutSeconds = 5;
                  };
                  args = [
                    "--domain=${cfg.clusterDomain}"
                    "--dns-port=10053"
                    "--config-dir=/kube-dns-config"
                    "--v=2"
                  ];
                  env = [
                    {
                      name = "PROMETHEUS_PORT";
                      value = "10055";
                    }
                  ];
                  ports = [
                    {
                      containerPort = 10053;
                      name = "dns-local";
                      protocol = "UDP";
                    }
                    {
                      containerPort = 10053;
                      name = "dns-tcp-local";
                      protocol = "TCP";
                    }
                    {
                      containerPort = 10055;
                      name = "metrics";
                      protocol = "TCP";
                    }
                  ];
                  volumeMounts = [
                    {
                      mountPath = "/kube-dns-config";
                      name = "kube-dns-config";
                    }
                  ];
                }
                {
                  name = "dnsmasq";
                  image = "k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64:${version}";
                  livenessProbe = {
                    httpGet = {
                      path = "/healthcheck/dnsmasq";
                      port = 10054;
                      scheme = "HTTP";
                    };
                    initialDelaySeconds = 60;
                    timeoutSeconds = 5;
                    successThreshold = 1;
                    failureThreshold = 5;
                  };
                  args = [
                    "-v=2"
                    "-logtostderr"
                    "-configDir=/etc/k8s/dns/dnsmasq-nanny"
                    "-restartDnsmasq=true"
                    "--"
                    "-k"
                    "--cache-size=1000"
                    "--log-facility=-"
                    "--server=/${cfg.clusterDomain}/127.0.0.1#10053"
                    "--server=/in-addr.arpa/127.0.0.1#10053"
                    "--server=/ip6.arpa/127.0.0.1#10053"
                  ];
                  ports = [
                    {
                      containerPort = 53;
                      name = "dns";
                      protocol = "UDP";
                    }
                    {
                      containerPort = 53;
                      name = "dns-tcp";
                      protocol = "TCP";
                    }
                  ];
                  resources = {
                    requests = {
                      cpu = "150m";
                      memory = "20Mi";
                    };
                  };
                  volumeMounts = [
                    {
                      mountPath = "/etc/k8s/dns/dnsmasq-nanny";
                      name = "kube-dns-config";
                    }
                  ];
                }
                {
                  name = "sidecar";
                  image = "k8s.gcr.io/k8s-dns-sidecar-amd64:${version}";
                  livenessProbe = {
                    httpGet = {
                      path = "/metrics";
                      port = 10054;
                      scheme = "HTTP";
                    };
                    initialDelaySeconds = 60;
                    timeoutSeconds = 5;
                    successThreshold = 1;
                    failureThreshold = 5;
                  };
                  args = [
                    "--v=2"
                    "--logtostderr"
                    "--probe=kubedns,127.0.0.1:10053,kubernetes.default.svc.${cfg.clusterDomain},5,A"
                    "--probe=dnsmasq,127.0.0.1:53,kubernetes.default.svc.${cfg.clusterDomain},5,A"
                  ];
                  ports = [
                    {
                      containerPort = 10054;
                      name = "metrics";
                      protocol = "TCP";
                    }
                  ];
                  resources = {
                    requests = {
                      cpu = "10m";
                      memory = "20Mi";
                    };
                  };
                }
              ];
              dnsPolicy = "Default";
              serviceAccountName = "kube-dns";
              tolerations = [
                {
                  key = "CriticalAddonsOnly";
                  operator = "Exists";
                }
              ];
              volumes = [
                {
                  configMap = {
                    name = "kube-dns";
                    optional = true;
                  };
                  name = "kube-dns-config";
                }
              ];
            };
          };
        };
      };

      kubedns-svc = {
        apiVersion = "v1";
        kind = "Service";
        metadata = {
          labels = {
            "addonmanager.kubernetes.io/mode" = "Reconcile";
            "k8s-app" = "kube-dns";
            "kubernetes.io/cluster-service" = "true";
            "kubernetes.io/name" = "KubeDNS";
          };
          name = "kube-dns";
          namespace  = "kube-system";
        };
        spec = {
          clusterIP = cfg.clusterIp;
          ports = [
            {name = "dns"; port = 53; protocol = "UDP";}
            {name = "dns-tcp"; port = 53; protocol = "TCP";}
          ];
          selector.k8s-app = "kube-dns";
        };
      };

      kubedns-sa = {
        apiVersion = "v1";
        kind = "ServiceAccount";
        metadata = {
          name = "kube-dns";
          namespace = "kube-system";
          labels = {
            "kubernetes.io/cluster-service" = "true";
            "addonmanager.kubernetes.io/mode" = "Reconcile";
          };
        };
      };

      kubedns-cm = {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "kube-dns";
          namespace = "kube-system";
          labels = {
            "addonmanager.kubernetes.io/mode" = "EnsureExists";
          };
        };
      };
    };

    services.kubernetes.kubelet.clusterDns = mkDefault cfg.clusterIp;
  };
}
