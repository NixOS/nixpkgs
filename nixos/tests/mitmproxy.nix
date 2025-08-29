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
          # A counter.  It has 2 functions:
          # 1. GET /old and GET /new, to demostrate rewriting requests.
          # 2. GET /counter and POST /counter, to demonstrate replaying requests.
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
          pkgs.mitmproxy2swagger
        ];
    };

  testScript =
    let
      addonScript = pkgs.writeText "addon-script" ''
        def request(flow):
            # https://docs.mitmproxy.org/stable/api/mitmproxy/http.html#Request
            flow.request.path = "/new"
      '';
    in
    ''
      def curl(command: str, proxy: bool = False):
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
      # https://docs.mitmproxy.org/stable/mitmproxytutorial-modifyrequests/

      t.assertEqual("fail", curl("http://localhost:8000/old"))

      machine.send_chars("mitmdump -s ${addonScript}\n")
      machine.wait_for_open_port(8080)

      t.assertEqual("success", curl("http://localhost:8000/old", proxy=True))

      machine.send_key("ctrl-c")

      # replay
      # https://docs.mitmproxy.org/stable/mitmproxytutorial-replayrequests/
      # https://docs.mitmproxy.org/stable/tutorials/client-replay/

      t.assertEqual("0", curl("http://localhost:8000/counter"))

      machine.send_chars("mitmdump -w replay\n")
      machine.wait_for_open_port(8080)

      curl("-X POST http://localhost:8000/counter", proxy=True)

      machine.send_key("ctrl-c")

      t.assertEqual("1", curl("http://localhost:8000/counter"))

      machine.succeed("mitmdump -C /root/replay")

      t.assertEqual("2", curl("http://localhost:8000/counter"))

      # create a OpenAPI 3.0 spec from captured flow
      # https://github.com/alufers/mitmproxy2swagger

      # create a initial spec
      machine.succeed("mitmproxy2swagger -i /root/replay -f flow -o /root/spec -p http://localhost:8000")
      # don't ignore any endpoint
      machine.succeed("sed -i -e 's/- ignore:/- /' /root/spec")
      # generate the actual spec
      machine.succeed("mitmproxy2swagger -i /root/replay -f flow -o /root/spec -p http://localhost:8000")
      # check for endpoint /counter
      machine.succeed("grep '/counter:' /root/spec")
    '';
}
