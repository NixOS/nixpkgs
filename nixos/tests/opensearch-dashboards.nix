import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "opensearch-dashboards";
    meta.maintainers = [ ];

    nodes.machine = {
      virtualisation.memorySize = 4096;

      services.opensearch = {
        enable = true;
        # security is disabled by default
      };

      services.opensearch-dashboards = {
        enable = true;
        package = pkgs.opensearch-dashboards.override {
          disableSecurity = true;
        };
        settings = {
          server.host = "0.0.0.0";
          server.port = 5601;
          opensearch.hosts = [ "http://localhost:9200" ];
        };
      };
    };

    testScript = ''
      import json
      import shlex

      machine.start()

      with subtest("opensearch starts and is reachable"):
          machine.wait_for_unit("opensearch.service")
          machine.wait_for_open_port(9200)
          machine.succeed("curl --fail http://localhost:9200/")

      with subtest("opensearch-dashboards starts and is reachable"):
          machine.wait_for_unit("opensearch-dashboards.service")
          machine.wait_for_open_port(5601)
          # Dashboards takes a while to fully initialize
          machine.wait_until_succeeds(
              "curl --fail -s http://localhost:5601/api/status"
              " | grep -q '\"state\":\"green\"'",
              timeout=120,
          )

      with subtest("inject logs into opensearch"):
          # Create an index with timestamped log entries
          for i in range(5):
              doc = json.dumps({
                  "@timestamp": f"2026-04-14T10:00:0{i}Z",
                  "message": f"test log entry {i}",
                  "level": "info",
                  "service": "vmtest",
              })
              machine.succeed(
                  "curl --fail -s -X POST http://localhost:9200/test-logs/_doc"
                  f" -H 'Content-Type: application/json' -d {shlex.quote(doc)}"
              )

          # Refresh the index so documents are searchable
          machine.succeed(
              "curl --fail -s -X POST http://localhost:9200/test-logs/_refresh"
          )

          # Verify documents are in opensearch
          result = machine.succeed(
              "curl --fail -s http://localhost:9200/test-logs/_count"
          )
          count = json.loads(result)["count"]
          assert count == 5, f"Expected 5 documents, got {count}"

      with subtest("create index pattern in dashboards"):
          payload = json.dumps({
              "attributes": {
                  "title": "test-logs*",
                  "timeFieldName": "@timestamp",
              }
          })
          machine.succeed(
              "curl --fail -s -X POST"
              " http://localhost:5601/api/saved_objects/index-pattern/test-logs"
              " -H 'osd-xsrf: true'"
              f" -H 'Content-Type: application/json' -d {shlex.quote(payload)}"
          )

      with subtest("query logs through dashboards discover search"):
          # Use the internal search API that the Discover view uses
          query = json.dumps({
              "params": {
                  "index": "test-logs*",
                  "body": {
                      "query": {"match_all": {}},
                      "size": 10,
                  },
              }
          })
          result = machine.succeed(
              "curl --fail -s -X POST"
              " http://localhost:5601/internal/search/opensearch"
              " -H 'osd-xsrf: true'"
              f" -H 'Content-Type: application/json' -d {shlex.quote(query)}"
          )
          data = json.loads(result)
          hits = data["rawResponse"]["hits"]["hits"]
          assert len(hits) == 5, f"Expected 5 hits from dashboards, got {len(hits)}"

          # Verify the log messages are present
          messages = sorted([h["_source"]["message"] for h in hits])
          for i in range(5):
              expected = f"test log entry {i}"
              assert expected in messages, f"Missing log entry: {expected}"
    '';
  }
)
