{ ... }:
let
  credentials = email: {
    inherit email;
    password = "correct-horse-battery-staple-42";
    firstName = "Test";
    lastName = "Athlete";
  };

  redisPassword = "0123456789abcdef0123456789abcdef";
  redisPort = 6390;
in
{
  name = "openathlete";

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.memorySize = 3072;

      environment.etc = {
        "openathlete/env".text = ''
          JWT_SECRET_KEY=0123456789abcdef0123456789abcdef0123456789abcdef
          HASH_PEPPER=fedcba9876543210fedcba9876543210fedcba9876543210
        '';
        "openathlete/redis-password".text = redisPassword;
        "openathlete/first.json".source = pkgs.writeText "first.json" (
          builtins.toJSON (credentials "athlete@example.com")
        );
        "openathlete/second.json".source = pkgs.writeText "second.json" (
          builtins.toJSON (credentials "intruder@example.com")
        );
      };

      services.openathlete = {
        enable = true;
        hostName = "localhost";
        settings.APP_URL = "http://localhost";
        environmentFiles = [ "/etc/openathlete/env" ];
        redis = {
          port = redisPort;
          passwordFile = "/etc/openathlete/redis-password";
        };
      };
    };

  testScript =
    { nodes, ... }:
    ''
      import json
      import re

      post = "curl --fail -X POST -H 'Content-Type: application/json'"

      def response_headers(path):
          return machine.succeed(f"curl --fail -s -D - -o /dev/null http://localhost{path}").lower()

      machine.wait_for_unit("openathlete.service")

      with subtest("the API answers through nginx"):
          machine.wait_until_succeeds("curl --fail http://localhost/api/health | grep -F '\"status\":\"ok\"'")

      with subtest("the web app is served with the API URL and hardened headers"):
          index = machine.succeed("curl --fail http://localhost/")
          assert 'content="/api"' in index, "API base URL missing from index.html"
          machine.succeed("curl --fail http://localhost/some/client/route | grep -F '<div id=\"root\"'")
          headers = machine.succeed("curl --fail -sI http://localhost/").lower()
          assert "x-frame-options: sameorigin" in headers, headers
          assert "no-store" in headers, headers

      with subtest("the bundle is served with its types, caching and compiled translations"):
          assets = re.findall(r'(?:src|href)="(/assets/[^"]+)"', index)
          assert any(a.endswith(".js") for a in assets) and any(a.endswith(".css") for a in assets), assets
          for asset in assets:
              h = response_headers(asset)
              assert "immutable" in h, h
              assert "x-content-type-options: nosniff" in h and "x-frame-options: sameorigin" in h, h
              if asset.endswith(".js"):
                  assert re.search(r"content-type: (text|application)/javascript", h), h
          webroot = "${nodes.machine.services.openathlete.nginx.root}"
          for text in ["Failed to start checkout", "Fondateur", "Afrekenen starten mislukt"]:
              chunk = machine.succeed(f"grep -rlF '{text}' {webroot}/assets | head -n 1").strip()
              assert chunk, f"{text!r} is in no shipped asset"
              machine.succeed(f"curl --fail -s http://localhost{chunk.removeprefix(webroot)} | grep -cF '{text}'")

      with subtest("proxied paths are not captured by the static asset rules"):
          for path in ["/api/nonexistent.png", "/api/nonexistent.js"]:
              h = machine.succeed(f"curl -s -D - -o /dev/null http://localhost{path}").lower()
              assert " 404" in h.splitlines()[0], h
              assert "content-type: application/json" in h and "immutable" not in h, h

      with subtest("an account can be created and its token authenticates"):
          machine.succeed(f"{post} -d @/etc/openathlete/first.json http://localhost/api/user")
          session = json.loads(machine.succeed(f"{post} -d @/etc/openathlete/first.json http://localhost/api/auth/login"))
          token = session["accessToken"]
          assert token.count(".") == 2, f"login returned no JWT: {session}"
          me = json.loads(machine.succeed(f"curl --fail -H 'Authorization: Bearer {token}' http://localhost/api/user/me"))
          assert me["email"] == "athlete@example.com", f"authenticated request returned {me}"

      with subtest("signup is invitation-only once the first account exists"):
          status = machine.succeed("curl -s -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' -d @/etc/openathlete/second.json http://localhost/api/user")
          assert status == "403", f"second signup answered {status}"

      with subtest("socket.io is reachable through nginx, including the websocket upgrade"):
          machine.succeed("curl --fail -s 'http://localhost/socket.io/?EIO=4&transport=polling' | grep -F '\"sid\"'")
          status = machine.succeed(
              "(curl -s -o /dev/null -w '%{http_code}' --max-time 5"
              " -H 'Connection: Upgrade' -H 'Upgrade: websocket'"
              " -H 'Sec-WebSocket-Version: 13' -H 'Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ=='"
              " 'http://localhost/socket.io/?EIO=4&transport=websocket' || true)"
          )
          assert status == "101", f"websocket upgrade through nginx returned {status}"

      with subtest("OAuth discovery documents come from the API, not the SPA"):
          metadata = json.loads(machine.succeed("curl --fail http://localhost/.well-known/oauth-authorization-server"))
          assert metadata["token_endpoint"].startswith("http://localhost"), f"unexpected metadata: {metadata}"

      with subtest("the vector extension that migrations require is installed"):
          machine.succeed("sudo -u postgres psql openathlete -tAc \"select extname from pg_extension where extname = 'vector'\" | grep -x vector")

      with subtest("Redis needs a password, does not evict, and the API is connected to it"):
          machine.succeed("redis-cli -p ${toString redisPort} ping | grep -F NOAUTH")
          redis = "redis-cli -p ${toString redisPort} -a ${redisPassword} --no-auth-warning"
          machine.succeed(f"{redis} config get maxmemory-policy | grep -x noeviction")
          clients = int(machine.succeed(f"{redis} info clients | tr -d '\\r' | sed -n 's/^connected_clients://p'"))
          assert clients > 1, f"the API holds no connection to Redis ({clients} client)"
          machine.wait_until_succeeds(f"{redis} client list | grep -F ' db=1 '")
          machine.wait_until_succeeds(f"{redis} client list | grep -F ' db=2 '")
          machine.succeed("grep '^include' /run/redis-openathlete/nixos.conf | cut -d'\"' -f2 | xargs grep -F 'maxmemory-policy noeviction'")

      with subtest("the service restarts, migrations are idempotent and the account survives"):
          machine.succeed("systemctl restart openathlete.service")
          machine.wait_for_unit("openathlete.service")
          machine.wait_until_succeeds("curl --fail http://localhost/api/health | grep -F '\"status\":\"ok\"'")
          machine.succeed(f"{post} -d @/etc/openathlete/first.json http://localhost/api/auth/login | grep -F accessToken")

      with subtest("the service worker is always revalidated"):
          h = response_headers("/sw.js")
          assert "cache-control: no-cache" in h and "x-content-type-options: nosniff" in h, h
    '';
}
