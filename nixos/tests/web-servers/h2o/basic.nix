import ../../make-test-python.nix (
  { lib, pkgs, ... }:

  # Tests basics such as TLS, creating a mime-type & serving Unicode characters.

  let
    domain = {
      HTTP = "h2o.local";
      TLS = "acme.test";
    };

    port = {
      HTTP = 8080;
      TLS = 8443;
    };

    sawatdi_chao_lok = "สวัสดีชาวโลก";

    hello_world_txt = pkgs.writeTextFile {
      name = "/hello_world.txt";
      text = sawatdi_chao_lok;
    };

    hello_world_rst = pkgs.writeTextFile {
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
        { pkgs, ... }:
        {
          services.h2o = {
            enable = true;
            defaultHTTPListenPort = port.HTTP;
            defaultTLSListenPort = port.TLS;
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
                  identity = [
                    {
                      key-file = ../../common/acme/server/acme.test.key.pem;
                      certificate-file = ../../common/acme/server/acme.test.cert.pem;
                    }
                  ];
                  extraSettings = {
                    minimum-version = "TLSv1.3";
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
            firewall.allowedTCPPorts = with port; [
              HTTP
              TLS
            ];
            extraHosts = ''
              127.0.0.1 ${domain.HTTP}
              127.0.0.1 ${domain.TLS}
            '';
          };
        };
    };

    testScript = # python
      ''
        server.wait_for_unit("h2o.service")

        http_hello_world_body = server.succeed("curl --fail-with-body 'http://${domain.HTTP}:${builtins.toString port.HTTP}/hello_world.txt'")
        assert "${sawatdi_chao_lok}" in http_hello_world_body

        tls_hello_world_head = server.succeed("curl -v --head --compressed --http2 --tlsv1.3 --fail-with-body 'https://${domain.TLS}:${builtins.toString port.TLS}/hello_world.rst'").lower()
        assert "http/2 200" in tls_hello_world_head
        assert "server: h2o" in tls_hello_world_head
        assert "content-type: text/x-rst" in tls_hello_world_head

        tls_hello_world_body = server.succeed("curl -v --http2 --tlsv1.3 --compressed --fail-with-body 'https://${domain.TLS}:${builtins.toString port.TLS}/hello_world.rst'")
        assert "${sawatdi_chao_lok}" in tls_hello_world_body

        tls_hello_world_head_redirected = server.succeed("curl -v --head --fail-with-body 'http://${domain.TLS}:${builtins.toString port.HTTP}/hello_world.rst'").lower()
        assert "redirected" in tls_hello_world_head_redirected

        server.fail("curl --location --max-redirs 0 'http://${domain.TLS}:${builtins.toString port.HTTP}/hello_world.rst'")

        tls_hello_world_body_redirected = server.succeed("curl -v --location --fail-with-body 'http://${domain.TLS}:${builtins.toString port.HTTP}/hello_world.rst'")
        assert "${sawatdi_chao_lok}" in tls_hello_world_body_redirected
      '';
  }
)
