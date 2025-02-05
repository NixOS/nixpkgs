import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "zipline";
    meta.maintainers = with lib.maintainers; [ defelo ];

    nodes.machine = {
      services.zipline = {
        enable = true;
        settings = {
          CORE_HOST = "127.0.0.1";
          CORE_PORT = 8000;
        };
        environmentFiles = [
          (builtins.toFile "zipline.env" ''
            CORE_SECRET=testsecret
          '')
        ];
      };

      networking.hosts."127.0.0.1" = [ "zipline.local" ];
    };

    testScript = ''
      import json
      import re

      machine.wait_for_unit("zipline.service")
      machine.wait_for_open_port(8000)

      resp = machine.succeed("curl zipline.local:8000/api/auth/login -v -X POST -H 'Content-Type: application/json' -d '{\"username\": \"administrator\", \"password\": \"password\"}' 2>&1")
      assert json.loads(resp.splitlines()[-1]) == {"success": True}

      assert (cookie := re.search(r"(?m)^< Set-Cookie: ([^;]*)", resp))
      resp = machine.succeed(f"curl zipline.local:8000/api/user/token -H 'Cookie: {cookie[1]}' -X PATCH")
      token = json.loads(resp)["success"]

      resp = machine.succeed(f"curl zipline.local:8000/api/shorten -H 'Authorization: {token}' -X POST -H 'Content-Type: application/json' -d '{{\"url\": \"https://nixos.org/\", \"vanity\": \"nixos\"}}'")
      url = json.loads(resp)["url"]
      assert url == "http://zipline.local:8000/go/nixos"

      resp = machine.succeed(f"curl -I {url}")
      assert re.search(r"(?m)^HTTP/1.1 302 Found\r?$", resp)
      assert (location := re.search(r"(?mi)^location: (.+?)\r?$", resp))
      assert location[1] == "https://nixos.org/"
    '';
  }
)
