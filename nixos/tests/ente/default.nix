{ lib, pkgs, ... }:
let
  accessKey = "BKIKJAA5BMMU2RHO6IBB";
  secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";
  rootCredentialsFile = pkgs.writeText "minio-credentials-full" ''
    MINIO_ROOT_USER=${accessKey}
    MINIO_ROOT_PASSWORD=${secretKey}
  '';

  certs = import ./snakeoil-certs.nix;
  domain = certs.domain;
in
{
  name = "ente";
  meta.maintainers = [ lib.maintainers.oddlama ];

  nodes.minio =
    { ... }:
    {
      environment.systemPackages = [ pkgs.minio-client ];
      services.minio = {
        enable = true;
        inherit rootCredentialsFile;
      };

      networking.firewall.allowedTCPPorts = [
        9000
      ];

      systemd.services.minio.environment = {
        MINIO_SERVER_URL = "https://s3.${domain}";
      };
    };

  nodes.ente =
    {
      config,
      nodes,
      lib,
      ...
    }:
    {
      security.pki.certificateFiles = [ certs.ca.cert ];

      networking.extraHosts = ''
        ${config.networking.primaryIPAddress} accounts.${domain} albums.${domain} api.${domain} cast.${domain} photos.${domain} s3.${domain}
      '';

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      services.nginx = {
        recommendedProxySettings = true;
        virtualHosts =
          lib.genAttrs
            [
              "accounts.${domain}"
              "albums.${domain}"
              "api.${domain}"
              "cast.${domain}"
              "photos.${domain}"
            ]
            (_: {
              sslCertificate = certs.${domain}.cert;
              sslCertificateKey = certs.${domain}.key;
            })
          // {
            "s3.${domain}" = {
              forceSSL = true;
              sslCertificate = certs.${domain}.cert;
              sslCertificateKey = certs.${domain}.key;
              locations."/".proxyPass = "http://${nodes.minio.networking.primaryIPAddress}:9000";
              extraConfig = ''
                client_max_body_size 32M;
                proxy_buffering off;
                proxy_request_buffering off;
              '';
            };
          };
      };

      services.ente = {
        web = {
          enable = true;
          domains = {
            accounts = "accounts.${domain}";
            albums = "albums.${domain}";
            cast = "cast.${domain}";
            photos = "photos.${domain}";
          };
        };
        api = {
          enable = true;
          nginx.enable = true;
          enableLocalDB = true;
          domain = "api.${domain}";
          settings = {
            s3 = {
              use_path_style_urls = true;
              b2-eu-cen = {
                endpoint = "https://s3.${domain}";
                region = "us-east-1";
                bucket = "ente";
                key._secret = pkgs.writeText "accesskey" accessKey;
                secret._secret = pkgs.writeText "secretkey" secretKey;
              };
            };
            key = {
              encryption._secret = pkgs.writeText "encryption" "T0sn+zUVFOApdX4jJL4op6BtqqAfyQLH95fu8ASWfno=";
              hash._secret = pkgs.writeText "hash" "g/dBZBs1zi9SXQ0EKr4RCt1TGr7ZCKkgrpjyjrQEKovWPu5/ce8dYM6YvMIPL23MMZToVuuG+Z6SGxxTbxg5NQ==";
            };
            jwt.secret._secret = pkgs.writeText "jwt" "i2DecQmfGreG6q1vBj5tCokhlN41gcfS2cjOs9Po-u8=";
          };
        };
      };
    };

  testScript = ''
    minio.start()
    minio.wait_for_unit("minio.service")
    minio.wait_for_open_port(9000)

    # Create a test bucket on the server
    minio.succeed("mc alias set minio http://localhost:9000 ${accessKey} ${secretKey} --api s3v4")
    minio.succeed("mc mb -p minio/ente")

    # Start ente
    ente.start()
    ente.wait_for_unit("ente.service")
    ente.wait_for_unit("nginx.service")

    # Wait until api is up
    ente.wait_until_succeeds("journalctl --since -2m --unit ente.service --grep 'We have lift-off.'", timeout=30)
    # Wait until photos app is up
    ente.wait_until_succeeds("curl -Ls https://photos.${domain}/ | grep -q 'Ente Photos'", timeout=30)
  '';
}
