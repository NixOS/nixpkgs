{ hostPkgs, lib, ... }:

# Tests basics such as TLS, creating a mime-type & serving Unicode characters.

let
  domain = {
    HTTP = "h2o.local";
    TLS = "acme.test";
  };

  sawatdi_chao_lok = "สวัสดีชาวโลก";

  hello_world_txt = hostPkgs.writeTextFile {
    name = "/hello_world.txt";
    text = sawatdi_chao_lok;
  };

  hello_world_rst = hostPkgs.writeTextFile {
    name = "/hello_world.rst";
    text = # rst
      ''
        ====================
        Thaiger Sprint 2025‼
        ====================

        ${sawatdi_chao_lok}
      '';
  };
in
{
  name = "h2o-basic";

  meta = {
    maintainers = with lib.maintainers; [ toastal ];
  };

  nodes = {
    server =
      { pkgs, config, ... }:
      {
        environment.systemPackages = [
          pkgs.curl
        ];

        services.h2o = {
          enable = true;
          defaultHTTPListenPort = 8080;
          defaultTLSListenPort = 8443;
          hosts = {
            "${domain.HTTP}" = {
              settings = {
                paths = {
                  "/hello_world.txt" = {
                    "file.file" = "${hello_world_txt}";
                  };
                };
              };
            };
            "${domain.TLS}" = {
              tls = {
                policy = "force";
                quic = {
                  retry = "ON";
                };
                identity = [
                  {
                    key-file = ../../common/acme/server/acme.test.key.pem;
                    certificate-file = ../../common/acme/server/acme.test.cert.pem;
                  }
                ];
                extraSettings = {
                  minimum-version = "TLSv1.3";
                  # when using common ACME certs, disable talking to CA
                  ocsp-update-interval = 0;
                };
              };
              settings = {
                paths = {
                  "/hello_world.rst" = {
                    "file.file" = "${hello_world_rst}";
                  };
                };
              };
            };
          };
          settings = {
            compress = "ON";
            compress-minimum-size = 32;
            "file.mime.addtypes" = {
              "text/x-rst" = {
                extensions = [ ".rst" ];
                is_compressible = "YES";
              };
            };
            ssl-offload = "kernel";
          };
        };

        security.pki.certificates = [
          (builtins.readFile ../../common/acme/server/ca.cert.pem)
        ];

        networking = {
          firewall = {
            allowedTCPPorts = with config.services.h2o; [
              defaultHTTPListenPort
              defaultTLSListenPort
            ];
            allowedUDPPorts = with config.services.h2o; [
              defaultTLSListenPort
            ];
          };
          extraHosts = ''
            127.0.0.1 ${domain.HTTP}
            127.0.0.1 ${domain.TLS}
          '';
        };
      };
  };
  testScript =
    { nodes, ... }:
    let
      inherit (nodes) server;
      portStrHTTP = builtins.toString server.services.h2o.defaultHTTPListenPort;
      portStrTLS = builtins.toString server.services.h2o.defaultTLSListenPort;
    in
    # python
    ''
      server.wait_for_unit("h2o.service")
      server.wait_for_open_port(${portStrHTTP})
      server.wait_for_open_port(${portStrTLS})

      assert "${sawatdi_chao_lok}" in server.succeed("curl --fail-with-body 'http://${domain.HTTP}:${portStrHTTP}/hello_world.txt'")

      tls_hello_world_head = server.succeed("curl -v --head --compressed --http2 --tlsv1.3 --fail-with-body 'https://${domain.TLS}:${portStrTLS}/hello_world.rst'").lower()
      assert "http/2 200" in tls_hello_world_head
      assert "server: h2o" in tls_hello_world_head
      assert "content-type: text/x-rst" in tls_hello_world_head

      assert "${sawatdi_chao_lok}" in server.succeed("curl -v --http2 --tlsv1.3 --compressed --fail-with-body 'https://${domain.TLS}:${portStrTLS}/hello_world.rst'")

      quic_hello_world_head = server.succeed("curl -v --head --compressed --http3-only --fail-with-body 'https://${domain.TLS}:${portStrTLS}/hello_world.rst'").lower()
      assert "http/3 200" in quic_hello_world_head
      assert "server: h2o" in quic_hello_world_head
      assert "content-type: text/x-rst" in quic_hello_world_head

      assert "${sawatdi_chao_lok}" in server.succeed("curl -v --http3-only --compressed --fail-with-body 'https://${domain.TLS}:${portStrTLS}/hello_world.rst'")

      assert "redirected" in server.succeed("curl -v --head --fail-with-body 'http://${domain.TLS}:${portStrHTTP}/hello_world.rst'").lower()

      server.fail("curl --location --max-redirs 0 'http://${domain.TLS}:${portStrHTTP}/hello_world.rst'")

      assert "${sawatdi_chao_lok}" in server.succeed("curl -v --location --fail-with-body 'http://${domain.TLS}:${portStrHTTP}/hello_world.rst'")
    '';
}
