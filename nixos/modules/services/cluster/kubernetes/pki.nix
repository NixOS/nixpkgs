{ config, lib, pkgs, ... }:

with lib;

let
  top = config.services.kubernetes;
  cfg = top.pki;

  csrCA = pkgs.writeText "kube-pki-cacert-csr.json" (builtins.toJSON {
    key = {
        algo = "rsa";
        size = 2048;
    };
    names = singleton cfg.caSpec;
  });

  csrCfssl = pkgs.writeText "kube-pki-cfssl-csr.json" (builtins.toJSON {
    key = {
        algo = "rsa";
        size = 2048;
    };
    CN = top.masterAddress;
  });

  cfsslAPITokenBaseName = "apitoken.secret";
  cfsslAPITokenPath = "${config.services.cfssl.dataDir}/${cfsslAPITokenBaseName}";
  certmgrAPITokenPath = "${top.secretsPath}/${cfsslAPITokenBaseName}";
  cfsslAPITokenLength = 32;

  clusterAdminKubeconfig = with cfg.certs.clusterAdmin; {
    server = top.apiserverAddress;
    certFile = cert;
    keyFile = key;
  };

  remote = with config.services; "https://${kubernetes.masterAddress}:${toString cfssl.port}";
in
{
  ###### interface
  options.services.kubernetes.pki = with lib.types; {

    enable = mkEnableOption "easyCert issuer service";

    certs = mkOption {
      description = "List of certificate specs to feed to cert generator.";
      default = {};
      type = attrs;
    };

    genCfsslCACert = mkOption {
      description = ''
        Whether to automatically generate cfssl CA certificate and key,
        if they don't exist.
      '';
      default = true;
      type = bool;
    };

    genCfsslAPICerts = mkOption {
      description = ''
        Whether to automatically generate cfssl API webserver TLS cert and key,
        if they don't exist.
      '';
      default = true;
      type = bool;
    };

    genCfsslAPIToken = mkOption {
      description = ''
        Whether to automatically generate cfssl API-token secret,
        if they doesn't exist.
      '';
      default = true;
      type = bool;
    };

    pkiTrustOnBootstrap = mkOption {
      description = "Whether to always trust remote cfssl server upon initial PKI bootstrap.";
      default = true;
      type = bool;
    };

    caCertPathPrefix = mkOption {
      description = ''
        Path-prefrix for the CA-certificate to be used for cfssl signing.
        Suffixes ".pem" and "-key.pem" will be automatically appended for
        the public and private keys respectively.
      '';
      default = "${config.services.cfssl.dataDir}/ca";
      type = str;
    };

    caSpec = mkOption {
      description = "Certificate specification for the auto-generated CAcert.";
      default = {
        CN = "kubernetes-cluster-ca";
        O = "NixOS";
        OU = "services.kubernetes.pki.caSpec";
        L = "auto-generated";
      };
      type = attrs;
    };

    etcClusterAdminKubeconfig = mkOption {
      description = ''
        Symlink a kubeconfig with cluster-admin privileges to environment path
        (/etc/&lt;path&gt;).
      '';
      default = null;
      type = nullOr str;
    };

  };

  ###### implementation
  config = mkIf cfg.enable
  (let
    cfsslCertPathPrefix = "${config.services.cfssl.dataDir}/cfssl";
    cfsslCert = "${cfsslCertPathPrefix}.pem";
    cfsslKey = "${cfsslCertPathPrefix}-key.pem";
    cfsslPort = toString config.services.cfssl.port;

    certmgrPaths = [
      top.caFile
      certmgrAPITokenPath
    ];
  in
  {

    services.cfssl = mkIf (top.apiserver.enable) {
      enable = true;
      address = "0.0.0.0";
      tlsCert = cfsslCert;
      tlsKey = cfsslKey;
      configFile = toString (pkgs.writeText "cfssl-config.json" (builtins.toJSON {
        signing = {
          profiles = {
            default = {
              usages = ["digital signature"];
              auth_key = "default";
              expiry = "720h";
            };
          };
        };
        auth_keys = {
          default = {
            type = "standard";
            key = "file:${cfsslAPITokenPath}";
          };
        };
      }));
    };

    systemd.services.cfssl.preStart = with pkgs; with config.services.cfssl; mkIf (top.apiserver.enable)
    (concatStringsSep "\n" [
      "set -e"
      (optionalString cfg.genCfsslCACert ''
        if [ ! -f "${cfg.caCertPathPrefix}.pem" ]; then
          ${cfssl}/bin/cfssl genkey -initca ${csrCA} | \
            ${cfssl}/bin/cfssljson -bare ${cfg.caCertPathPrefix}
        fi
      '')
      (optionalString cfg.genCfsslAPICerts ''
        if [ ! -f "${dataDir}/cfssl.pem" ]; then
          ${cfssl}/bin/cfssl gencert -ca "${cfg.caCertPathPrefix}.pem" -ca-key "${cfg.caCertPathPrefix}-key.pem" ${csrCfssl} | \
            ${cfssl}/bin/cfssljson -bare ${cfsslCertPathPrefix}
        fi
      '')
      (optionalString cfg.genCfsslAPIToken ''
        if [ ! -f "${cfsslAPITokenPath}" ]; then
          head -c ${toString (cfsslAPITokenLength / 2)} /dev/urandom | od -An -t x | tr -d ' ' >"${cfsslAPITokenPath}"
        fi
        chown cfssl "${cfsslAPITokenPath}" && chmod 400 "${cfsslAPITokenPath}"
      '')]);

    systemd.targets.cfssl-online = {
      wantedBy = [ "network-online.target" ];
      after = [ "cfssl.service" "network-online.target" "cfssl-online.service" ];
    };

    systemd.services.cfssl-online = {
      description = "Wait for ${remote} to be reachable.";
      wantedBy = [ "cfssl-online.target" ];
      before = [ "cfssl-online.target" ];
      path = [ pkgs.curl ];
      preStart = ''
        until curl --fail-early -fskd '{}' ${remote}/api/v1/cfssl/info -o /dev/null; do
          echo curl ${remote}/api/v1/cfssl/info: exit status $?
          sleep 2
        done
      '';
      script = "echo Ok";
      serviceConfig = {
        TimeoutSec = "300";
      };
    };

    systemd.services.kube-certmgr-bootstrap = {
      description = "Kubernetes certmgr bootstrapper";
      wantedBy = [ "cfssl-online.target" ];
      after = [ "cfssl-online.target" ];
      before = [ "certmgr.service" ];
      path = with pkgs; [ curl cfssl ];
      script = concatStringsSep "\n" [''
        set -e

        mkdir -p $(dirname ${certmgrAPITokenPath})
        mkdir -p $(dirname ${top.caFile})

        # If there's a cfssl (cert issuer) running locally, then don't rely on user to
        # manually paste it in place. Just symlink.
        # otherwise, create the target file, ready for users to insert the token

        if [ -f "${cfsslAPITokenPath}" ]; then
          ln -fs "${cfsslAPITokenPath}" "${certmgrAPITokenPath}"
        else
          touch "${certmgrAPITokenPath}" && chmod 600 "${certmgrAPITokenPath}"
        fi
      ''
      (optionalString (cfg.pkiTrustOnBootstrap) ''
        if [ ! -s "${top.caFile}" ]; then
          until test -s ${top.caFile}.json; do
            sleep 2
            curl --fail-early -fskd '{}' ${remote}/api/v1/cfssl/info -o ${top.caFile}.json
          done
          cfssljson -f ${top.caFile}.json -stdout >${top.caFile}
          rm ${top.caFile}.json
        fi
      '')
      ];
      serviceConfig = {
        TimeoutSec = "500";
      };
    };

    services.certmgr = {
      enable = true;
      package = pkgs.certmgr-selfsigned;
      svcManager = "command";
      specs =
        let
          mkSpec = _: cert: {
            inherit (cert) action;
            authority = {
              inherit remote;
              file.path = cert.caCert;
              root_ca = cert.caCert;
              profile = "default";
              auth_key_file = certmgrAPITokenPath;
            };
            certificate = {
              path = cert.cert;
            };
            private_key = cert.privateKeyOptions;
            request = {
              inherit (cert) CN hosts;
              key = {
                algo = "rsa";
                size = 2048;
              };
              names = [ cert.fields ];
            };
          };
        in
          mapAttrs mkSpec cfg.certs;
      };

      systemd.services.certmgr = {
        wantedBy = [ "cfssl-online.target" ];
        after = [ "cfssl-online.target" "kube-certmgr-bootstrap.service" ];
        preStart = ''
          while ! test -s ${certmgrAPITokenPath} ; do
            sleep 1
            echo Waiting for ${certmgrAPITokenPath}
          done
        '';
        unitConfig.ConditionPathExists = certmgrPaths;
      };

      systemd.paths.certmgr = {
        wantedBy = [ "certmgr.service" ];
        pathConfig = {
          PathExists = certmgrPaths;
          PathChanged = certmgrPaths;
        };
      };

      environment.etc.${cfg.etcClusterAdminKubeconfig}.source = mkIf (!isNull cfg.etcClusterAdminKubeconfig)
        (top.lib.mkKubeConfig "cluster-admin" clusterAdminKubeconfig);

      environment.systemPackages = mkIf (top.kubelet.enable || top.proxy.enable) [
      (pkgs.writeScriptBin "nixos-kubernetes-node-join" ''
        set -e
        exec 1>&2

        if [ $# -gt 0 ]; then
          echo "Usage: $(basename $0)"
          echo ""
          echo "No args. Apitoken must be provided on stdin."
          echo "To get the apitoken, execute: 'sudo cat ${certmgrAPITokenPath}' on the master node."
          exit 1
        fi

        if [ $(id -u) != 0 ]; then
          echo "Run as root please."
          exit 1
        fi

        read -r token
        if [ ''${#token} != ${toString cfsslAPITokenLength} ]; then
          echo "Token must be of length ${toString cfsslAPITokenLength}."
          exit 1
        fi

        do_restart=$(test -s ${certmgrAPITokenPath} && echo -n y || echo -n n)

        echo $token > ${certmgrAPITokenPath}
        chmod 600 ${certmgrAPITokenPath}

        if [ y = $do_restart ]; then
          echo "Restarting certmgr..." >&1
          systemctl restart certmgr
        fi

        echo "Node joined succesfully" >&1
      '')];

      # isolate etcd on loopback at the master node
      # easyCerts doesn't support multimaster clusters anyway atm.
      services.etcd = mkIf top.apiserver.enable (with cfg.certs.etcd; {
        listenClientUrls = ["https://127.0.0.1:2379"];
        listenPeerUrls = ["https://127.0.0.1:2380"];
        advertiseClientUrls = ["https://etcd.local:2379"];
        initialCluster = ["${top.masterAddress}=https://etcd.local:2380"];
        initialAdvertisePeerUrls = ["https://etcd.local:2380"];
        certFile = mkDefault cert;
        keyFile = mkDefault key;
        trustedCaFile = mkDefault caCert;
      });
      networking.extraHosts = mkIf (config.services.etcd.enable) ''
        127.0.0.1 etcd.${top.addons.dns.clusterDomain} etcd.local
      '';

      services.kubernetes = {

        apiserver = mkIf top.apiserver.enable (with cfg.certs.apiServer; {
          etcd = with cfg.certs.apiserverEtcdClient; {
            servers = ["https://etcd.local:2379"];
            certFile = mkDefault cert;
            keyFile = mkDefault key;
            caFile = mkDefault caCert;
          };
          clientCaFile = mkDefault caCert;
          tlsCertFile = mkDefault cert;
          tlsKeyFile = mkDefault key;
          serviceAccountKeyFile = mkDefault cfg.certs.serviceAccount.cert;
          kubeletClientCaFile = mkDefault caCert;
          kubeletClientCertFile = mkDefault cfg.certs.apiserverKubeletClient.cert;
          kubeletClientKeyFile = mkDefault cfg.certs.apiserverKubeletClient.key;
          proxyClientCertFile = mkDefault cfg.certs.apiserverProxyClient.cert;
          proxyClientKeyFile = mkDefault cfg.certs.apiserverProxyClient.key;
        });
        addonManager = mkIf top.addonManager.enable {
          kubeconfig = with cfg.certs.addonManager; {
            certFile = mkDefault cert;
            keyFile = mkDefault key;
          };
          bootstrapAddonsKubeconfig = clusterAdminKubeconfig;
        };
        controllerManager = mkIf top.controllerManager.enable {
          serviceAccountKeyFile = mkDefault cfg.certs.serviceAccount.key;
          rootCaFile = cfg.certs.controllerManagerClient.caCert;
          kubeconfig = with cfg.certs.controllerManagerClient; {
            certFile = mkDefault cert;
            keyFile = mkDefault key;
          };
        };
        flannel = mkIf top.flannel.enable {
          kubeconfig = with cfg.certs.flannelClient; {
            certFile = cert;
            keyFile = key;
          };
        };
        scheduler = mkIf top.scheduler.enable {
          kubeconfig = with cfg.certs.schedulerClient; {
            certFile = mkDefault cert;
            keyFile = mkDefault key;
          };
        };
        kubelet = mkIf top.kubelet.enable {
          clientCaFile = mkDefault cfg.certs.kubelet.caCert;
          tlsCertFile = mkDefault cfg.certs.kubelet.cert;
          tlsKeyFile = mkDefault cfg.certs.kubelet.key;
          kubeconfig = with cfg.certs.kubeletClient; {
            certFile = mkDefault cert;
            keyFile = mkDefault key;
          };
        };
        proxy = mkIf top.proxy.enable {
          kubeconfig = with cfg.certs.kubeProxyClient; {
            certFile = mkDefault cert;
            keyFile = mkDefault key;
          };
        };
      };
    });
}
