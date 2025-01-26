import ./make-test-python.nix (
  { pkgs, ... }:

  let
    testString = "NixOS Gemini test successful";
  in
  {

    name = "molly-brown";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ ehmry ];
    };

    nodes = {

      geminiServer =
        { config, pkgs, ... }:
        let
          inherit (config.networking) hostName;
          cfg = config.services.molly-brown;
        in
        {

          environment.systemPackages = [
            (pkgs.writeScriptBin "test-gemini" ''
              #!${pkgs.python3}/bin/python

              import socket
              import ssl
              import tempfile
              import textwrap
              import urllib.parse

              url = "gemini://geminiServer/init.gmi"
              parsed_url = urllib.parse.urlparse(url)

              s = socket.create_connection((parsed_url.netloc, 1965))
              context = ssl.SSLContext()
              context.check_hostname = False
              context.verify_mode = ssl.CERT_NONE
              s = context.wrap_socket(s, server_hostname=parsed_url.netloc)
              s.sendall((url + "\r\n").encode("UTF-8"))
              fp = s.makefile("rb")
              print(fp.readline().strip())
              print(fp.readline().strip())
              print(fp.readline().strip())
            '')
          ];

          networking.firewall.allowedTCPPorts = [ cfg.settings.Port ];

          services.molly-brown = {
            enable = true;
            docBase = "/tmp/docs";
            certPath = "/tmp/cert.pem";
            keyPath = "/tmp/key.pem";
          };

          systemd.services.molly-brown.preStart = ''
            ${pkgs.openssl}/bin/openssl genrsa -out "/tmp/key.pem"
            ${pkgs.openssl}/bin/openssl req -new \
              -subj "/CN=${config.networking.hostName}" \
              -key "/tmp/key.pem" -out /tmp/request.pem
            ${pkgs.openssl}/bin/openssl x509 -req -days 3650 \
              -in /tmp/request.pem -signkey "/tmp/key.pem" -out "/tmp/cert.pem"

            mkdir -p "${cfg.settings.DocBase}"
            echo "${testString}" > "${cfg.settings.DocBase}/test.gmi"
          '';
        };
    };
    testScript = ''
      geminiServer.wait_for_unit("molly-brown")
      geminiServer.wait_for_open_port(1965)
      geminiServer.succeed("test-gemini")
    '';

  }
)
