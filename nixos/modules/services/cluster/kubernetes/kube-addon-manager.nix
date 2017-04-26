{ cfg, addons }: {
    "kube-addon-manager" = {
        "apiVersion" = "v1";
        "kind" = "Pod";
        "metadata" = {
            "labels" = {
                "component" = "kube-addon-manager";
            };
            "name" = "kube-addon-manager";
            "namespace" = "kube-system";
        };
        "spec" = {
            "containers" = [{
                "command" = ["/bin/bash"
                    "-c"
                    "/opt/kube-addons.sh | tee /var/log/kube-addon-manager.log"
                ];
                "env" = [{
                    "name" = "KUBECTL_OPTS";
                    "value" = "--server=${cfg.kubeconfig.server}";
                }];
                "image" = "gcr.io/google-containers/kube-addon-manager:${cfg.addonManager.versionTag}";
                "name" = "kube-addon-manager";
                "resources" = {
                    "requests" = {
                        "cpu" = "5m";
                        "memory" = "50Mi";
                    };
                };
                "volumeMounts" = [{
                    "mountPath" = "/etc/kubernetes/addons/";
                    "name" = "addons";
                    "readOnly" = true;
                } {
                    "mountPath" = "/var/log";
                    "name" = "varlog";
                    "readOnly" = false;
                }];
            }];
            "hostNetwork" = true;
            "volumes" = [{
                "hostPath" = {
                    "path" = "${addons}/";
                };
                "name" = "addons";
            } {
                "hostPath" = {
                    "path" = "/var/log";
                };
                "name" = "varlog";
            }];
        };
    };
}
