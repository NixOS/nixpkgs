import ./make-test-python.nix ({ pkgs, ... }:
let
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
  docs = ''
  {"datetime":"2024-05-04T02:36:41.017674444Z","git":"e6e1f087ce12065e44ed3b87b50784e6f9bcc2f9","hostname":"machine-1","level":"Info","message":"Got exception processing request: HTTP 404","location":"path/to/server.c:6444:32","source":""}
  {"datetime":"2024-05-05T02:36:41.017674444Z","git":"e6e1f087ce12065e44ed3b87b50784e6f9bcc2f9","hostname":"machine-1","level":"Info","message":"Got exception processing request: HTTP 404","location":"path/to/server.c:6444:32","source":""}
  {"datetime":"2024-05-06T02:36:41.017674444Z","git":"e6e1f087ce12065e44ed3b87b50784e6f9bcc2f9","hostname":"machine-2","level":"Info","message":"Got exception processing request: HTTP 404","location":"path/to/server.c:6444:32","source":""}'';

in {
  name = "quickwit";

  nodes.machine = { config, pkgs, ... }: {
    services.quickwit = {
      enable = true;
      settings = {
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("quickwit.service")
    machine.wait_for_open_port(7280)
    machine.succeed('curl --fail http://localhost:7280/api/v1/version')
    machine.succeed('${pkgs.quickwit}/bin/quickwit index create --index-config ${pkgs.writeText "index.yaml" index_yaml}')
    machine.succeed('${pkgs.quickwit}/bin/quickwit index ingest --index example_server_logs --input-path ${pkgs.writeText "docs.json" docs}')
    machine.succeed('${pkgs.quickwit}/bin/quickwit index search --index example_server_logs --query "404"')
    machine.succeed('curl --fail http://127.0.0.1:7280/api/v1/example_server_logs/search?query=404')

  '';
})
