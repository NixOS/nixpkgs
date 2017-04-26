{ cfg }: {
    "kubedns-cm" = {
        "apiVersion" = "v1";
        "kind" = "ConfigMap";
        "metadata" = {
            "labels" = {
                "addonmanager.kubernetes.io/mode" = "EnsureExists";
            };
            "name" = "kube-dns";
            "namespace" = "kube-system";
        };
    };
    "kubedns-controller" = {
        "apiVersion" = "extensions/v1beta1";
        "kind" = "Deployment";
        "metadata" = {
            "labels" = {
                "addonmanager.kubernetes.io/mode" = "Reconcile";
                "k8s-app" = "kube-dns";
                "kubernetes.io/cluster-service" = "true";
            };
            "name" = "kube-dns";
            "namespace" = "kube-system";
        };
        "spec" = {
            "selector" = {
                "matchLabels" = {
                    "k8s-app" = "kube-dns";
                };
            };
            "strategy" = {
                "rollingUpdate" = {
                    "maxSurge" = "10%";
                    "maxUnavailable" = 0;
                };
            };
            "template" = {
                "metadata" = {
                    "annotations" = {
                        "scheduler.alpha.kubernetes.io/critical-pod" = "";
                    };
                    "labels" = {
                        "k8s-app" = "kube-dns";
                    };
                };
                "spec" = {
                    "containers" = [{
                        "args" = ["--domain=${cfg.dns.domain}."
                            "--dns-port=10053"
                            "--config-dir=/kube-dns-config"
                            "--kube-master-url=${cfg.kubeconfig.server}"
                            "--v=2"
                        ];
                        "env" = [{
                            "name" = "PROMETHEUS_PORT";
                            "value" = "10055";
                        }];
                        "image" = "gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.1";
                        "livenessProbe" = {
                            "failureThreshold" = 5;
                            "httpGet" = {
                                "path" = "/healthcheck/kubedns";
                                "port" = 10054;
                                "scheme" = "HTTP";
                            };
                            "initialDelaySeconds" = 60;
                            "successThreshold" = 1;
                            "timeoutSeconds" = 5;
                        };
                        "name" = "kubedns";
                        "ports" = [{
                            "containerPort" = 10053;
                            "name" = "dns-local";
                            "protocol" = "UDP";
                        } {
                            "containerPort" = 10053;
                            "name" = "dns-tcp-local";
                            "protocol" = "TCP";
                        } {
                            "containerPort" = 10055;
                            "name" = "metrics";
                            "protocol" = "TCP";
                        }];
                        "readinessProbe" = {
                            "httpGet" = {
                                "path" = "/readiness";
                                "port" = 8081;
                                "scheme" = "HTTP";
                            };
                            "initialDelaySeconds" = 3;
                            "timeoutSeconds" = 5;
                        };
                        "resources" = {
                            "limits" = {
                                "memory" = "170Mi";
                            };
                            "requests" = {
                                "cpu" = "100m";
                                "memory" = "70Mi";
                            };
                        };
                        "volumeMounts" = [{
                            "mountPath" = "/kube-dns-config";
                            "name" = "kube-dns-config";
                        }];
                    } {
                        "args" = ["-v=2"
                            "-logtostderr"
                            "-configDir=/etc/k8s/dns/dnsmasq-nanny"
                            "-restartDnsmasq=true"
                            "--"
                            "-k"
                            "--cache-size=1000"
                            "--log-facility=-"
                            "--server=/${cfg.dns.domain}/127.0.0.1#10053"
                            "--server=/in-addr.arpa/127.0.0.1#10053"
                            "--server=/ip6.arpa/127.0.0.1#10053"
                        ];
                        "image" = "gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.1";
                        "livenessProbe" = {
                            "failureThreshold" = 5;
                            "httpGet" = {
                                "path" = "/healthcheck/dnsmasq";
                                "port" = 10054;
                                "scheme" = "HTTP";
                            };
                            "initialDelaySeconds" = 60;
                            "successThreshold" = 1;
                            "timeoutSeconds" = 5;
                        };
                        "name" = "dnsmasq";
                        "ports" = [{
                            "containerPort" = 53;
                            "name" = "dns";
                            "protocol" = "UDP";
                        } {
                            "containerPort" = 53;
                            "name" = "dns-tcp";
                            "protocol" = "TCP";
                        }];
                        "resources" = {
                            "requests" = {
                                "cpu" = "150m";
                                "memory" = "20Mi";
                            };
                        };
                        "volumeMounts" = [{
                            "mountPath" = "/etc/k8s/dns/dnsmasq-nanny";
                            "name" = "kube-dns-config";
                        }];
                    } {
                        "args" = ["--v=2"
                            "--logtostderr"
                            "--probe=kubedns,127.0.0.1:10053,kubernetes.default.svc.${cfg.dns.domain},5,A"
                            "--probe=dnsmasq,127.0.0.1:53,kubernetes.default.svc.${cfg.dns.domain},5,A"
                        ];
                        "image" = "gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.1";
                        "livenessProbe" = {
                            "failureThreshold" = 5;
                            "httpGet" = {
                                "path" = "/metrics";
                                "port" = 10054;
                                "scheme" = "HTTP";
                            };
                            "initialDelaySeconds" = 60;
                            "successThreshold" = 1;
                            "timeoutSeconds" = 5;
                        };
                        "name" = "sidecar";
                        "ports" = [{
                            "containerPort" = 10054;
                            "name" = "metrics";
                            "protocol" = "TCP";
                        }];
                        "resources" = {
                            "requests" = {
                                "cpu" = "10m";
                                "memory" = "20Mi";
                            };
                        };
                    }];
                    "dnsPolicy" = "Default";
                    "serviceAccountName" = "kube-dns";
                    "tolerations" = [{
                        "key" = "CriticalAddonsOnly";
                        "operator" = "Exists";
                    }];
                    "volumes" = [{
                        "configMap" = {
                            "name" = "kube-dns";
                            "optional" = true;
                        };
                        "name" = "kube-dns-config";
                    }];
                };
            };
        };
    };
    "kubedns-sa" = {
        "apiVersion" = "v1";
        "kind" = "ServiceAccount";
        "metadata" = {
            "labels" = {
                "addonmanager.kubernetes.io/mode" = "Reconcile";
                "kubernetes.io/cluster-service" = "true";
            };
            "name" = "kube-dns";
            "namespace" = "kube-system";
        };
    };
    "kubedns-svc" = {
        "apiVersion" = "v1";
        "kind" = "Service";
        "metadata" = {
            "labels" = {
                "addonmanager.kubernetes.io/mode" = "Reconcile";
                "k8s-app" = "kube-dns";
                "kubernetes.io/cluster-service" = "true";
                "kubernetes.io/name" = "KubeDNS";
            };
            "name" = "kube-dns";
            "namespace" = "kube-system";
        };
        "spec" = {
            "clusterIP" = "${cfg.dns.serverIp}";
            "ports" = [{
                "name" = "dns";
                "port" = 53;
                "protocol" = "UDP";
            } {
                "name" = "dns-tcp";
                "port" = 53;
                "protocol" = "TCP";
            }];
            "selector" = {
                "k8s-app" = "kube-dns";
            };
        };
    };
}
