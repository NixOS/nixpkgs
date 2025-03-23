{ config, lib, ... }:
let
  mainPort = "8080";
  webuiName = "NixOS Test";
in
{
  name = "open-webui";
  meta = with lib.maintainers; {
    maintainers = [ shivaraj-bh ];
  };

  nodes = {
    machine =
      { ... }:
      {
        services.open-webui = {
          enable = true;
          host = "";
          environment = {
            # Requires network connection
            RAG_EMBEDDING_MODEL = "";
          };

          # Test that environment variables can be
          # overridden through a file.
          environmentFile = config.node.pkgs.writeText "test.env" ''
            WEBUI_NAME="${webuiName}"
          '';
        };
      };
  };

  testScript = ''
    import json
    import xml.etree.ElementTree as xml

    machine.start()

    machine.wait_for_unit("open-webui.service")
    machine.wait_for_open_port(${mainPort})

    machine.succeed("curl http://127.0.0.1:${mainPort}")

    # Load the Web UI config JSON and parse it.
    webui_config_json = machine.succeed("curl http://127.0.0.1:${mainPort}/api/config")
    webui_config = json.loads(webui_config_json)

    # Check that the name was overridden via the environmentFile option.
    assert webui_config["name"] == "${webuiName} (Open WebUI)"

    webui_opensearch_xml = machine.succeed("curl http://127.0.0.1:${mainPort}/opensearch.xml")
    webui_opensearch = xml.fromstring(webui_opensearch_xml)

    webui_opensearch_url = webui_opensearch.find(
        ".//{http://a9.com/-/spec/opensearch/1.1/}Url"
    )
    assert (
        webui_opensearch_url is not None
    ), f"no url tag found in {webui_opensearch_xml}"
    assert (
        webui_opensearch_url.get("template") == "http://localhost:8080/?q={searchTerms}"
    ), "opensearch url doesn't match the configured port"
  '';
}
