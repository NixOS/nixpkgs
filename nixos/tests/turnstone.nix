{ pkgs, lib, ... }:
{
  name = "turnstone";
  meta.maintainers = with lib.maintainers; [ timvherpen ];

  nodes.sqlite =
    { pkgs, ... }:
    {
      virtualisation.cores = 2;
      virtualisation.memorySize = 2048;

      services.turnstone = {
        jwtSecretFile = "${pkgs.writeText "jwt-secret" "0000000000000000000000000000000000000000000000000000000000000000"}";

        database = {
          backend = "sqlite";
          path = "/var/lib/turnstone/turnstone.db";
        };

        server = {
          enable = true;
          port = 8080;
        };
      };
    };

  nodes.postgresql =
    { pkgs, ... }:
    let
      # A deterministic, lightweight fake LLM backend answering OpenAI chat completion requests
      mockLlmServer = pkgs.writeScript "mock-llm.py" ''
        #!${pkgs.python3}/bin/python3
        import http.server
        import json

        class Handler(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                if self.path == "/health":
                    self.send_response(200)
                    self.end_headers()
                    self.wfile.write(b'{"status":"ok"}')
                else:
                    self.send_response(404)
                    self.end_headers()

            def do_POST(self):
                if "/chat/completions" in self.path:
                    self.send_response(200)
                    self.send_header("Content-Type", "application/json")
                    self.end_headers()
                    response = {
                        "id": "chatcmpl-mock",
                        "object": "chat.completion",
                        "created": 1700000000,
                        "model": "mock-model",
                        "choices": [{
                            "index": 0,
                            "message": {
                                "role": "assistant",
                                "content": "Hello from mock LLM!"
                            },
                            "finish_reason": "stop"
                        }],
                        "usage": {"prompt_tokens": 5, "completion_tokens": 5, "total_tokens": 10}
                    }
                    self.wfile.write(json.dumps(response).encode())
                else:
                    self.send_response(200)
                    self.send_header("Content-Type", "application/json")
                    self.end_headers()
                    self.wfile.write(b'{"data":[]}')

            def log_message(self, format, *args):
                pass

        server = http.server.HTTPServer(("127.0.0.1", 9000), Handler)
        server.serve_forever()
      '';
    in
    {
      virtualisation.cores = 4;
      virtualisation.memorySize = 4096;

      systemd.services.mock-llm = {
        description = "Mock OpenAI HTTP endpoint for VM testing";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${mockLlmServer}";
          Restart = "always";
        };
      };

      services.turnstone = {
        jwtSecretFile = "${pkgs.writeText "jwt-secret" "0000000000000000000000000000000000000000000000000000000000000000"}";

        database = {
          backend = "postgresql";
          createLocally = true;
          name = "turnstone";
          user = "turnstone";
        };

        server = {
          enable = true;
          port = 8080;
        };

        console = {
          enable = true;
          port = 8090;
        };
      };
    };

  testScript = ''
    start_all()

    # --- SQLite Standalone Node ---

    with subtest("sqlite: wait for server startup"):
        sqlite.wait_for_unit("turnstone-server.service")
        sqlite.wait_for_open_port(8080)

    with subtest("sqlite: verify server endpoint responds"):
        sqlite.succeed("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8080 | grep -E '^(200|401|403|404)$'")

    with subtest("sqlite: verify process user and permissions"):
        sqlite.succeed("id turnstone")
        sqlite.succeed("stat -c '%a' /var/lib/turnstone/config.toml | grep -q '600'")
        sqlite.succeed("stat -c '%U:%G' /var/lib/turnstone | grep -q 'turnstone:turnstone'")
        sqlite.succeed("test -f /var/lib/turnstone/turnstone.db")

    # --- PostgreSQL Shared Storage Node ---

    with subtest("postgresql: wait for core services"):
        postgresql.wait_for_unit("mock-llm.service")
        postgresql.wait_for_open_port(9000)
        postgresql.wait_for_unit("postgresql.service")
        postgresql.wait_for_unit("turnstone-server.service")
        postgresql.wait_for_open_port(8080)
        postgresql.wait_for_unit("turnstone-console.service")
        postgresql.wait_for_open_port(8090)

    with subtest("postgresql: verify endpoints respond"):
        postgresql.succeed("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8080 | grep -E '^(200|401|403|404)$'")
        postgresql.succeed("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8090 | grep -E '^(200|401|403|404)$'")

    with subtest("postgresql: verify database schema and tables exist"):
        postgresql.succeed("sudo -u postgres psql -lqt | grep -q turnstone")
        # Ensure Alembic migrations executed successfully
        postgresql.succeed("sudo -u postgres psql -d turnstone -c '\\dt' | grep -q alembic_version")

    with subtest("postgresql: verify turnstone-admin CLI"):
        # Test creating and listing users via the admin CLI against PostgreSQL
        postgresql.succeed(
            "sudo -u turnstone turnstone-admin --config /var/lib/turnstone/config.toml create-user --username admin --name 'Administrator' --password 'insecure-test-pass'"
        )
        postgresql.succeed(
            "sudo -u turnstone turnstone-admin --config /var/lib/turnstone/config.toml list-users | grep -q admin"
        )

    with subtest("postgresql: verify restart idempotency"):
        # Restarting services should not corrupt or re-run destructive schema operations
        postgresql.systemctl("restart turnstone-server.service")
        postgresql.wait_for_unit("turnstone-server.service")
        postgresql.wait_for_open_port(8080)
        postgresql.succeed("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8080 | grep -E '^(200|401|403|404)$'")
  '';
}
