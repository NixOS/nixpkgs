{ pkgs, lib, ... }:
{
  name = "wanderer";
  meta.maintainers = with lib.maintainers; [ charludo ];

  nodes.machine = {
    services.meilisearch.masterKeyFile = pkgs.writeText "meili-master-key" "a-very-secret-meili-master-key-123456789";

    services.wanderer = {
      enable = true;
      settings.ORIGIN = "http://localhost:3000";
      secrets = {
        shared.POCKETBASE_PROXY_SECRET = pkgs.writeText "proxy-secret" "proxy-secret";
        backend.POCKETBASE_ENCRYPTION_KEY = pkgs.writeText "encryption-key" "12345678901234567890123456789012";
        web.PROTOMAPS_API_KEY = pkgs.writeText "protomaps-api-key" "protomaps-api-key";
      };
      plugins = [ pkgs.wanderer.plugins.komoot ];
      about = ''
        # Welcome to the NixOS test instance

        nixos-about-marker
      '';
    };
  };

  testScript =
    #python
    ''
      import json

      machine.wait_for_unit("meilisearch.service")
      machine.wait_for_unit("wanderer.service")
      machine.wait_for_unit("wanderer-web.service")
      machine.wait_for_open_port(8090)
      machine.wait_for_open_port(3000)

      machine.succeed("curl -fsS http://127.0.0.1:8090/api/health")
      machine.succeed("curl -fsS http://localhost:3000/ | grep -i wanderer")

      with subtest("about section is overridden"):
          for encoding in ["br", "gzip", "identity"]:
              headers = machine.succeed(f"curl -fsS -o /dev/null -D - -H 'Accept-Encoding: {encoding}' http://localhost:3000/md/about.md")
              if encoding != "identity":
                  assert f"content-encoding: {encoding}" in headers.lower(), headers
              machine.succeed(f"curl -fsS --compressed -H 'Accept-Encoding: {encoding}' http://localhost:3000/md/about.md | grep -x nixos-about-marker")

      with subtest("secrets only reach the services they are meant for"):
          def env_of(unit):
              pid = machine.succeed(f"systemctl show -p MainPID --value {unit}").strip()
              return machine.succeed(f"tr '\\0' '\\n' < /proc/{pid}/environ")
          web_env = env_of("wanderer-web.service")
          backend_env = env_of("wanderer.service")
          assert "PROTOMAPS_API_KEY=protomaps-api-key" in web_env, web_env
          assert "POCKETBASE_PROXY_SECRET=proxy-secret" in web_env, web_env
          assert "POCKETBASE_ENCRYPTION_KEY" not in web_env, web_env
          assert "PROTOMAPS_API_KEY" not in backend_env, backend_env
          assert "POCKETBASE_PROXY_SECRET=proxy-secret" in backend_env, backend_env
          assert "POCKETBASE_ENCRYPTION_KEY=" in backend_env, backend_env

      with subtest("plugins are discovered"):
          credentials = json.dumps({"username": "test", "email": "test@example.com", "password": "password1234", "passwordConfirm": "password1234"})
          machine.succeed(f"curl -fsS -H 'Content-Type: application/json' -d '{credentials}' http://127.0.0.1:8090/api/collections/users/records")
          login = json.dumps({"identity": "test@example.com", "password": "password1234"})
          token = json.loads(machine.succeed(f"curl -fsS -H 'Content-Type: application/json' -d '{login}' http://127.0.0.1:8090/api/collections/users/auth-with-password"))["token"]
          plugins = json.loads(machine.succeed(f"curl -fsS -H 'Authorization: {token}' http://127.0.0.1:8090/plugins"))["items"]
          assert [p["id"] for p in plugins] == ["komoot"], plugins
    '';
}
