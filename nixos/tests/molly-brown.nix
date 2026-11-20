{ pkgs, ... }:

let
  testString = "NixOS Gemini test successful";
in
{

  name = "molly-brown";

  nodes = {

    geminiServer =
      { config, pkgs, ... }:
      let
        inherit (config.networking) hostName;
        cfg = config.services.molly-brown;
        openssl = pkgs.lib.getExe pkgs.openssl;
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
          docBase = "/var/lib/molly-brown/docs";
          certPath = "/var/lib/molly-brown/cert.pem";
          keyPath = "/var/lib/molly-brown/key.pem";
        };

        systemd.services.molly-brown = {
          serviceConfig.StateDirectory = "molly-brown";
          preStart = ''
            ${openssl} genrsa -out "$STATE_DIRECTORY/key.pem"
            ${openssl} req -new \
              -subj "/CN=${hostName}" \
              -key "$STATE_DIRECTORY/key.pem" -out "$STATE_DIRECTORY/request.pem"
            ${openssl} x509 -req -days 3650 \
              -in "$STATE_DIRECTORY/request.pem" -signkey "$STATE_DIRECTORY/key.pem" -out "$STATE_DIRECTORY/cert.pem"

            mkdir -p "${cfg.settings.DocBase}"
            echo "${testString}" > "${cfg.settings.DocBase}/test.gmi"
          '';
        };
      };
  };
  testScript = ''
    geminiServer.wait_for_unit("molly-brown")
    geminiServer.wait_for_open_port(1965)
    geminiServer.succeed("test-gemini")
  '';

}
