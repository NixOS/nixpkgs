{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; },
  enableUnfree ? false
  # To run the test on the unfree ELK use the folllowing command:
  # NIXPKGS_ALLOW_UNFREE=1 nix-build nixos/tests/elk.nix -A ELK-6 --arg enableUnfree true
}:

let
  esUrl = "http://localhost:9200";

  mkElkTest = name : elk :
    import ./make-test-python.nix ({
    inherit name;
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ eelco offline basvandijk ];
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

              journalbeat = let lt6 = builtins.compareVersions
                                        elk.journalbeat.version "6" < 0; in {
                enable = true;
                package = elk.journalbeat;
                extraConfig = pkgs.lib.mkOptionDefault (''
                  logging:
                    to_syslog: true
                    level: warning
                    metrics.enabled: false
                  output.elasticsearch:
                    hosts: [ "127.0.0.1:9200" ]
                    ${pkgs.lib.optionalString lt6 "template.enabled: false"}
                '' + pkgs.lib.optionalString (!lt6) ''
                  journalbeat.inputs:
                  - paths: []
                    seek: cursor
                '');
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

              kibana = {
                enable = true;
                package = elk.kibana;
              };

              elasticsearch-curator = {
                enable = true;
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

    testScript = ''
      import json


      def total_hits(message):
          dictionary = {"query": {"match": {"message": message}}}
          return (
              "curl --silent --show-error '${esUrl}/_search' "
              + "-H 'Content-Type: application/json' "
              + "-d '{}' ".format(json.dumps(dictionary))
              + "| jq .hits.total"
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
          "curl --silent --show-error '${esUrl}/_cluster/health' | jq .status | grep -v red"
      )

      with subtest("Perform some simple logstash tests"):
          one.wait_for_unit("logstash.service")
          one.wait_until_succeeds("cat /tmp/logstash.out | grep flowers")
          one.wait_until_succeeds("cat /tmp/logstash.out | grep -v dragons")

      with subtest("Kibana is healthy"):
          one.wait_for_unit("kibana.service")
          one.wait_until_succeeds(
              "curl --silent --show-error 'http://localhost:5601/api/status' | jq .status.overall.state | grep green"
          )

      with subtest("Logstash messages arive in elasticsearch"):
          one.wait_until_succeeds(total_hits("flowers") + " | grep -v 0")
          one.wait_until_succeeds(total_hits("dragons") + " | grep 0")

      with subtest(
          "A message logged to the journal is ingested by elasticsearch via journalbeat"
      ):
          one.wait_for_unit("journalbeat.service")
          one.execute("echo 'Supercalifragilisticexpialidocious' | systemd-cat")
          one.wait_until_succeeds(
              total_hits("Supercalifragilisticexpialidocious") + " | grep -v 0"
          )

      with subtest("Elasticsearch-curator works"):
          one.systemctl("stop logstash")
          one.systemctl("start elasticsearch-curator")
          one.wait_until_succeeds(
              '! curl --silent --show-error "${esUrl}/_cat/indices" | grep logstash | grep -q ^'
          )
    '';
  }) {};
in pkgs.lib.mapAttrs mkElkTest {
  ELK-6 =
    if enableUnfree
    then {
      elasticsearch = pkgs.elasticsearch6;
      logstash      = pkgs.logstash6;
      kibana        = pkgs.kibana6;
      journalbeat   = pkgs.journalbeat6;
    }
    else {
      elasticsearch = pkgs.elasticsearch6-oss;
      logstash      = pkgs.logstash6-oss;
      kibana        = pkgs.kibana6-oss;
      journalbeat   = pkgs.journalbeat6;
    };
  ELK-7 =
    if enableUnfree
    then {
      elasticsearch = pkgs.elasticsearch7;
      logstash      = pkgs.logstash7;
      kibana        = pkgs.kibana7;
      journalbeat   = pkgs.journalbeat7;
    }
    else {
      elasticsearch = pkgs.elasticsearch7-oss;
      logstash      = pkgs.logstash7-oss;
      kibana        = pkgs.kibana7-oss;
      journalbeat   = pkgs.journalbeat7;
    };
}
