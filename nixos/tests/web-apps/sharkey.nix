{ lib, ... }:

let
  meilisearchKey = "TESTKEY-naXRkVX7nhvLaGOmGGuicDKxZAj0khEaoOZPeEZafv8w9j8V6aKb0NVdXRChL5kR";
in
{
  name = "sharkey";

  nodes.machine =
    { pkgs, ... }:
    {
      services.sharkey = {
        enable = true;
        setupMeilisearch = true;
        environmentFiles = [ "/run/secrets/sharkey-env" ];
        settings = {
          url = "http://exampleurl.invalid";
          meilisearch.index = "exampleurl_invalid";
        };
      };

      services.meilisearch.masterKeyEnvironmentFile = pkgs.writeText "meilisearch-key" ''
        MEILI_MASTER_KEY=${meilisearchKey}
      '';
    };

  testScript =
    let
      createIndexPayload = builtins.toJSON {
        description = "Sharkey API key";
        actions = [ "*" ];
        indexes = [ "exampleurl_invalid---notes" ];
        expiresAt = null;
      };
    in
    ''
      import json

      with subtest("Setting up Meilisearch API key and index"):
          machine.wait_for_unit("meilisearch.service")
          machine.wait_for_open_port(7700)

          json_body = '${createIndexPayload}'
          create_index_result = json.loads(machine.succeed(f"curl -s -X POST 'http://localhost:7700/keys' -H 'Content-Type: application/json' -H 'Authorization: Bearer ${meilisearchKey}' --data-binary '{json_body}'"))
          machine.succeed(f"mkdir /run/secrets; echo 'MK_CONFIG_MEILISEARCH_APIKEY={create_index_result["key"]}' > /run/secrets/sharkey-env")

      with subtest("Testing Sharkey is running and listening to HTTP requests"):
          machine.systemctl("restart sharkey")
          machine.wait_for_open_port(3000)

          machine.succeed("curl --fail http://localhost:3000")
    '';

  meta.maintainers = with lib.maintainers; [ srxl ];
}
