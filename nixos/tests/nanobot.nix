{
  lib,
  ...
}:
let
  port = 8765;
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
