{ lib, ... }:

let
  port = 11435;
  apiKey = "ollaya-test-key";
in
{
  name = "ollaya";
  meta.maintainers = with lib.maintainers; [ happysalada ];

  nodes.machine =
    { ... }:
    {
      services.ollaya = {
        enable = true;
        inherit port;
        settings.OLLAYA_API_KEY = apiKey;
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("ollaya.service")
    machine.wait_for_open_port(${toString port})

    # `GET /` is the liveness endpoint and the only one that takes no API key.
    assert "Ollaya is running" in machine.succeed(
        "curl --fail http://127.0.0.1:${toString port}/"
    )

    # `services.ollaya.settings` reaches the server: the API refuses a request
    # without the key, and answers the model list with it.
    status = machine.succeed(
        "curl -so /dev/null -w '%{http_code}' http://127.0.0.1:${toString port}/api/tags"
    )
    assert status == "401", status

    tags = machine.succeed(
        "curl --fail -H 'Authorization: Bearer ${apiKey}' http://127.0.0.1:${toString port}/api/tags"
    )
    assert json.loads(tags)["models"] == [], tags
  '';
}
