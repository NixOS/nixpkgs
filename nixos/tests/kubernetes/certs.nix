{
  pkgs ? import <nixpkgs> {},
  internalDomain ? "cloud.yourdomain.net",
  externalDomain ? "myawesomecluster.cluster.yourdomain.net",
  serviceClusterIp ? "10.0.0.1",
  kubelets
}:
let
  runWithCFSSL = name: cmd:
    builtins.fromJSON (builtins.readFile (
      pkgs.runCommand "${name}-cfss.json" {
        buildInputs = [ pkgs.cfssl ];
      } "cfssl ${cmd} > $out"
    ));

  writeCFSSL = content:
    pkgs.runCommand content.name {
      buildInputs = [ pkgs.cfssl ];
    } ''
      mkdir -p $out
      cd $out
      cat ${writeFile content} | cfssljson -bare ${content.name}
    '';

  noCSR = content: pkgs.lib.filterAttrs (n: v: n != "csr") content;
  noKey = content: pkgs.lib.filterAttrs (n: v: n != "key") content;

  writeFile = content: pkgs.writeText "content" (
    if pkgs.lib.isAttrs content then builtins.toJSON content
    else toString content
  );

  createServingCertKey = { ca, cn, hosts? [], size ? 2048, name ? cn }:
    noCSR (
      (runWithCFSSL name "gencert -ca=${writeFile ca.cert} -ca-key=${writeFile ca.key} -profile=server -config=${writeFile ca.config} ${writeFile {
        CN = cn;
        hosts = hosts;
        key = { algo = "rsa"; inherit size; };
      }}") // { inherit name; }
    );

  createClientCertKey = { ca, cn, groups ? [], size ? 2048, name ? cn }:
    noCSR (
      (runWithCFSSL name "gencert -ca=${writeFile ca.cert} -ca-key=${writeFile ca.key} -profile=client -config=${writeFile ca.config} ${writeFile {
        CN = cn;
        names = map (group: {O = group;}) groups;
        hosts = [""];
        key = { algo = "rsa"; inherit size; };
      }}") // { inherit name; }
    );

  createSigningCertKey = { C ? "xx", ST ? "x", L ? "x", O ? "x", OU ? "x", CN ? "ca", emailAddress ? "x", expiry ? "43800h", size ? 2048, name ? CN }:
    (noCSR (runWithCFSSL CN "genkey -initca ${writeFile {
      key = { algo = "rsa"; inherit size; };
      names = [{ inherit C ST L O OU CN emailAddress; }];
    }}")) // {
      inherit name;
      config.signing = {
        default.expiry = expiry;
        profiles = {
          server = {
            inherit expiry;
            usages = [
              "signing"
              "key encipherment"
              "server auth"
            ];
          };
          client = {
            inherit expiry;
            usages = [
              "signing"
              "key encipherment"
              "client auth"
            ];
          };
          peer = {
            inherit expiry;
            usages = [
              "signing"
              "key encipherment"
              "server auth"
              "client auth"
            ];
          };
        };
      };
    };

  ca = createSigningCertKey {};

  kube-apiserver = createServingCertKey {
    inherit ca;
    cn = "kube-apiserver";
    hosts = ["kubernetes.default" "kubernetes.default.svc" "localhost" "api.${externalDomain}" serviceClusterIp];
  };

  kubelet = createServingCertKey {
    inherit ca;
    cn = "kubelet";
    hosts = ["*.${externalDomain}"];
  };

  service-accounts = createServingCertKey {
    inherit ca;
    cn = "kube-service-accounts";
  };

  etcd = createServingCertKey {
    inherit ca;
    cn = "etcd";
    hosts = ["etcd.${externalDomain}"];
  };

  etcd-client = createClientCertKey {
    inherit ca;
    cn = "etcd-client";
  };

  kubelet-client = createClientCertKey {
    inherit ca;
    cn = "kubelet-client";
    groups = ["system:masters"];
  };

  apiserver-client = {
    kubelet = hostname: createClientCertKey {
      inherit ca;
      name = "apiserver-client-kubelet-${hostname}";
      cn = "system:node:${hostname}.${externalDomain}";
      groups = ["system:nodes"];
    };

    kube-proxy = createClientCertKey {
      inherit ca;
      name = "apiserver-client-kube-proxy";
      cn = "system:kube-proxy";
      groups = ["system:kube-proxy" "system:nodes"];
    };

    kube-controller-manager = createClientCertKey {
      inherit ca;
      name = "apiserver-client-kube-controller-manager";
      cn = "system:kube-controller-manager";
      groups = ["system:masters"];
    };

    kube-scheduler = createClientCertKey {
      inherit ca;
      name = "apiserver-client-kube-scheduler";
      cn = "system:kube-scheduler";
      groups = ["system:kube-scheduler"];
    };

    admin = createClientCertKey {
      inherit ca;
      cn = "admin";
      groups = ["system:masters"];
    };
  };
in {
  master = pkgs.buildEnv {
    name = "master-keys";
    paths = [
      (writeCFSSL (noKey ca))
      (writeCFSSL kube-apiserver)
      (writeCFSSL kubelet-client)
      (writeCFSSL apiserver-client.kube-controller-manager)
      (writeCFSSL apiserver-client.kube-scheduler)
      (writeCFSSL service-accounts)
      (writeCFSSL etcd)
    ];
  };

  worker = pkgs.buildEnv {
    name = "worker-keys";
    paths = [
      (writeCFSSL (noKey ca))
      (writeCFSSL kubelet)
      (writeCFSSL apiserver-client.kube-proxy)
      (writeCFSSL etcd-client)
    ] ++ map (hostname: writeCFSSL (apiserver-client.kubelet hostname)) kubelets;
  };

  admin = writeCFSSL apiserver-client.admin;
}
