{
  lib,
  ...
}:
let
  # WebUI / WebSocket channel port (services.nanobot.port).
  port = 8765;
  # Health endpoint port (upstream `gateway` server, loopback-only default).
  healthPort = 18790;
in
{
  name = "nanobot";
  meta.maintainers = with lib.maintainers; [ gdifolco ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.nanobot = {
        enable = true;
        inherit port;
        # The gateway needs a configured provider to boot; supply a dummy one
        # so the service starts and the health endpoint comes up. No real LLM
        # call is made by the test.
        settings = {
          providers.custom = {
            apiKey = "dummy-key-not-used-by-the-test";
            apiBase = "http://127.0.0.1:9/api";
          };
          modelPresets.primary = {
            label = "Primary";
            provider = "custom";
            model = "test-model";
            maxTokens = 128;
            contextWindowTokens = 1024;
          };
          # Pin the health-endpoint port instead of relying on the
          # upstream default.
          gateway.port = healthPort;
        };
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("nanobot.service")
    machine.wait_for_open_port(${toString port})
    machine.wait_for_open_port(${toString healthPort})

    # The gateway exposes a lightweight health endpoint on its own port.
    machine.succeed("curl -fsS http://127.0.0.1:${toString healthPort}/health | grep -E '\"status\": ?\"ok\"'")

    machine.shutdown()
  '';
}
