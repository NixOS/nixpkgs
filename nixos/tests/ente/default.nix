{ lib, pkgs, ... }:
let
  garageAccessKey = "GKaaaaaaaaaaaaaaaaaaaaaaaa";
  garageSecretKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

  certs = import ./snakeoil-certs.nix;
  domain = certs.domain;
in
{
  name = "ente";
  meta.maintainers = [ lib.maintainers.oddlama ];

  nodes.garage =
    { ... }:
    {
      services.garage = {
        enable = true;
        package = pkgs.garage_2;
        settings = {
          replication_factor = 1;
          consistency_mode = "consistent";
          rpc_bind_addr = "[::]:3901";
          rpc_public_addr = "[::1]:3901";
          rpc_secret = "5c1915fa04d0b6739675c61bf5907eb0fe3d9c69850c83820f51b4d25d13868c";
          s3_api = {
            s3_region = "us-east-1";
            api_bind_addr = "[::]:3900";
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 3900 ];

      # Garage requires at least 1GiB of free disk space to run.
      virtualisation.diskSize = 2 * 1024;
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
              locations."/".proxyPass = "http://${nodes.garage.networking.primaryIPAddress}:3900";
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
                key._secret = pkgs.writeText "accesskey" garageAccessKey;
                secret._secret = pkgs.writeText "secretkey" garageSecretKey;
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
    garage.start()
    garage.wait_for_unit("garage.service")
    garage.wait_for_open_port(3900)

    # Configure the cluster layout
    garage_node_id = garage.succeed("garage status | tail -n1 | awk '{ print $1 }'")
    garage.succeed(f"garage layout assign -c 1G -z garage {garage_node_id}")
    garage.succeed("garage layout apply --version 1")

    # Import the predefined API key and create the bucket
    garage.succeed("garage key import ${garageAccessKey} ${garageSecretKey} --yes")
    garage.succeed("garage bucket create ente")
    garage.succeed("garage bucket allow --read --write ente --key ${garageAccessKey}")

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
