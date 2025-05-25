import ./make-test-python.nix (
  { lib, ... }:

  {
    name = "prowlarr";
    meta.maintainers = with lib.maintainers; [ ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.prowlarr.enable = true;
      };

    testScript = ''
      import json
      from xml.etree import ElementTree
      machine.wait_for_unit("prowlarr.service")
      machine.wait_for_open_port(9696)
      response = machine.succeed("curl --fail http://localhost:9696/ping")
      assert json.loads(response)["status"] == "OK", "Ping API didn't reply with expected content"
      machine.succeed("[ -d /var/lib/prowlarr ]")
      xml = machine.succeed("cat /var/lib/prowlarr/config.xml")
      root = ElementTree.fromstring(xml)
      api_key = root.find("ApiKey").text
      machine.succeed(f"curl --fail -H 'Authorization: Bearer {api_key}' http://localhost:9696/api/v1/health")
    '';
  }
)
