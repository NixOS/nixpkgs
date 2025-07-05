{ lib, pkgs, ... }:
let
  # https://docs.mitmproxy.org/stable/concepts/certificates/#using-a-custom-certificate-authority
  caCert = pkgs.runCommand "ca-cert" { } ''
    touch $out
    cat ${./common/acme/server/ca.key.pem} >> $out
    cat ${./common/acme/server/ca.cert.pem} >> $out
  '';
in
{
  name = "mitmproxy";
  meta.maintainers = [ lib.teams.ngi.members ];

  nodes.machine =
    { pkgs, ... }:
    {
      security.pki.certificateFiles = [ caCert ];

      services.getty.autologinUser = "root";

      environment.systemPackages =
        let
          counter = pkgs.writers.writePython3Bin "counter" { } ''
            from http.server import BaseHTTPRequestHandler, HTTPServer

            counter = 0


            class HTTPRequestHandler(BaseHTTPRequestHandler):
                def do_POST(self):
                    match self.path:
                        case "/counter":
                            global counter
                            counter += 1
                            self.send_response(204)
                            self.end_headers()
                        case _:
                            self.send_response(404)
                            self.end_headers()

                def do_GET(self):
                    match self.path:
                        case "/counter":
                            self.send_response(200)
                            self.send_header("Content-type", "text/plain")
                            self.end_headers()
                            _ = self.wfile.write(str(counter).encode())
                        case "/old":
                            self.send_response(200)
                            self.send_header("Content-type", "text/plain")
                            self.end_headers()
                            _ = self.wfile.write("fail".encode())
                        case "/new":
                            self.send_response(200)
                            self.send_header("Content-type", "text/plain")
                            self.end_headers()
                            _ = self.wfile.write("success".encode())
                        case _:
                            self.send_response(404)
                            self.end_headers()


            server_address = ("", 8000)
            server = HTTPServer(server_address, HTTPRequestHandler)
            server.serve_forever()
          '';
        in
        [
          counter
          pkgs.mitmproxy
        ];
    };

  testScript =
    let
      addonScript = pkgs.writeText "addon-script" ''
        def request(flow):
            flow.request.path = "/new"
      '';
    in
    ''
      def curl(command: str, proxy: bool):
          if proxy:
              command = "curl --proxy 127.0.0.1:8080 --cacert ~/.mitmproxy/mitmproxy-ca-cert.pem " + command
          else:
              command = "curl " + command
          return machine.succeed(command)

      start_all()
      machine.wait_for_unit("default.target")

      # https://docs.mitmproxy.org/stable/concepts/certificates/#using-a-custom-certificate-authority
      machine.succeed("mkdir -p ~/.mitmproxy")
      machine.succeed("ln -s ${caCert} ~/.mitmproxy/mitmproxy-ca.pem")

      machine.succeed("counter >/dev/null &")
      machine.wait_for_open_port(8000)

      # rewrite

      t.assertEqual("fail", curl("http://localhost:8000/old", False))

      machine.send_chars("mitmdump -s ${addonScript}\n")
      machine.wait_for_open_port(8080)

      t.assertEqual("success", curl("http://localhost:8000/old", True))

      machine.send_key("ctrl-c")

      # replay

      curl("http://localhost:8000/reset", False)

      t.assertEqual("0", curl("http://localhost:8000/counter", False))

      machine.send_chars("mitmdump -w replay\n")
      machine.wait_for_open_port(8080)

      curl("-X POST http://localhost:8000/counter", True)

      machine.send_key("ctrl-c")

      t.assertEqual("1", curl("http://localhost:8000/counter", False))

      machine.succeed("mitmdump -C /root/replay")

      t.assertEqual("2", curl("http://localhost:8000/counter", False))
    '';
}
