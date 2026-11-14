{ lib, ... }:
{
  name = "pingvin-share-x";
  meta.maintainers = with lib.maintainers; [ znaniye ];

  nodes.machine = {
    services.pingvin-share-x = {
      backend.port = 9010;
      enable = true;
      frontend.port = 9011;
      nginx = {
        enable = true;
        hostName = "localhost";
      };
      settings.initUser = {
        email = "admin@example.com";
        enabled = true;
        isAdmin = true;
        password = "correct-horse-battery";
        username = "admin";
      };
    };
    virtualisation.memorySize = 2048;
  };
  nodes.yaml = {
    services.pingvin-share-x = {
      enable = true;
      settings.general.appName = "Declared Share";
    };
    virtualisation.memorySize = 2048;
  };
  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.services.pingvin-share-x) package;
    in
    ''
      import json

      start_all()

      machine.wait_for_unit("pingvin-share-x-frontend.service")
      machine.wait_for_open_port(9010)
      machine.wait_for_open_port(9011)
      machine.succeed("ss -Hltn 'sport = :9010' | grep -q '127.0.0.1:9010'")
      machine.fail("ss -Hltn 'sport = :9010' | grep -v '127.0.0.1:9010'")

      machine.succeed("curl --fail http://127.0.0.1:9010/api/health")
      machine.succeed("curl --fail http://127.0.0.1:9011/")
      machine.succeed("curl --fail http://localhost/api/configs")
      machine.succeed("curl --fail http://localhost/img/logo.png -o /dev/null")

      machine.succeed(
          "curl --fail -c /tmp/jar -H 'Content-Type: application/json' "
          "-d '{\"email\":\"admin@example.com\",\"password\":\"correct-horse-battery\"}' "
          "http://localhost/api/auth/signIn"
      )
      machine.succeed("head -c 1M /dev/urandom > /tmp/payload")
      machine.succeed(
          "curl --fail -b /tmp/jar -H 'Content-Type: application/json' "
          "-d '{\"id\":\"testshare\",\"expiration\":\"never\",\"security\":{},\"recipients\":[]}' "
          "http://localhost/api/shares"
      )
      file = json.loads(machine.succeed(
          "curl --fail -b /tmp/jar -H 'Content-Type: application/octet-stream' "
          "--data-binary @/tmp/payload "
          "'http://localhost/api/shares/testshare/files?name=payload&chunkIndex=0&totalChunks=1'"
      ))
      machine.succeed("curl --fail -b /tmp/jar -X POST http://localhost/api/shares/testshare/complete")
      machine.succeed(
          "curl --fail -c /tmp/visitor -H 'Content-Type: application/json' -d '{}' "
          "http://localhost/api/shares/testshare/token"
      )
      machine.succeed(
          f"curl --fail -b /tmp/visitor -o /tmp/downloaded http://localhost/api/shares/testshare/files/{file['id']}"
      )
      machine.succeed("cmp /tmp/payload /tmp/downloaded")
      machine.succeed("test -f /var/lib/pingvin-share-x/data/pingvin-share.db")

      machine.succeed(
          "curl --fail -b /tmp/jar -F 'file=@${package.frontend}/img/icons/icon-512x512.png;type=image/png' "
          "http://localhost/api/configs/admin/logo"
      )
      machine.succeed("curl --fail -o /tmp/logo.png http://localhost/img/logo.png")
      machine.fail("cmp /tmp/logo.png ${package.frontend}/img/logo.png")
      machine.succeed("cmp /tmp/logo.png /var/lib/pingvin-share-x/images/logo.png")

      machine.succeed("systemctl restart pingvin-share-x-backend.service pingvin-share-x-frontend.service")
      machine.wait_for_open_port(9010)
      machine.wait_for_open_port(9011)
      machine.succeed("curl --fail -o /tmp/logo-after-restart.png http://localhost/img/logo.png")
      machine.succeed("cmp /tmp/logo.png /tmp/logo-after-restart.png")
      machine.succeed(
          "curl --fail -c /tmp/jar -H 'Content-Type: application/json' "
          "-d '{\"email\":\"admin@example.com\",\"password\":\"correct-horse-battery\"}' "
          "http://localhost/api/auth/signIn"
      )
      machine.succeed(
          f"curl --fail -b /tmp/visitor -o /tmp/downloaded-again http://localhost/api/shares/testshare/files/{file['id']}"
      )
      machine.succeed("cmp /tmp/payload /tmp/downloaded-again")

      yaml.wait_for_unit("pingvin-share-x-frontend.service")
      yaml.wait_for_open_port(8080)
      configs = json.loads(yaml.succeed("curl --fail http://127.0.0.1:8080/api/configs"))
      assert next(c for c in configs if c["key"] == "general.appName")["value"] == "Declared Share"
      yaml.succeed("curl --fail http://127.0.0.1:3000/")
    '';
}
