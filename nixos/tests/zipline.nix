import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "zipline";
    meta.maintainers = with lib.maintainers; [ defelo ];

    nodes.machine = {
      services.zipline = {
        enable = true;
        settings = {
          CORE_HOSTNAME = "127.0.0.1";
          CORE_PORT = 8000;
        };
        environmentFiles = [
          (builtins.toFile "zipline.env" ''
            CORE_SECRET=DMlouex3W0QLRbVwkUafNnNws5jpgRDX
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

      resp = machine.succeed("curl zipline.local:8000/api/setup -v -X POST -H 'Content-Type: application/json' -d '{\"username\": \"administrator\", \"password\": \"password\"}' 2>&1")
      data = json.loads(resp.splitlines()[-1])
      assert data["firstSetup"] is True
      assert data["user"]["username"] == "administrator"
      assert data["user"]["role"] == "SUPERADMIN"

      resp = machine.succeed("curl zipline.local:8000/api/auth/login -v -X POST -H 'Content-Type: application/json' -d '{\"username\": \"administrator\", \"password\": \"password\"}' 2>&1")

      assert (cookie := re.search(r"(?m)^< set-cookie: ([^;]*)", resp))
      resp = machine.succeed(f"curl zipline.local:8000/api/user -H 'Cookie: {cookie[1]}'")
      assert json.loads(resp)["user"]["id"] == data["user"]["id"]
    '';
  }
)
