{ hostPkgs, lib, ... }:

let
  domain = "acme.test";

  hello_txt =
    name:
    hostPkgs.writeTextFile {
      name = "/hello_${name}.txt";
      text = "Hello, ${name}!";
    };

  mkH2OServer =
    recommendations:
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      services.h2o = {
        enable = true;
        package = pkgs.h2o.override (
          lib.optionalAttrs
            (builtins.elem recommendations [
              "intermediate"
              "old"
            ])
            {
              openssl = pkgs.openssl_legacy;
            }
        );
        defaultTLSRecommendations = "modern"; # prove overridden
        hosts = {
          "${domain}" = {
            tls = {
              inherit recommendations;
              port = 8443;
              policy = "force";
              identity = [
                {
                  key-file = ../../common/acme/server/acme.test.key.pem;
                  certificate-file = ../../common/acme/server/acme.test.cert.pem;
                }
              ];
              extraSettings = {
                # when using common ACME certs, disable talking to CA
                ocsp-update-interval = 0;
              };
            };
            settings = {
              paths."/"."file.file" = "${hello_txt recommendations}";
            };
          };
        };
        settings = {
          ssl-offload = "kernel";
        };
      };

      security.pki.certificates = [
        (builtins.readFile ../../common/acme/server/ca.cert.pem)
      ];

      networking = {
        firewall.allowedTCPPorts = [
          config.services.h2o.hosts.${domain}.tls.port
        ];
        extraHosts = "127.0.0.1 ${domain}";
      };
    };
in
{
  name = "h2o-tls-recommendations";

  meta = {
    maintainers = with lib.maintainers; [ toastal ];
  };

  # not using a `client` since it’s easiest to test with acme.test pointing at
  # localhost for these machines
  nodes = {
    server_modern = mkH2OServer "modern";
    server_intermediate = mkH2OServer "intermediate";
    server_old = mkH2OServer "old";
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes) server_modern server_intermediate server_old;
      modernPortStr = builtins.toString server_modern.services.h2o.hosts.${domain}.tls.port;
      intermediatePortStr = builtins.toString server_intermediate.services.h2o.hosts.${domain}.tls.port;
      oldPortStr = builtins.toString server_old.services.h2o.hosts.${domain}.tls.port;
    in
    # python
    ''
      curl_basic = "curl -v --tlsv1.3 --http2 'https://${domain}:{port}/'"
      curl_head = "curl -v --head 'https://${domain}:{port}/'"
      curl_max_tls1_2 ="curl -v --tlsv1.0 --tls-max 1.2 'https://${domain}:{port}/'"
      curl_max_tls1_2_intermediate_cipher ="curl -v --tlsv1.0 --tls-max 1.2 --ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256' 'https://${domain}:{port}/'"
      curl_max_tls1_2_old_cipher ="curl -v --tlsv1.0 --tls-max 1.2 --ciphers 'ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA256' 'https://${domain}:{port}/'"

      start_all()

      server_modern.wait_for_unit("h2o.service")
      server_modern.wait_for_open_port(${modernPortStr})
      modern_response = server_modern.succeed(curl_basic.format(port="${modernPortStr}"))
      assert "Hello, modern!" in modern_response
      modern_head = server_modern.succeed(curl_head.format(port="${modernPortStr}"))
      assert "strict-transport-security" in modern_head
      server_modern.fail(curl_max_tls1_2.format(port="${modernPortStr}"))

      server_intermediate.wait_for_unit("h2o.service")
      server_intermediate.wait_for_open_port(${intermediatePortStr})
      intermediate_response = server_intermediate.succeed(curl_basic.format(port="${intermediatePortStr}"))
      assert "Hello, intermediate!" in intermediate_response
      intermediate_head = server_modern.succeed(curl_head.format(port="${intermediatePortStr}"))
      assert "strict-transport-security" in intermediate_head
      server_intermediate.succeed(curl_max_tls1_2.format(port="${intermediatePortStr}"))
      server_intermediate.succeed(curl_max_tls1_2_intermediate_cipher.format(port="${intermediatePortStr}"))
      server_intermediate.fail(curl_max_tls1_2_old_cipher.format(port="${intermediatePortStr}"))

      server_old.wait_for_unit("h2o.service")
      server_old.wait_for_open_port(${oldPortStr})
      old_response = server_old.succeed(curl_basic.format(port="${oldPortStr}"))
      assert "Hello, old!" in old_response
      old_head = server_modern.succeed(curl_head.format(port="${oldPortStr}"))
      assert "strict-transport-security" in old_head
      server_old.succeed(curl_max_tls1_2.format(port="${oldPortStr}"))
      server_old.succeed(curl_max_tls1_2_intermediate_cipher.format(port="${oldPortStr}"))
      server_old.succeed(curl_max_tls1_2_old_cipher.format(port="${oldPortStr}"))
    '';
}
