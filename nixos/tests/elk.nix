# Test the ELK stack: Elasticsearch, Logstash and Kibana.

import ./make-test.nix ({ pkgs, ...} :
let
  esUrl = "http://localhost:9200";
in {
  name = "ELK";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco chaoflow offline basvandijk ];
  };

  nodes = {
    one =
      { config, pkgs, ... }: {
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
            logstash = {
              enable = true;
              package = pkgs.logstash5;
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
              package = pkgs.elasticsearch5;
            };

            kibana = {
              enable = true;
              package = pkgs.kibana5;
              elasticsearch.url = esUrl;
            };
          };
        };
    };

  testScript = ''
    startAll;

    $one->waitForUnit("elasticsearch.service");

    # Continue as long as the status is not "red". The status is probably
    # "yellow" instead of "green" because we are using a single elasticsearch
    # node which elasticsearch considers risky.
    #
    # TODO: extend this test with multiple elasticsearch nodes and see if the status turns "green".
    $one->waitUntilSucceeds("curl --silent --show-error '${esUrl}/_cluster/health' | jq .status | grep -v red");

    # Perform some simple logstash tests.
    $one->waitForUnit("logstash.service");
    $one->waitUntilSucceeds("cat /tmp/logstash.out | grep flowers");
    $one->waitUntilSucceeds("cat /tmp/logstash.out | grep -v dragons");

    # See if kibana is healthy.
    $one->waitForUnit("kibana.service");
    $one->waitUntilSucceeds("curl --silent --show-error 'http://localhost:5601/api/status' | jq .status.overall.state | grep green");

    # See if logstash messages arive in elasticsearch.
    $one->waitUntilSucceeds("curl --silent --show-error '${esUrl}/_search' -H 'Content-Type: application/json' -d '{\"query\" : { \"match\" : { \"message\" : \"flowers\"}}}' | jq .hits.total | grep -v 0");
    $one->waitUntilSucceeds("curl --silent --show-error '${esUrl}/_search' -H 'Content-Type: application/json' -d '{\"query\" : { \"match\" : { \"message\" : \"dragons\"}}}' | jq .hits.total | grep 0");
  '';
})
