{
  pkgs ? import <nixpkgs> {},
  servers ? {test = "1.2.3.4";},
  internalDomain ? "cluster.local",
  externalDomain ? "nixos.xyz"
}:
let
  mkAltNames = ipFrom: dnsFrom:
    pkgs.lib.concatImapStringsSep "\n" (i: v: "IP.${toString (i+ipFrom)} = ${v.ip}\nDNS.${toString (i+dnsFrom)} = ${v.name}.${externalDomain}") (pkgs.lib.mapAttrsToList (n: v: {name = n; ip = v;}) servers);

  runWithOpenSSL = file: cmd: pkgs.runCommand file {
    buildInputs = [ pkgs.openssl ];
    passthru = { inherit file; };
  } cmd;

  ca_key = runWithOpenSSL "ca-key.pem" "openssl genrsa -out $out 2048";
  ca_pem = runWithOpenSSL "ca.pem" ''
    openssl req \
      -x509 -new -nodes -key ${ca_key} \
      -days 10000 -out $out -subj "/CN=etcd-ca"
  '';

  etcd_cnf = pkgs.writeText "openssl.cnf" ''
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = digitalSignature, keyEncipherment
    extendedKeyUsage = serverAuth
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = etcd.kubernetes.${externalDomain}
    IP.1 = 127.0.0.1
  '';
  etcd_key = runWithOpenSSL "etcd-key.pem" "openssl genrsa -out $out 2048";
  etcd_csr = runWithOpenSSL "etcd.csr" ''
    openssl req \
      -new -key ${etcd_key} \
      -out $out -subj "/CN=etcd" \
      -config ${etcd_cnf}
  '';
  etcd_cert = runWithOpenSSL "etcd.pem" ''
    openssl x509 \
      -req -in ${etcd_csr} \
      -CA ${ca_pem} -CAkey ${ca_key} \
      -CAcreateserial -out $out \
      -days 3650 -extensions v3_req \
      -extfile ${etcd_cnf}
  '';

  etcd_client_key = runWithOpenSSL "etcd-client-key.pem"
    "openssl genrsa -out $out 2048";

  etcd_client_csr = runWithOpenSSL "etcd-client.csr" ''
    openssl req \
      -new -key ${etcd_client_key} \
      -out $out -subj "/CN=etcd-client" \
      -config ${client_openssl_cnf}
  '';

  etcd_client_cert = runWithOpenSSL "etcd-client.crt" ''
    openssl x509 \
      -req -in ${etcd_client_csr} \
      -CA ${ca_pem} -CAkey ${ca_key} -CAcreateserial \
      -out $out -days 3650 -extensions v3_req \
      -extfile ${client_openssl_cnf}
  '';

  admin_key = runWithOpenSSL "admin-key.pem"
    "openssl genrsa -out $out 2048";

  admin_csr = runWithOpenSSL "admin.csr" ''
    openssl req \
      -new -key ${admin_key} \
      -out $out -subj "/CN=admin/O=system:masters" \
      -config ${client_openssl_cnf}
  '';

  admin_cert = runWithOpenSSL "admin.crt" ''
    openssl x509 \
      -req -in ${admin_csr} \
      -CA ${ca_pem} -CAkey ${ca_key} -CAcreateserial \
      -out $out -days 3650 -extensions v3_req \
      -extfile ${client_openssl_cnf}
  '';

  apiserver_key = runWithOpenSSL "apiserver-key.pem" "openssl genrsa -out $out 2048";

  apiserver_csr = runWithOpenSSL "apiserver.csr" ''
    openssl req \
      -new -key ${apiserver_key} \
      -out $out -subj "/CN=kube-apiserver" \
      -config ${apiserver_cnf}
  '';

  apiserver_cert = runWithOpenSSL "apiserver.pem" ''
    openssl x509 \
      -req -in ${apiserver_csr} \
      -CA ${ca_pem} -CAkey ${ca_key} -CAcreateserial \
      -out $out -days 3650 -extensions v3_req \
      -extfile ${apiserver_cnf}
  '';

  worker_key = runWithOpenSSL "worker-key.pem" "openssl genrsa -out $out 2048";

  worker_csr = runWithOpenSSL "worker.csr" ''
    openssl req \
      -new -key ${worker_key} \
      -out $out -subj "/CN=kube-worker/O=system:authenticated" \
      -config ${worker_cnf}
  '';

  worker_cert = runWithOpenSSL "worker.pem" ''
    openssl x509 \
      -req -in ${worker_csr} \
      -CA ${ca_pem} -CAkey ${ca_key} -CAcreateserial \
      -out $out -days 3650 -extensions v3_req \
      -extfile ${worker_cnf}
  '';

  openssl_cnf = pkgs.writeText "openssl.cnf" ''
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = digitalSignature, keyEncipherment
    extendedKeyUsage = serverAuth
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = *.cluster.${externalDomain}
    IP.1 = 127.0.0.1
    ${mkAltNames 1 1}
  '';

  client_openssl_cnf = pkgs.writeText "client-openssl.cnf" ''
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = digitalSignature, keyEncipherment
    extendedKeyUsage = clientAuth
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = kubernetes
    DNS.2 = kubernetes.default
    DNS.3 = kubernetes.default.svc
    DNS.4 = kubernetes.default.svc.${internalDomain}
    DNS.5 = kubernetes.${externalDomain}
    DNS.6 = *.cluster.${externalDomain}
    IP.1 = 10.1.10.1
    ${mkAltNames 1 6}
  '';

  apiserver_cnf = pkgs.writeText "apiserver-openssl.cnf" ''
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    extendedKeyUsage = serverAuth
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = kubernetes
    DNS.2 = kubernetes.default
    DNS.3 = kubernetes.default.svc
    DNS.4 = kubernetes.default.svc.${internalDomain}
    DNS.5 = kubernetes.${externalDomain}
    DNS.6 = *.cluster.${externalDomain}
    IP.1 = 10.1.10.1
    ${mkAltNames 1 6}
  '';

  worker_cnf = pkgs.writeText "worker-openssl.cnf" ''
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = *.cluster.${externalDomain}
    IP.1 = 10.1.10.1
    ${mkAltNames 1 1}
  '';

  ln = cert: target: ''
    cp -v ${cert} ${target}/${cert.file}
  '';
in
  pkgs.stdenv.mkDerivation rec {
    name = "kubernetes-certs";
    unpackPhase = "true";
    installPhase = ''
      set -xe
      mkdir -p $out
      ${ln ca_key "$out"}
      ${ln ca_pem "$out"}

      ${ln etcd_key "$out"}
      ${ln etcd_csr "$out"}
      ${ln etcd_cert "$out"}

      ${ln etcd_client_key "$out"}
      ${ln etcd_client_csr "$out"}
      ${ln etcd_client_cert "$out"}

      ${ln apiserver_key "$out"}
      ${ln apiserver_csr "$out"}
      ${ln apiserver_cert "$out"}

      ${ln worker_key "$out"}
      ${ln worker_csr "$out"}
      ${ln worker_cert "$out"}

      ${ln admin_key "$out"}
      ${ln admin_csr "$out"}
      ${ln admin_cert "$out"}
    '';
  }
