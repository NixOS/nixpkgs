{ pkgs, lib, ... }:
let
  listenAddress = "127.0.0.1";
  listenPort = 7700;
  apiUrl = "http://${listenAddress}:${toString listenPort}";
  uid = "movies";
  indexJSON = pkgs.writeText "index.json" (builtins.toJSON { inherit uid; });
  moviesJSON = pkgs.fetchurl {
    url = "https://github.com/meilisearch/meilisearch/raw/v0.23.1/datasets/movies/movies.json";
    sha256 = "1r3srld63dpmg9yrmysm6xl175661j5cspi93mk5q2wf8xwn50c5";
  };
in
{
  name = "meilisearch";
  meta.maintainers = with lib.maintainers; [ Br1ght0ne ];

  nodes.machine =
    { ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
        jq
      ];
      services.meilisearch = {
        enable = true;
        inherit listenAddress listenPort;
      };
    };

  testScript = ''
    import json

    start_all()

    machine.wait_for_unit("meilisearch")
    machine.wait_for_open_port(7700)

    def wait_task(cmd):
        response = json.loads(machine.succeed(cmd))
        task_uid = response["taskUid"]
        machine.wait_until_succeeds(
            f"curl ${apiUrl}/tasks/{task_uid} | jq -e '.status | IN(\"succeeded\", \"failed\", \"canceled\")'"
        )
        machine.succeed(f"curl ${apiUrl}/tasks/{task_uid} | jq -e '.status == \"succeeded\"'")
        return response

    with subtest("check version"):
        version = json.loads(machine.succeed("curl ${apiUrl}/version"))
        assert version["pkgVersion"] == "${pkgs.meilisearch.version}"

    with subtest("create index"):
        wait_task("curl -X POST -H 'Content-Type: application/json' ${apiUrl}/indexes --data @${indexJSON}")
        indexes = json.loads(machine.succeed("curl ${apiUrl}/indexes"))
        assert indexes["total"] == 1, "index wasn't created"

    with subtest("add documents"):
        wait_task("curl -X POST -H 'Content-Type: application/json' ${apiUrl}/indexes/${uid}/documents --data-binary @${moviesJSON}")

    with subtest("search"):
        response = json.loads(
            machine.succeed("curl ${apiUrl}/indexes/movies/search?q=hero")
        )
        print(response)
        assert len(response["hits"]) >= 1, "no results found"
  '';
}
