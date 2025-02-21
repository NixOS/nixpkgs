  { config, lib, options, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  otop = options.services.kubernetes;
  cfg = top.apiserver;

  isRBACEnabled = elem "RBAC" cfg.authorizationMode;

  apiserverServiceIP = (concatStringsSep "." (
    take 3 (splitString "." cfg.serviceClusterIpRange
  )) + ".1");
in
{

  imports = [
    (mkRenamedOptionModule [ "services" "kubernetes" "apiserver" "admissionControl" ] [ "services" "kubernetes" "apiserver" "enableAdmissionPlugins" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "apiserver" "address" ] ["services" "kubernetes" "apiserver" "bindAddress"])
    (mkRemovedOptionModule [ "services" "kubernetes" "apiserver" "insecureBindAddress" ] "")
    (mkRemovedOptionModule [ "services" "kubernetes" "apiserver" "insecurePort" ] "")
    (mkRemovedOptionModule [ "services" "kubernetes" "apiserver" "publicAddress" ] "")
    (mkRenamedOptionModule [ "services" "kubernetes" "etcd" "servers" ] [ "services" "kubernetes" "apiserver" "etcd" "servers" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "etcd" "keyFile" ] [ "services" "kubernetes" "apiserver" "etcd" "keyFile" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "etcd" "certFile" ] [ "services" "kubernetes" "apiserver" "etcd" "certFile" ])
    (mkRenamedOptionModule [ "services" "kubernetes" "etcd" "caFile" ] [ "services" "kubernetes" "apiserver" "etcd" "caFile" ])
  ];

  ###### interface
  options.services.kubernetes.apiserver = with lib.types; {

    advertiseAddress = mkOption {
      description = ''
        Kubernetes apiserver IP address on which to advertise the apiserver
        to members of the cluster. This address must be reachable by the rest
        of the cluster.
      '';
      default = null;
      type = nullOr str;
    };

    allowPrivileged = mkOption {
      description = "Whether to allow privileged containers on Kubernetes.";
      default = false;
      type = bool;
    };

    authorizationMode = mkOption {
      description = ''
        Kubernetes apiserver authorization mode (AlwaysAllow/AlwaysDeny/ABAC/Webhook/RBAC/Node). See
        <https://kubernetes.io/docs/reference/access-authn-authz/authorization/>
      '';
      default = ["RBAC" "Node"]; # Enabling RBAC by default, although kubernetes default is AllowAllow
      type = listOf (enum ["AlwaysAllow" "AlwaysDeny" "ABAC" "Webhook" "RBAC" "Node"]);
    };

    authorizationPolicy = mkOption {
      description = ''
        Kubernetes apiserver authorization policy file. See
        <https://kubernetes.io/docs/reference/access-authn-authz/authorization/>
      '';
      default = [];
      type = listOf attrs;
    };

    basicAuthFile = mkOption {
      description = ''
        Kubernetes apiserver basic authentication file. See
        <https://kubernetes.io/docs/reference/access-authn-authz/authentication>
      '';
      default = null;
      type = nullOr path;
    };

    bindAddress = mkOption {
      description = ''
        The IP address on which to listen for the --secure-port port.
        The associated interface(s) must be reachable by the rest
        of the cluster, and by CLI/web clients.
      '';
      default = "0.0.0.0";
      type = str;
    };

    clientCaFile = mkOption {
      description = "Kubernetes apiserver CA file for client auth.";
      default = top.caFile;
      defaultText = literalExpression "config.${otop.caFile}";
      type = nullOr path;
    };

    disableAdmissionPlugins = mkOption {
      description = ''
        Kubernetes admission control plugins to disable. See
        <https://kubernetes.io/docs/admin/admission-controllers/>
      '';
      default = [];
      type = listOf str;
    };

    enable = mkEnableOption "Kubernetes apiserver";

    enableAdmissionPlugins = mkOption {
      description = ''
        Kubernetes admission control plugins to enable. See
        <https://kubernetes.io/docs/admin/admission-controllers/>
      '';
      default = [
        "NamespaceLifecycle" "LimitRanger" "ServiceAccount"
        "ResourceQuota" "DefaultStorageClass" "DefaultTolerationSeconds"
        "NodeRestriction"
      ];
      example = [
        "NamespaceLifecycle" "NamespaceExists" "LimitRanger"
        "SecurityContextDeny" "ServiceAccount" "ResourceQuota"
        "PodSecurityPolicy" "NodeRestriction" "DefaultStorageClass"
      ];
      type = listOf str;
    };

    etcd = {
      servers = mkOption {
        description = "List of etcd servers.";
        default = ["http://127.0.0.1:2379"];
        type = types.listOf types.str;
      };

      keyFile = mkOption {
        description = "Etcd key file.";
        default = null;
        type = types.nullOr types.path;
      };

      certFile = mkOption {
        description = "Etcd cert file.";
        default = null;
        type = types.nullOr types.path;
      };

      caFile = mkOption {
        description = "Etcd ca file.";
        default = top.caFile;
        defaultText = literalExpression "config.${otop.caFile}";
        type = types.nullOr types.path;
      };
    };

    extraOpts = mkOption {
      description = "Kubernetes apiserver extra command line options.";
      default = "";
      type = separatedString " ";
    };

    extraSANs = mkOption {
      description = "Extra x509 Subject Alternative Names to be added to the kubernetes apiserver tls cert.";
      default = [];
      type = listOf str;
    };

    featureGates = mkOption {
      description = "Attribute set of feature gates.";
      default = top.featureGates;
      defaultText = literalExpression "config.${otop.featureGates}";
      type = attrsOf bool;
    };

    kubeletClientCaFile = mkOption {
      description = "Path to a cert file for connecting to kubelet.";
      default = top.caFile;
      defaultText = literalExpression "config.${otop.caFile}";
      type = nullOr path;
    };

    kubeletClientCertFile = mkOption {
      description = "Client certificate to use for connections to kubelet.";
      default = null;
      type = nullOr path;
    };

    kubeletClientKeyFile = mkOption {
      description = "Key to use for connections to kubelet.";
      default = null;
      type = nullOr path;
    };

    preferredAddressTypes = mkOption {
      description = "List of the preferred NodeAddressTypes to use for kubelet connections.";
      type = nullOr str;
      default = null;
    };

    proxyClientCertFile = mkOption {
      description = "Client certificate to use for connections to proxy.";
      default = null;
      type = nullOr path;
    };

    proxyClientKeyFile = mkOption {
      description = "Key to use for connections to proxy.";
      default = null;
      type = nullOr path;
    };

    runtimeConfig = mkOption {
      description = ''
        Api runtime configuration. See
        <https://kubernetes.io/docs/tasks/administer-cluster/cluster-management/>
      '';
      default = "authentication.k8s.io/v1beta1=true";
      example = "api/all=false,api/v1=true";
      type = str;
    };

    storageBackend = mkOption {
      description = ''
        Kubernetes apiserver storage backend.
      '';
      default = "etcd3";
      type = enum ["etcd2" "etcd3"];
    };

    securePort = mkOption {
      description = "Kubernetes apiserver secure port.";
      default = 6443;
      type = int;
    };

    apiAudiences = mkOption {
      description = ''
        Kubernetes apiserver ServiceAccount issuer.
      '';
      default = "api,https://kubernetes.default.svc";
      type = str;
    };

    serviceAccountIssuer = mkOption {
      description = ''
        Kubernetes apiserver ServiceAccount issuer.
      '';
      default = "https://kubernetes.default.svc";
      type = str;
    };

    serviceAccountSigningKeyFile = mkOption {
      description = ''
        Path to the file that contains the current private key of the service
        account token issuer. The issuer will sign issued ID tokens with this
        private key.
      '';
      type = path;
    };

    serviceAccountKeyFile = mkOption {
      description = ''
        File containing PEM-encoded x509 RSA or ECDSA private or public keys,
        used to verify ServiceAccount tokens. The specified file can contain
        multiple keys, and the flag can be specified multiple times with
        different files. If unspecified, --tls-private-key-file is used.
        Must be specified when --service-account-signing-key is provided
      '';
      type = path;
    };

    serviceClusterIpRange = mkOption {
      description = ''
        A CIDR notation IP range from which to assign service cluster IPs.
        This must not overlap with any IP ranges assigned to nodes for pods.
      '';
      default = "10.0.0.0/24";
      type = str;
    };

    tlsCertFile = mkOption {
      description = "Kubernetes apiserver certificate file.";
      default = null;
      type = nullOr path;
    };

    tlsKeyFile = mkOption {
      description = "Kubernetes apiserver private key file.";
      default = null;
      type = nullOr path;
    };

    tokenAuthFile = mkOption {
      description = ''
        Kubernetes apiserver token authentication file. See
        <https://kubernetes.io/docs/reference/access-authn-authz/authentication>
      '';
      default = null;
      type = nullOr path;
    };

    verbosity = mkOption {
      description = ''
        Optional glog verbosity level for logging statements. See
        <https://github.com/kubernetes/community/blob/master/contributors/devel/logging.md>
      '';
      default = null;
      type = nullOr int;
    };

    webhookConfig = mkOption {
      description = ''
        Kubernetes apiserver Webhook config file. It uses the kubeconfig file format.
        See <https://kubernetes.io/docs/reference/access-authn-authz/webhook/>
      '';
      default = null;
      type = nullOr path;
    };

  };


  ###### implementation
  config = mkMerge [

    (mkIf cfg.enable {
        systemd.services.kube-apiserver = {
          description = "Kubernetes APIServer Service";
          wantedBy = [ "kubernetes.target" ];
          after = [ "network.target" ];
          serviceConfig = {
            Slice = "kubernetes.slice";
            ExecStart = ''${top.package}/bin/kube-apiserver \
              --allow-privileged=${boolToString cfg.allowPrivileged} \
              --authorization-mode=${concatStringsSep "," cfg.authorizationMode} \
                ${optionalString (elem "ABAC" cfg.authorizationMode)
                  "--authorization-policy-file=${
                    pkgs.writeText "kube-auth-policy.jsonl"
                    (concatMapStringsSep "\n" (l: builtins.toJSON l) cfg.authorizationPolicy)
                  }"
                } \
                ${optionalString (elem "Webhook" cfg.authorizationMode)
                  "--authorization-webhook-config-file=${cfg.webhookConfig}"
                } \
              --bind-address=${cfg.bindAddress} \
              ${optionalString (cfg.advertiseAddress != null)
                "--advertise-address=${cfg.advertiseAddress}"} \
              ${optionalString (cfg.clientCaFile != null)
                "--client-ca-file=${cfg.clientCaFile}"} \
              --disable-admission-plugins=${concatStringsSep "," cfg.disableAdmissionPlugins} \
              --enable-admission-plugins=${concatStringsSep "," cfg.enableAdmissionPlugins} \
              --etcd-servers=${concatStringsSep "," cfg.etcd.servers} \
              ${optionalString (cfg.etcd.caFile != null)
                "--etcd-cafile=${cfg.etcd.caFile}"} \
              ${optionalString (cfg.etcd.certFile != null)
                "--etcd-certfile=${cfg.etcd.certFile}"} \
              ${optionalString (cfg.etcd.keyFile != null)
                "--etcd-keyfile=${cfg.etcd.keyFile}"} \
              ${optionalString (cfg.featureGates != {})
                "--feature-gates=${(concatStringsSep "," (builtins.attrValues (mapAttrs (n: v: "${n}=${trivial.boolToString v}") cfg.featureGates)))}"} \
              ${optionalString (cfg.basicAuthFile != null)
                "--basic-auth-file=${cfg.basicAuthFile}"} \
              ${optionalString (cfg.kubeletClientCaFile != null)
                "--kubelet-certificate-authority=${cfg.kubeletClientCaFile}"} \
              ${optionalString (cfg.kubeletClientCertFile != null)
                "--kubelet-client-certificate=${cfg.kubeletClientCertFile}"} \
              ${optionalString (cfg.kubeletClientKeyFile != null)
                "--kubelet-client-key=${cfg.kubeletClientKeyFile}"} \
              ${optionalString (cfg.preferredAddressTypes != null)
                "--kubelet-preferred-address-types=${cfg.preferredAddressTypes}"} \
              ${optionalString (cfg.proxyClientCertFile != null)
                "--proxy-client-cert-file=${cfg.proxyClientCertFile}"} \
              ${optionalString (cfg.proxyClientKeyFile != null)
                "--proxy-client-key-file=${cfg.proxyClientKeyFile}"} \
              ${optionalString (cfg.runtimeConfig != "")
                "--runtime-config=${cfg.runtimeConfig}"} \
              --secure-port=${toString cfg.securePort} \
              --api-audiences=${toString cfg.apiAudiences} \
              --service-account-issuer=${toString cfg.serviceAccountIssuer} \
              --service-account-signing-key-file=${cfg.serviceAccountSigningKeyFile} \
              --service-account-key-file=${cfg.serviceAccountKeyFile} \
              --service-cluster-ip-range=${cfg.serviceClusterIpRange} \
              --storage-backend=${cfg.storageBackend} \
              ${optionalString (cfg.tlsCertFile != null)
                "--tls-cert-file=${cfg.tlsCertFile}"} \
              ${optionalString (cfg.tlsKeyFile != null)
                "--tls-private-key-file=${cfg.tlsKeyFile}"} \
              ${optionalString (cfg.tokenAuthFile != null)
                "--token-auth-file=${cfg.tokenAuthFile}"} \
              ${optionalString (cfg.verbosity != null) "--v=${toString cfg.verbosity}"} \
              ${cfg.extraOpts}
            '';
            WorkingDirectory = top.dataDir;
            User = "kubernetes";
            Group = "kubernetes";
            AmbientCapabilities = "cap_net_bind_service";
            Restart = "on-failure";
            RestartSec = 5;
          };

          unitConfig = {
            StartLimitIntervalSec = 0;
          };
        };

        services.etcd = {
          clientCertAuth = mkDefault true;
          peerClientCertAuth = mkDefault true;
          listenClientUrls = mkDefault ["https://0.0.0.0:2379"];
          listenPeerUrls = mkDefault ["https://0.0.0.0:2380"];
          advertiseClientUrls = mkDefault ["https://${top.masterAddress}:2379"];
          initialCluster = mkDefault ["${top.masterAddress}=https://${top.masterAddress}:2380"];
          name = mkDefault top.masterAddress;
          initialAdvertisePeerUrls = mkDefault ["https://${top.masterAddress}:2380"];
        };

        services.kubernetes.addonManager.bootstrapAddons = mkIf isRBACEnabled {

          apiserver-kubelet-api-admin-crb = {
            apiVersion = "rbac.authorization.k8s.io/v1";
            kind = "ClusterRoleBinding";
            metadata = {
              name = "system:kube-apiserver:kubelet-api-admin";
            };
            roleRef = {
              apiGroup = "rbac.authorization.k8s.io";
              kind = "ClusterRole";
              name = "system:kubelet-api-admin";
            };
            subjects = [{
              kind = "User";
              name = "system:kube-apiserver";
            }];
          };

        };

      services.kubernetes.pki.certs = with top.lib; {
        apiServer = mkCert {
          name = "kube-apiserver";
          CN = "kubernetes";
          hosts = [
                    "kubernetes.default.svc"
                    "kubernetes.default.svc.${top.addons.dns.clusterDomain}"
                    cfg.advertiseAddress
                    top.masterAddress
                    apiserverServiceIP
                    "127.0.0.1"
                  ] ++ cfg.extraSANs;
          action = "systemctl restart kube-apiserver.service";
        };
        apiserverProxyClient = mkCert {
          name = "kube-apiserver-proxy-client";
          CN = "front-proxy-client";
          action = "systemctl restart kube-apiserver.service";
        };
        apiserverKubeletClient = mkCert {
          name = "kube-apiserver-kubelet-client";
          CN = "system:kube-apiserver";
          action = "systemctl restart kube-apiserver.service";
        };
        apiserverEtcdClient = mkCert {
          name = "kube-apiserver-etcd-client";
          CN = "etcd-client";
          action = "systemctl restart kube-apiserver.service";
        };
        clusterAdmin = mkCert {
          name = "cluster-admin";
          CN = "cluster-admin";
          fields = {
            O = "system:masters";
          };
          privateKeyOwner = "root";
        };
        etcd = mkCert {
          name = "etcd";
          CN = top.masterAddress;
          hosts = [
                    "etcd.local"
                    "etcd.${top.addons.dns.clusterDomain}"
                    top.masterAddress
                    cfg.advertiseAddress
                  ];
          privateKeyOwner = "etcd";
          action = "systemctl restart etcd.service";
        };
      };

    })

  ];

  meta.buildDocsInSandbox = false;
}
