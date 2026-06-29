{ pkgs, lib, ... }:
let
  serve =
    port: text:
    lib.getExe (
      pkgs.writers.writePython3Bin "serve"
        {
          libraries = [ pkgs.python3Packages.systemd ];
        }
        (
          let
            content = pkgs.writeText "content" text;
          in
          ''
            from http.server import BaseHTTPRequestHandler, HTTPServer
            from systemd.daemon import notify

            with open("${content}", "rb") as f:
                content = f.read()


            class HardcodedHandler(BaseHTTPRequestHandler):
                def do_GET(self):
                    reponse = content + self.path.encode('utf-8')
                    self.send_response(200)
                    self.send_header("Content-Type", "text/plain")
                    self.send_header("Content-Length", str(len(reponse)))
                    self.end_headers()
                    print("answering to GET request")
                    self.wfile.write(reponse)

                def log_message(self, format, *args):
                    pass  # optional: suppress logging


            if __name__ == "__main__":
                notify('STATUS=Starting up...')
                server_address = ('127.0.0.1', ${toString port})
                httpd = HTTPServer(server_address, HardcodedHandler)
                print("Serving hardcoded page on http://127.0.0.1:${toString port}")
                notify('READY=1')
                httpd.serve_forever()
          ''
        )
    );
in
{
  name = "mitmdump-default";

  nodes.machine =
    { config, pkgs, ... }:
    {
      systemd.services.test1 = {
        serviceConfig.ExecStart = serve 8000 "test1";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "notify";
          StandardOutput = "journal";
          StandardError = "journal";
        };
      };

      systemd.services.test2 = {
        serviceConfig.ExecStart = serve 8002 "test2";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "notify";
          StandardOutput = "journal";
          StandardError = "journal";
        };
      };

      services.mitmdump.instances."test1" = {
        listenPort = 8001;
        upstreamPort = 8000;
        after = [ "test1.service" ];
      };

      services.mitmdump.instances."test2" = {
        listenPort = 8003;
        upstreamPort = 8002;
        after = [ "test2.service" ];
        enabledAddons = [ config.services.mitmdump.addons.logger ];
        extraArgs = [
          "--set"
          "verbose_pattern=/verbose"
        ];
      };
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      machine.wait_for_unit("test1.service")
      machine.wait_for_unit("test2.service")
      machine.wait_for_unit("mitmdump-test1.service")
      machine.wait_for_unit("mitmdump-test2.service")

      resp = machine.succeed("curl http://127.0.0.1:8000")
      print(resp)
      if resp != "test1/":
          raise Exception("wanted 'test1'")

      resp = machine.succeed("curl -v http://127.0.0.1:8001")
      print(resp)
      if resp != "test1/":
          raise Exception("wanted 'test1'")

      resp = machine.succeed("curl http://127.0.0.1:8002")
      print(resp)
      if resp != "test2/":
          raise Exception("wanted 'test2'")

      resp = machine.succeed("curl http://127.0.0.1:8003/notverbose")
      print(resp)
      if resp != "test2/notverbose":
          raise Exception("wanted 'test2/notverbose'")

      resp = machine.succeed("curl http://127.0.0.1:8003/verbose")
      print(resp)
      if resp != "test2/verbose":
          raise Exception("wanted 'test2/verbose'")

      dump = machine.succeed("journalctl -b -u mitmdump-test1.service")
      print(dump)
      if "HTTP/1.0 200 OK" not in dump:
          raise Exception("expected to see HTTP/1.0 200 OK")
      if "test1" not in dump:
          raise Exception("expected to see test1")

      dump = machine.succeed("journalctl -b -u mitmdump-test2.service")
      print(dump)
      if "HTTP/1.0 200 OK" not in dump:
          raise Exception("expected to see HTTP/1.0 200 OK")
      if "test2/notverbose" in dump:
          raise Exception("expected not to see test2/notverbose")
      if "test2/verbose" not in dump:
          raise Exception("expected to see test2/verbose")
    '';
}
