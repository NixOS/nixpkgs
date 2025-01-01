{ config, pkgs, nodes, ... }:
let
  domain = config.networking.domain;

  # Note that wildcard certificates just under the TLD (eg. *.com)
  # would be rejected by clients like curl.
  tls-cert = pkgs.runCommand "selfSignedCerts" { buildInputs = [ pkgs.openssl ]; } ''
    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -days 36500 \
      -subj '/CN=${domain}' -extensions v3_req \
      -addext 'subjectAltName = DNS:*.${domain}'
    install -D -t $out key.pem cert.pem
  '';
in
{
  # buildsrht needs space
  virtualisation.diskSize = 4 * 1024;
  virtualisation.memorySize = 2 * 1024;
  networking.enableIPv6 = false;

  services.sourcehut = {
    enable = true;
    nginx.enable = true;
    nginx.virtualHost = {
      forceSSL = true;
      sslCertificate = "${tls-cert}/cert.pem";
      sslCertificateKey = "${tls-cert}/key.pem";
    };
    postgresql.enable = true;
    redis.enable = true;

    meta.enable = true;

    settings."sr.ht" = {
      environment = "production";
      global-domain = config.networking.domain;
      service-key = pkgs.writeText "service-key" "8b327279b77e32a3620e2fc9aabce491cc46e7d821fd6713b2a2e650ce114d01";
      network-key = pkgs.writeText "network-key" "cEEmc30BRBGkgQZcHFksiG7hjc6_dK1XR2Oo5Jb9_nQ=";
    };
    settings.webhooks.private-key = pkgs.writeText "webhook-key" "Ra3IjxgFiwG9jxgp4WALQIZw/BMYt30xWiOsqD0J7EA=";
    settings.mail = {
      smtp-from = "root+hut@${domain}";
      # WARNING: take care to keep pgp-privkey outside the Nix store in production,
      # or use LoadCredentialEncrypted=
      pgp-privkey = toString (pkgs.writeText "sourcehut.pgp-privkey" ''
        -----BEGIN PGP PRIVATE KEY BLOCK-----

        lFgEZrFBKRYJKwYBBAHaRw8BAQdAS1Ffiytk0h0z0jfaT3qyiDUV/plVIUwOg1Yr
        AXP2YmsAAP0W6QMC3G2G41rzCGLeSHeGibor1+XuxvcwUpVdW7ge+BH/tDZuaXhv
        cy90ZXN0cy9zb3VyY2VodXQgPHJvb3QraHV0QHNvdXJjZWh1dC5sb2NhbGRvbWFp
        bj6IkwQTFgoAOxYhBMISh2Z08FCi969cq9R2wSP9QF2bBQJmsUEpAhsDBQsJCAcC
        AiICBhUKCQgLAgQWAgMBAh4HAheAAAoJENR2wSP9QF2b4JMA+wQLdxVcod/ppyvH
        QguGqqhkpk8KquCddOuFnQVAfHFWAQCK5putVk4mGzsoLTbOJCSGRC4pjEktZawQ
        MTqJmnOuC5xdBGaxQSkSCisGAQQBl1UBBQEBB0Aed6UYJyighTY+KuPNQ439st3x
        x04T1j58sx3AnKgYewMBCAcAAP9WLB79HO1zFRqTCnk7GIEWWogMFKVpazeBUNu9
        h9rzCA2+iHgEGBYKACAWIQTCEodmdPBQovevXKvUdsEj/UBdmwUCZrFBKQIbDAAK
        CRDUdsEj/UBdmwgJAQDVk/px/pSzqreSeDLzxlb6dOo+N1KcicsJ0akhSJUcvwD9
        EPhpEDZu/UBKchAutOhWwz+y6pyoF4Vt7XG+jbJQtA4=
        =KaQc
        -----END PGP PRIVATE KEY BLOCK-----
      '');
      pgp-pubkey = pkgs.writeText "sourcehut.pgp-pubkey" ''
        -----BEGIN PGP PUBLIC KEY BLOCK-----

        mDMEZrFBKRYJKwYBBAHaRw8BAQdAS1Ffiytk0h0z0jfaT3qyiDUV/plVIUwOg1Yr
        AXP2Ymu0Nm5peG9zL3Rlc3RzL3NvdXJjZWh1dCA8cm9vdCtodXRAc291cmNlaHV0
        LmxvY2FsZG9tYWluPoiTBBMWCgA7FiEEwhKHZnTwUKL3r1yr1HbBI/1AXZsFAmax
        QSkCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQ1HbBI/1AXZvgkwD7
        BAt3FVyh3+mnK8dCC4aqqGSmTwqq4J1064WdBUB8cVYBAIrmm61WTiYbOygtNs4k
        JIZELimMSS1lrBAxOomac64LuDgEZrFBKRIKKwYBBAGXVQEFAQEHQB53pRgnKKCF
        Nj4q481Djf2y3fHHThPWPnyzHcCcqBh7AwEIB4h4BBgWCgAgFiEEwhKHZnTwUKL3
        r1yr1HbBI/1AXZsFAmaxQSkCGwwACgkQ1HbBI/1AXZsICQEA1ZP6cf6Us6q3kngy
        88ZW+nTqPjdSnInLCdGpIUiVHL8A/RD4aRA2bv1ASnIQLrToVsM/suqcqBeFbe1x
        vo2yULQO
        =luxZ
        -----END PGP PUBLIC KEY BLOCK-----
      '';
      pgp-key-id = "0xC212876674F050A2F7AF5CABD476C123FD405D9B";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.pki.certificateFiles = [ "${tls-cert}/cert.pem" ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
  };

  services.postgresql = {
    enable = true;
    enableTCPIP = false;
    settings.unix_socket_permissions = "0770";
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  environment.systemPackages = with pkgs; [
    hut # For interacting with the Sourcehut APIs via CLI
    srht-gen-oauth-tok # To automatically generate user OAuth tokens
  ];
}
