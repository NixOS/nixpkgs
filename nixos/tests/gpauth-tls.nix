{ config, ... }:

{
  name = "gpauth-tls";

  meta.maintainers = config.node.pkgs.gpauth.meta.maintainers;

  nodes.machine =
    { pkgs, ... }:
    let
      httpsServer = pkgs.writeText "gpauth-test-server.py" ''
        import ssl
        from http.server import BaseHTTPRequestHandler, HTTPServer

        class Handler(BaseHTTPRequestHandler):
            def do_GET(self):
                body = b"<html><body>authenticated</body></html>"
                self.send_response(200)
                self.send_header("Content-Type", "text/html")
                self.send_header("Content-Length", str(len(body)))
                self.send_header("saml-auth-status", "1")
                self.send_header("saml-username", "fixture-user")
                self.send_header("prelogin-cookie", "fixture-cookie")
                self.end_headers()
                self.wfile.write(body)

            def log_message(self, format, *args):
                pass

        context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        context.load_cert_chain("cert.pem", "key.pem")

        server = HTTPServer(("127.0.0.1", 4443), Handler)
        server.socket = context.wrap_socket(server.socket, server_side=True)
        server.serve_forever()
      '';
    in
    {
      imports = [ ./common/x11.nix ];

      environment.systemPackages = [ pkgs.gpauth ];

      systemd.services.gpauth-test-server = {
        description = "gpauth test SAML endpoint";
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:2048 -noenc \
            -subj /CN=localhost -keyout key.pem -out cert.pem
        '';
        serviceConfig = {
          ExecStart = "${pkgs.python3}/bin/python ${httpsServer}";
          RuntimeDirectory = "gpauth-test-server";
          WorkingDirectory = "/run/gpauth-test-server";
        };
      };
    };

  testScript = ''
    machine.wait_for_x()
    machine.wait_for_unit("gpauth-test-server.service")
    machine.wait_for_open_port(4443)

    output = machine.succeed(
      "DISPLAY=:0 timeout 30s gpauth localhost "
      "--saml-request https://127.0.0.1:4443/ "
      # self-signed cert is used
      "--ignore-tls-errors"
    )
    assert "fixture-user" in output
    assert "fixture-cookie" in output
  '';
}
