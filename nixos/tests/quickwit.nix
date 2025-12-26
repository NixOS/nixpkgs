{ lib, pkgs, ... }:

let
  # Define an example Quickwit index schema,
  # and some `exampleDocs` below, to test if ingesting
  # and querying works as expected.
  index_yaml = ''
    version: 0.7
    index_id: example_server_logs
    doc_mapping:
      mode: dynamic
      field_mappings:
        - name: datetime
          type: datetime
          fast: true
          input_formats:
            - iso8601
          output_format: iso8601
          fast_precision: seconds
          fast: true
        - name: git
          type: text
          tokenizer: raw
        - name: hostname
          type: text
          tokenizer: raw
        - name: level
          type: text
          tokenizer: raw
        - name: message
          type: text
        - name: location
          type: text
        - name: source
          type: text
      timestamp_field: datetime

    search_settings:
      default_search_fields: [message]

    indexing_settings:
      commit_timeout_secs: 10
  '';

  exampleDocs = ''
    {"datetime":"2024-05-03T02:36:41.017674444Z","git":"e6e1f087ce12065e44ed3b87b50784e6f9bcc2f9","hostname":"machine-1","level":"Info","message":"Processing request done","location":"path/to/server.c:6442:32","source":""}
    {"datetime":"2024-05-04T02:36:41.017674444Z","git":"e6e1f087ce12065e44ed3b87b50784e6f9bcc2f9","hostname":"machine-1","level":"Info","message":"Got exception processing request: HTTP 404","location":"path/to/server.c:6444:32","source":""}
    {"datetime":"2024-05-05T02:36:41.017674444Z","git":"e6e1f087ce12065e44ed3b87b50784e6f9bcc2f9","hostname":"machine-1","level":"Info","message":"Got exception processing request: HTTP 404","location":"path/to/server.c:6444:32","source":""}
    {"datetime":"2024-05-06T02:36:41.017674444Z","git":"e6e1f087ce12065e44ed3b87b50784e6f9bcc2f9","hostname":"machine-2","level":"Info","message":"Got exception processing request: HTTP 404","location":"path/to/server.c:6444:32","source":""}
  '';
in
{
  name = "quickwit";
  meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

  nodes = {
    quickwit =
      { config, pkgs, ... }:
      {
        services.quickwit.enable = true;
      };
  };

  testScript = ''
    quickwit.wait_for_unit("quickwit")
    quickwit.wait_for_open_port(7280)
    quickwit.wait_for_open_port(7281)

    quickwit.wait_until_succeeds(
      "journalctl -o cat -u quickwit.service | grep 'version: ${pkgs.quickwit.version}'"
    )

    quickwit.wait_until_succeeds(
      "journalctl -o cat -u quickwit.service | grep 'transitioned to ready state'"
    )

    with subtest("verify UI installed"):
      machine.succeed("curl -sSf http://127.0.0.1:7280/ui/")

    with subtest("injest and query data"):
      import json

      # Test CLI ingestion
      print(machine.succeed('${pkgs.quickwit}/bin/quickwit index create --index-config ${pkgs.writeText "index.yaml" index_yaml}'))
      # Important to use `--wait`, otherwise the queries below race with index processing.
      print(machine.succeed('${pkgs.quickwit}/bin/quickwit index ingest --index example_server_logs --input-path ${pkgs.writeText "exampleDocs.json" exampleDocs} --wait'))

      # Test CLI query
      cli_query_output = machine.succeed('${pkgs.quickwit}/bin/quickwit index search --index example_server_logs --query "exception"')
      print(cli_query_output)

      # Assert query result is as expected.
      num_hits = len(json.loads(cli_query_output)["hits"])
      assert num_hits == 3, f"cli_query_output contains unexpected number of results: {num_hits}"

      # Test API query
      api_query_output = machine.succeed('curl --fail http://127.0.0.1:7280/api/v1/example_server_logs/search?query=exception')
      print(api_query_output)

    quickwit.log(quickwit.succeed(
      "systemd-analyze security quickwit.service | grep -v '✓'"
    ))
  '';
}
