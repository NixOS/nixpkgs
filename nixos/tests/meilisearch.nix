import ./make-test-python.nix ({ pkgs, lib, ... }:
  let
    listenAddress = "127.0.0.1";
    listenPort = 7700;
    apiUrl = "http://${listenAddress}:${toString listenPort}";
    uid = "movies";
    indexJSON = pkgs.writeText "index.json" (builtins.toJSON { inherit uid; });
    moviesJSON = pkgs.runCommand "movies.json" {} ''
      sed -n '1,5p;$p' ${pkgs.meilisearch.src}/datasets/movies/movies.json > $out
    '';
  in {
    name = "meilisearch";
    meta.maintainers = with lib.maintainers; [ Br1ght0ne ];

    machine = { ... }: {
      environment.systemPackages = with pkgs; [ curl jq ];
      services.meilisearch = {
        enable = true;
        inherit listenAddress listenPort;
      };
    };

    testScript = ''
      import json

      start_all()

      machine.wait_for_unit("meilisearch")
      machine.wait_for_open_port("7700")

      with subtest("check version"):
          version = json.loads(machine.succeed("curl ${apiUrl}/version"))
          assert version["pkgVersion"] == "${pkgs.meilisearch.version}"

      with subtest("create index"):
          machine.succeed(
              "curl -XPOST ${apiUrl}/indexes --data @${indexJSON}"
          )
          indexes = json.loads(machine.succeed("curl ${apiUrl}/indexes"))
          assert len(indexes) == 1, "index wasn't created"

      with subtest("add documents"):
          response = json.loads(
              machine.succeed(
                  "curl -XPOST ${apiUrl}/indexes/${uid}/documents --data @${moviesJSON}"
              )
          )
          update_id = response["updateId"]
          machine.wait_until_succeeds(
              f"curl ${apiUrl}/indexes/${uid}/updates/{update_id} | jq -e '.status == \"processed\"'"
          )

      with subtest("search"):
          response = json.loads(
              machine.succeed("curl ${apiUrl}/indexes/movies/search?q=hero")
          )
          print(response)
          assert len(response["hits"]) >= 1, "no results found"
    '';
  })
