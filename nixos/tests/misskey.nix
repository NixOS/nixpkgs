{ pkgs, lib, ... }:
let
  port = 61812;
  meiliMasterKey = "random-unsecure-test-master-key-10101010101";
  meiliKeyFile = pkgs.writeText "meili-key" meiliMasterKey;
in
{
  name = "misskey";

  meta.maintainers = [ lib.maintainers.feathecutie ];

  nodes.machine = {
    services.meilisearch.masterKeyFile = meiliKeyFile;

    services.misskey = {
      enable = true;
      settings = {
        url = "http://misskey.local";
        inherit port;
      };
      database.createLocally = true;
      redis.createLocally = true;
      meilisearch = {
        createLocally = true;
        keyFile = meiliKeyFile;
      };
    };
  };

  testScript = ''
    import json

    machine.wait_for_unit("meilisearch.service")
    machine.wait_for_unit("misskey.service")
    machine.wait_for_open_port(7700)
    machine.wait_for_open_port(${toString port})

    machine.succeed("curl --fail http://localhost:${toString port}/")

    meili_url = "http://localhost:7700"
    meili_auth = "-H 'Authorization: Bearer ${meiliMasterKey}'"

    def misskey_cmd(endpoint, data, token=None):
        auth = f"-H 'Authorization: Bearer {token}' " if token else ""
        return f"curl -fsS -H 'Content-Type: application/json' {auth}-d '{json.dumps(data)}' http://localhost:${toString port}/api/{endpoint}"

    def misskey_post(endpoint, data, token=None):
        output = machine.succeed(misskey_cmd(endpoint, data, token))
        return json.loads(output) if output.strip() else {}

    # check meilisearch is protected
    machine.fail(f"curl --fail {meili_url}/indexes")
    machine.wait_until_succeeds(f"curl --fail {meili_auth} {meili_url}/indexes/misskey---notes")

    # login as admin
    token = misskey_post("admin/accounts/create", {"username": "admin", "password": "nixosTestPassword123"})["token"]
    misskey_post("admin/roles/update-default-policies", {"policies": {"canSearchNotes": True}}, token)

    # create and verify a note can be accessed from search
    note_text = "hello fulltext nixos meilisearch"
    misskey_post("notes/create", {"text": note_text}, token)
    machine.wait_until_succeeds(f"curl -fsS {meili_auth} '{meili_url}/indexes/misskey---notes/search?q=meilisearch' | grep -q '{note_text}'")
    search_cmd = misskey_cmd("notes/search", {"query": "meilisearch"}, token)
    machine.wait_until_succeeds(f"{search_cmd} | grep -q '{note_text}'")
  '';
}
