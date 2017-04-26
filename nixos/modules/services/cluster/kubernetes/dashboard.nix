{ cfg }: {
    "dashboard-controller" = {
        "apiVersion" = "extensions/v1beta1";
        "kind" = "Deployment";
        "metadata" = {
            "labels" = {
                "addonmanager.kubernetes.io/mode" = "Reconcile";
                "k8s-app" = "kubernetes-dashboard";
                "kubernetes.io/cluster-service" = "true";
            };
            "name" = "kubernetes-dashboard";
            "namespace" = "kube-system";
        };
        "spec" = {
            "selector" = {
                "matchLabels" = {
                    "k8s-app" = "kubernetes-dashboard";
                };
            };
            "template" = {
                "metadata" = {
                    "annotations" = {
                        "scheduler.alpha.kubernetes.io/critical-pod" = "";
                    };
                    "labels" = {
                        "k8s-app" = "kubernetes-dashboard";
                    };
                };
                "spec" = {
                    "containers" = [{
                        "image" = "gcr.io/google_containers/kubernetes-dashboard-amd64:v1.6.0";
                        "livenessProbe" = {
                            "httpGet" = {
                                "path" = "/";
                                "port" = 9090;
                            };
                            "initialDelaySeconds" = 30;
                            "timeoutSeconds" = 30;
                        };
                        "name" = "kubernetes-dashboard";
                        "ports" = [{
                            "containerPort" = 9090;
                        }];
                        "resources" = {
                            "limits" = {
                                "cpu" = "100m";
                                "memory" = "50Mi";
                            };
                            "requests" = {
                                "cpu" = "100m";
                                "memory" = "50Mi";
                            };
                        };
                    }];
                    "tolerations" = [{
                        "key" = "CriticalAddonsOnly";
                        "operator" = "Exists";
                    }];
                };
            };
        };
    };
    "dashboard-service" = {
        "apiVersion" = "v1";
        "kind" = "Service";
        "metadata" = {
            "labels" = {
                "addonmanager.kubernetes.io/mode" = "Reconcile";
                "k8s-app" = "kubernetes-dashboard";
                "kubernetes.io/cluster-service" = "true";
            };
            "name" = "kubernetes-dashboard";
            "namespace" = "kube-system";
        };
        "spec" = {
            "ports" = [{
                "port" = 80;
                "targetPort" = 9090;
            }];
            "selector" = {
                "k8s-app" = "kubernetes-dashboard";
            };
        };
    };
}
