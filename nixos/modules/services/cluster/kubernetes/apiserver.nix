  { config, lib, options, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  otop = options.services.kubernetes;
  cfg = top.apiserver;

  isRBACEnabled = elem "RBAC" cfg.settings.authorization-mode;

  apiserverServiceIP = (concatStringsSep "." (
    take 3 (splitString "." cfg.settings.service-cluster-ip-range
  )) + ".1");

  # TODO: Remove in NixOS 24.05
  removedOptions = {
    "authorizationPolicy" = "Generate a policy file and set 'settings.authorization-policy-file' to its path";
    "basicAuthFile" = "Support for basic auth was removed in Kubernetes v1.19";
    "extraOpts" = "Use freeform settings";
  };

  # TODO: Remove in NixOS 24.05
  optName = n: builtins.filter (f: f != []) (builtins.split "\\." n);

  # TODO: Remove in NixOS 24.05
  renamedOptions = {
    "apiAudiences" = "api-audiences";
    "allowPrivileged" = "allow-privileged";
    "authorizationMode" = "authorization-mode";
    "advertiseAddress" = "advertise-address";
    "bindAddress" = "bind-address";
    "clientCaFile" = "client-ca-file";
    "disableAdmissionPlugins" = "disable-admission-plugins";
    "enableAdmissionPlugins" = "enable-admission-plugins";
    "etcd.caFile" = "etcd-cafile";
    "etcd.certFile" = "etcd-certfile";
    "etcd.keyFile" = "etcd-keyfile";
    "etcd.servers" = "etcd-servers";
    "featureGates" = "feature-gates";
    "kubeletClientCaFile" = "kubelet-certificate-authority";
    "kubeletClientCertFile" = "kubelet-client-certificate";
    "kubeletClientKeyFile" = "kubelet-client-key";
    "preferredAddressTypes" = "kubelet-preferred-address-types";
    "proxyClientCertFile" = "proxy-client-cert-file";
    "proxyClientKeyFile" = "proxy-client-key-file";
    "runtimeConfig" = "runtime-config";
    "storageBackend" = "storage-backend";
    "securePort" = "secure-port";
    "serviceAccountIssuer" = "service-account-issuer";
    "serviceAccountSigningKeyFile" = "service-account-signing-key-file";
    "serviceAccountKeyFile" = "service-account-key-file";
    "serviceClusterIpRange" = "service-cluster-ip-range";
    "tlsCertFile" = "tls-cert-file";
    "tlsKeyFile" = "tls-private-key-file";
    "tokenAuthFile" = "token-auth-file";
    "verbosity" = "v";
    "webhookConfig" = "authentication-token-webhook-config-file";
  };
in
{
  # TODO: Remove in NixOS 24.05
  imports =
    let
      base = ["services" "kubernetes" "apiserver"];
    in
      [
        (mkRenamedOptionModule (base ++ ["extraSANs"]) ["services" "kubernetes" "pki" "apiServerExtraSANs"])
      ] ++
      (mapAttrsToList (n: v: mkRemovedOptionModule (base ++ [n]) v) removedOptions) ++
      (mapAttrsToList (n: v: mkRenamedOptionModule (base ++ (optName n)) (base ++ ["settings" v])) renamedOptions);

  ###### interface
  options.services.kubernetes.apiserver = with types; {
    enable = mkEnableOption (mdDoc "Kubernetes apiserver");

    settings = mkOption {
      description = ''
        Configuration for kube-apiserver, see:
          <https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver>.
        All attrs defined here translates directly to flags of syntax `--<name>="<value>"`
        which is provided as command line argument to the kube-apiserver binary.
      '';
      type = types.submodule {
        freeformType = attrsOf (oneOf [
          bool
          float
          int
          (listOf str)
          package
          path
          str
        ]);
      };
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
              ${concatStringsSep " \\\n" (mapAttrsToList (n: v: ''--${n}="${top.lib.renderArg v}"'') cfg.settings)}
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
                    cfg.settings.advertise-address
                    top.masterAddress
                    apiserverServiceIP
                    "127.0.0.1"
                  ] ++ top.pki.apiServerExtraSANs;
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
                    cfg.settings.advertise-address
                  ];
          privateKeyOwner = "etcd";
          action = "systemctl restart etcd.service";
        };
      };

    })

  ];

  meta.buildDocsInSandbox = false;
}
