# To run the test on the unfree ELK use the following command:
# cd path/to/nixpkgs
# NIXPKGS_ALLOW_UNFREE=1 nix-build -A nixosTests.elk.unfree.ELK-7

{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; },
}:

let
  inherit (pkgs) lib;

  esUrl = "http://localhost:9200";

  mkElkTest = name : elk :
    import ./make-test-python.nix ({
    inherit name;
    meta = with pkgs.lib.maintainers; {
      maintainers = [ offline basvandijk ];
    };
    nodes = {
      one =
        { pkgs, lib, ... }: {
            # Not giving the machine at least 2060MB results in elasticsearch failing with the following error:
            #
            #   OpenJDK 64-Bit Server VM warning:
            #     INFO: os::commit_memory(0x0000000085330000, 2060255232, 0)
            #     failed; error='Cannot allocate memory' (errno=12)
            #
            #   There is insufficient memory for the Java Runtime Environment to continue.
            #   Native memory allocation (mmap) failed to map 2060255232 bytes for committing reserved memory.
            #
            # When setting this to 2500 I got "Kernel panic - not syncing: Out of
            # memory: compulsory panic_on_oom is enabled" so lets give it even a
            # bit more room:
            virtualisation.memorySize = 3000;

            # For querying JSON objects returned from elasticsearch and kibana.
            environment.systemPackages = [ pkgs.jq ];

            services = {

              journalbeat = {
                enable = elk ? journalbeat;
                package = elk.journalbeat;
                extraConfig = pkgs.lib.mkOptionDefault (''
                  logging:
                    to_syslog: true
                    level: warning
                    metrics.enabled: false
                  output.elasticsearch:
                    hosts: [ "127.0.0.1:9200" ]
                  journalbeat.inputs:
                  - paths: []
                    seek: cursor
                '');
              };

              filebeat = {
                enable = elk ? filebeat;
                package = elk.filebeat;
                inputs.journald.id = "everything";

                inputs.log = {
                  enabled = true;
                  paths = [
                    "/var/lib/filebeat/test"
                  ];
                };

                settings = {
                  logging.level = "info";
                };
              };

              metricbeat = {
                enable = true;
                package = elk.metricbeat;
                modules.system = {
                  metricsets = ["cpu" "load" "memory" "network" "process" "process_summary" "uptime" "socket_summary"];
                  enabled = true;
                  period = "5s";
                  processes = [".*"];
                  cpu.metrics = ["percentages" "normalized_percentages"];
                  core.metrics = ["percentages"];
                };
                settings = {
                  output.elasticsearch = {
                    hosts = ["127.0.0.1:9200"];
                  };
                };
              };

              logstash = {
                enable = true;
                package = elk.logstash;
                inputConfig = ''
                  exec { command => "echo -n flowers" interval => 1 type => "test" }
                  exec { command => "echo -n dragons" interval => 1 type => "test" }
                '';
                filterConfig = ''
                  if [message] =~ /dragons/ {
                    drop {}
                  }
                '';
                outputConfig = ''
                  file {
                    path => "/tmp/logstash.out"
                    codec => line { format => "%{message}" }
                  }
                  elasticsearch {
                    hosts => [ "${esUrl}" ]
                  }
                '';
              };

              elasticsearch = {
                enable = true;
                package = elk.elasticsearch;
              };

              elasticsearch-curator = {
                enable = elk ? elasticsearch-curator;
                actionYAML = ''
                ---
                actions:
                  1:
                    action: delete_indices
                    description: >-
                      Delete indices older than 1 second (based on index name), for logstash-
                      prefixed indices. Ignore the error if the filter does not result in an
                      actionable list of indices (ignore_empty_list) and exit cleanly.
                    options:
                      allow_ilm_indices: true
                      ignore_empty_list: True
                      disable_action: False
                    filters:
                    - filtertype: pattern
                      kind: prefix
                      value: logstash-
                    - filtertype: age
                      source: name
                      direction: older
                      timestring: '%Y.%m.%d'
                      unit: seconds
                      unit_count: 1
                '';
              };
            };
          };
      };

    passthru.elkPackages = elk;
    testScript =
      let
        valueObject = lib.optionalString (lib.versionAtLeast elk.elasticsearch.version "7") ".value";
      in ''
      import json


      def expect_hits(message):
          dictionary = {"query": {"match": {"message": message}}}
          return (
              "curl --silent --show-error --fail-with-body '${esUrl}/_search' "
              + "-H 'Content-Type: application/json' "
              + "-d '{}' ".format(json.dumps(dictionary))
              + " | tee /dev/console"
              + " | jq -es 'if . == [] then null else .[] | .hits.total${valueObject} > 0 end'"
          )


      def expect_no_hits(message):
          dictionary = {"query": {"match": {"message": message}}}
          return (
              "curl --silent --show-error --fail-with-body '${esUrl}/_search' "
              + "-H 'Content-Type: application/json' "
              + "-d '{}' ".format(json.dumps(dictionary))
              + " | tee /dev/console"
              + " | jq -es 'if . == [] then null else .[] | .hits.total${valueObject} == 0 end'"
          )


      def has_metricbeat():
          dictionary = {"query": {"match": {"event.dataset": {"query": "system.cpu"}}}}
          return (
              "curl --silent --show-error --fail-with-body '${esUrl}/_search' "
              + "-H 'Content-Type: application/json' "
              + "-d '{}' ".format(json.dumps(dictionary))
              + " | tee /dev/console"
              + " | jq -es 'if . == [] then null else .[] | .hits.total${valueObject} > 0 end'"
          )


      start_all()

      one.wait_for_unit("elasticsearch.service")
      one.wait_for_open_port(9200)

      # Continue as long as the status is not "red". The status is probably
      # "yellow" instead of "green" because we are using a single elasticsearch
      # node which elasticsearch considers risky.
      #
      # TODO: extend this test with multiple elasticsearch nodes
      #       and see if the status turns "green".
      one.wait_until_succeeds(
          "curl --silent --show-error --fail-with-body '${esUrl}/_cluster/health'"
          + " | jq -es 'if . == [] then null else .[] | .status != \"red\" end'"
      )

      with subtest("Perform some simple logstash tests"):
          one.wait_for_unit("logstash.service")
          one.wait_until_succeeds("cat /tmp/logstash.out | grep flowers")
          one.wait_until_succeeds("cat /tmp/logstash.out | grep -v dragons")

      with subtest("Metricbeat is running"):
          one.wait_for_unit("metricbeat.service")

      with subtest("Metricbeat metrics arrive in elasticsearch"):
          one.wait_until_succeeds(has_metricbeat())

      with subtest("Logstash messages arive in elasticsearch"):
          one.wait_until_succeeds(expect_hits("flowers"))
          one.wait_until_succeeds(expect_no_hits("dragons"))

    '' + lib.optionalString (elk ? journalbeat) ''
      with subtest(
          "A message logged to the journal is ingested by elasticsearch via journalbeat"
      ):
          one.wait_for_unit("journalbeat.service")
          one.execute("echo 'Supercalifragilisticexpialidocious' | systemd-cat")
          one.wait_until_succeeds(
              expect_hits("Supercalifragilisticexpialidocious")
          )
    '' + lib.optionalString (elk ? filebeat) ''
      with subtest(
          "A message logged to the journal is ingested by elasticsearch via filebeat"
      ):
          one.wait_for_unit("filebeat.service")
          one.execute("echo 'Superdupercalifragilisticexpialidocious' | systemd-cat")
          one.wait_until_succeeds(
              expect_hits("Superdupercalifragilisticexpialidocious")
          )
          one.execute(
              "echo 'SuperdupercalifragilisticexpialidociousIndeed' >> /var/lib/filebeat/test"
          )
          one.wait_until_succeeds(
              expect_hits("SuperdupercalifragilisticexpialidociousIndeed")
          )
    '' + lib.optionalString (elk ? elasticsearch-curator) ''
      with subtest("Elasticsearch-curator works"):
          one.systemctl("stop logstash")
          one.systemctl("start elasticsearch-curator")
          one.wait_until_succeeds(
              '! curl --silent --show-error --fail-with-body "${esUrl}/_cat/indices" | grep logstash | grep ^'
          )
    '';
  }) { inherit pkgs system; };
in {
  # We currently only package upstream binaries.
  # Feel free to package an SSPL licensed source-based package!
  # ELK-7 = mkElkTest "elk-7-oss" {
  #   name = "elk-7";
  #   elasticsearch = pkgs.elasticsearch7-oss;
  #   logstash      = pkgs.logstash7-oss;
  #   filebeat      = pkgs.filebeat7;
  #   metricbeat    = pkgs.metricbeat7;
  # };
  unfree = lib.dontRecurseIntoAttrs {
    ELK-7 = mkElkTest "elk-7" {
      elasticsearch = pkgs.elasticsearch7;
      logstash      = pkgs.logstash7;
      filebeat      = pkgs.filebeat7;
      metricbeat    = pkgs.metricbeat7;
    };
  };
}
