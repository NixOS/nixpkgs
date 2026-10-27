{ lib, ... }:
{
  name = "nzbhydra2";
  meta.maintainers = with lib.maintainers; [ matteopacini ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.nzbhydra2.enable = true;
    };

  testScript = ''
    import json

    base = "http://localhost:5076"

    def api_key():
        return json.loads(machine.succeed(f"curl --fail -s {base}/internalapi/config"))["main"]["apiKey"]

    def check_api(key):
        caps = machine.succeed(f"curl --fail -s '{base}/api?t=caps&apikey={key}'")
        assert "<caps " in caps, f"unexpected caps response: {caps}"
        machine.succeed(f"curl --fail -s -H 'X-Api-Key: {key}' {base}/externalapi/v1/ping")

    machine.start()
    machine.wait_for_unit("nzbhydra2.service")
    machine.wait_for_open_port(5076)

    with subtest("React UI and its bundle are served"):
        index = machine.succeed(f"curl --fail -s {base}/")
        assert "static/react/assets/index.js" in index, "UI bundle is not referenced"
        for asset in ["index.js", "index.css"]:
            machine.succeed(f"curl --fail -s -o /dev/null {base}/static/react/assets/{asset}")

    with subtest("Newznab and external API answer"):
        key = api_key()
        check_api(key)
        machine.succeed(f"curl --fail -s {base}/v3/api-docs/externalapi | grep -q /externalapi/v1/ping")

    with subtest("Database is created in the data directory"):
        machine.succeed("test -s /var/lib/nzbhydra2/database/nzbhydra.mv.db")

    with subtest("State survives a restart"):
        machine.systemctl("restart nzbhydra2.service")
        machine.wait_until_succeeds(f"curl --fail -s {base}/internalapi/config")
        assert api_key() == key, "API key changed after restart"
        check_api(key)
  '';
}
