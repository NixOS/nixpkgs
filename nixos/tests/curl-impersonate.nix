/*
  Test suite for curl-impersonate

  Abstract:
    Uses the test suite from the curl-impersonate source repo which:

    1. Performs requests with libcurl and captures the TLS client-hello
       packets with tcpdump to compare against known-good signatures
    2. Spins up an nghttpd2 server to test client HTTP/2 headers against
       known-good headers

    See https://github.com/lwthiker/curl-impersonate/tree/main/tests/signatures
    for details.

  Notes:
    - We need to have our own web server running because the tests expect to be able
      to hit domains like wikipedia.org and the sandbox has no internet
    - We need to be able to do (verifying) TLS handshakes without internet access.
      We do that by creating a trusted CA and issuing a cert that includes
      all of the test domains as subject-alternative names and then spoofs the
      hostnames in /etc/hosts.
    - We started skipping the test_http2_headers test due to log format differences
      between the nghttpd2 version in nixpkgs and the outdated one curl-impersonate
      uses upstream for its tests.
*/

{ pkgs, lib, ... }:
let
  # Update with domains in TestImpersonate.TEST_URLS if needed from:
  # https://github.com/lwthiker/curl-impersonate/blob/main/tests/test_impersonate.py
  domains = [
    "www.wikimedia.org"
    "www.wikipedia.org"
    "www.mozilla.org"
    "www.apache.org"
    "www.kernel.org"
    "git-scm.com"
  ];

  tls-certs =
    let
      # Configure CA with X.509 v3 extensions that would be trusted by curl
      ca-cert-conf = pkgs.writeText "curl-impersonate-ca.cnf" ''
        basicConstraints = critical, CA:TRUE
        subjectKeyIdentifier = hash
        authorityKeyIdentifier = keyid:always, issuer:always
        keyUsage = critical, cRLSign, digitalSignature, keyCertSign
      '';

      # Configure leaf certificate with X.509 v3 extensions that would be trusted
      # by curl and set subject-alternative names for test domains
      tls-cert-conf = pkgs.writeText "curl-impersonate-tls.cnf" ''
        basicConstraints = critical, CA:FALSE
        subjectKeyIdentifier = hash
        authorityKeyIdentifier = keyid:always, issuer:always
        keyUsage = critical, nonRepudiation, digitalSignature, keyEncipherment, keyAgreement
        extendedKeyUsage = critical, serverAuth
        subjectAltName = @alt_names

        [alt_names]
        ${lib.concatStringsSep "\n" (lib.imap0 (idx: domain: "DNS.${toString idx} = ${domain}") domains)}
      '';
    in
    pkgs.runCommand "curl-impersonate-test-certs"
      {
        nativeBuildInputs = [ pkgs.openssl ];
      }
      ''
        # create CA certificate and key
        openssl req -newkey rsa:4096 -keyout ca-key.pem -out ca-csr.pem -nodes -subj '/CN=curl-impersonate-ca.nixos.test'
        openssl x509 -req -sha512 -in ca-csr.pem -key ca-key.pem -out ca.pem -extfile ${ca-cert-conf} -days 36500
        openssl x509 -in ca.pem -text

        # create server certificate and key
        openssl req -newkey rsa:4096 -keyout key.pem -out csr.pem -nodes -subj '/CN=curl-impersonate.nixos.test'
        openssl x509 -req -sha512 -in csr.pem -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile ${tls-cert-conf} -days 36500
        openssl x509 -in cert.pem -text

        # output CA cert and server cert and key
        mkdir -p $out
        cp key.pem cert.pem ca.pem $out
      '';

  # Test script
  curl-impersonate-test =
    let
      # Build miniature libcurl client used by test driver
      minicurl =
        pkgs.runCommandCC "minicurl"
          {
            buildInputs = [ pkgs.curl ];
          }
          ''
            mkdir -p $out/bin
            $CC -Wall -Werror -o $out/bin/minicurl ${pkgs.curl-impersonate.src}/tests/minicurl.c `curl-config --libs`
          '';
    in
    pkgs.writeShellScript "curl-impersonate-test" ''
      set -euxo pipefail

      # Test driver requirements
      export PATH="${
        with pkgs;
        lib.makeBinPath [
          bash
          coreutils
          python3Packages.pytest
          nghttp2
          tcpdump
        ]
      }"
      export PYTHONPATH="${
        with pkgs.python3Packages;
        makePythonPath [
          pyyaml
          pytest-asyncio
          dpkt
          ts1-signatures
        ]
      }"

      # Prepare test root prefix
      mkdir -p usr/{bin,lib}
      cp -rs ${pkgs.curl-impersonate}/* ${minicurl}/* usr/

      cp -r ${pkgs.curl-impersonate.src}/tests ./

      # Run tests
      cd tests
      pytest . --install-dir ../usr --capture-interface eth1 --exitfirst -k 'not test_http2_headers'
    '';
in
{
  name = "curl-impersonate";

  meta = with lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    web =
      {
        nodes,
        pkgs,
        lib,
        config,
        ...
      }:
      {
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        services = {
          nginx = {
            enable = true;
            virtualHosts."curl-impersonate.nixos.test" = {
              default = true;
              addSSL = true;
              sslCertificate = "${tls-certs}/cert.pem";
              sslCertificateKey = "${tls-certs}/key.pem";
            };
          };
        };
      };

    curl =
      {
        nodes,
        pkgs,
        lib,
        config,
        ...
      }:
      {
        networking.extraHosts = lib.concatStringsSep "\n" (
          map (domain: "${nodes.web.networking.primaryIPAddress}  ${domain}") domains
        );

        security.pki.certificateFiles = [ "${tls-certs}/ca.pem" ];
      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      with subtest("Wait for network"):
          web.systemctl("start network-online.target")
          curl.systemctl("start network-online.target")
          web.wait_for_unit("network-online.target")
          curl.wait_for_unit("network-online.target")

      with subtest("Wait for web server"):
          web.wait_for_unit("nginx.service")
          web.wait_for_open_port(443)

      with subtest("Run curl-impersonate tests"):
          curl.succeed("${curl-impersonate-test}")
    '';
}
