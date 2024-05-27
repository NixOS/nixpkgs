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

        lFgEYqDRORYJKwYBBAHaRw8BAQdAehGoy36FUx2OesYm07be2rtLyvR5Pb/ltstd
        Gk7hYQoAAP9X4oPmxxrHN8LewBpWITdBomNqlHoiP7mI0nz/BOPJHxEktDZuaXhv
        cy90ZXN0cy9zb3VyY2VodXQgPHJvb3QraHV0QHNvdXJjZWh1dC5sb2NhbGRvbWFp
        bj6IlwQTFgoAPxYhBPqjgjnL8RHN4JnADNicgXaYm0jJBQJioNE5AhsDBQkDwmcA
        BgsJCAcDCgUVCgkICwUWAwIBAAIeBQIXgAAKCRDYnIF2mJtIySVCAP9e2nHsVHSi
        2B1YGZpVG7Xf36vxljmMkbroQy+0gBPwRwEAq+jaiQqlbGhQ7R/HMFcAxBIVsq8h
        Aw1rngsUd0o3dAicXQRioNE5EgorBgEEAZdVAQUBAQdAXZV2Sd5ZNBVTBbTGavMv
        D6ORrUh8z7TI/3CsxCE7+yADAQgHAAD/c1RU9xH+V/uI1fE7HIn/zL0LUPpsuce2
        cH++g4u3kBgTOYh+BBgWCgAmFiEE+qOCOcvxEc3gmcAM2JyBdpibSMkFAmKg0TkC
        GwwFCQPCZwAACgkQ2JyBdpibSMlKagD/cTre6p1m8QuJ7kwmCFRSz5tBzIuYMMgN
        xtT7dmS91csA/35fWsOykSiFRojQ7ccCSUTHL7ApF2EbL968tP/D2hIG
        =Hjoc
        -----END PGP PRIVATE KEY BLOCK-----
      '');
      pgp-pubkey = pkgs.writeText "sourcehut.pgp-pubkey" ''
        -----BEGIN PGP PUBLIC KEY BLOCK-----

        mDMEYqDRORYJKwYBBAHaRw8BAQdAehGoy36FUx2OesYm07be2rtLyvR5Pb/ltstd
        Gk7hYQq0Nm5peG9zL3Rlc3RzL3NvdXJjZWh1dCA8cm9vdCtodXRAc291cmNlaHV0
        LmxvY2FsZG9tYWluPoiXBBMWCgA/FiEE+qOCOcvxEc3gmcAM2JyBdpibSMkFAmKg
        0TkCGwMFCQPCZwAGCwkIBwMKBRUKCQgLBRYDAgEAAh4FAheAAAoJENicgXaYm0jJ
        JUIA/17acexUdKLYHVgZmlUbtd/fq/GWOYyRuuhDL7SAE/BHAQCr6NqJCqVsaFDt
        H8cwVwDEEhWyryEDDWueCxR3Sjd0CLg4BGKg0TkSCisGAQQBl1UBBQEBB0BdlXZJ
        3lk0FVMFtMZq8y8Po5GtSHzPtMj/cKzEITv7IAMBCAeIfgQYFgoAJhYhBPqjgjnL
        8RHN4JnADNicgXaYm0jJBQJioNE5AhsMBQkDwmcAAAoJENicgXaYm0jJSmoA/3E6
        3uqdZvELie5MJghUUs+bQcyLmDDIDcbU+3ZkvdXLAP9+X1rDspEohUaI0O3HAklE
        xy+wKRdhGy/evLT/w9oSBg==
        =pJD7
        -----END PGP PUBLIC KEY BLOCK-----
      '';
      pgp-key-id = "0xFAA38239CBF111CDE099C00CD89C8176989B48C9";
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
