# nix-build -A nixosTests.elk.ELK-8

{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

let
  inherit (pkgs) lib;

  esUrl = "https://localhost:9200";
  hosts = [ esUrl ];
  username = "elastic";
  password = "changeme";
  esCerts =
    pkgs.runCommand "elk-test-certs" { nativeBuildInputs = [ pkgs.minica pkgs.openssl ]; }
      ''
        minica --ca-cert ca.pem --ca-key ca-key.pem \
          --domains localhost --ip-addresses 127.0.0.1

        mkdir -p $out
        cp ca.pem $out/ca.pem
        openssl pkcs12 -export -out $out/http.p12 \
          -inkey localhost/key.pem -in localhost/cert.pem \
          -passout pass:
      '';
  caPath = "${esCerts}/ca.pem";
  curlAuth = "--cacert ${caPath} -u elastic:${password}";
  ssl.certificate_authorities = [ caPath ];

  mkElkTest =
    name: elk:
    import ./make-test-python.nix {
      inherit name;
      meta = with pkgs.lib.maintainers; {
        maintainers = [
          basvandijk
        ];
      };
      nodes = {
        one =
          { pkgs, ... }:
          {
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
                  output.elasticsearch = {
                    inherit hosts password ssl username;
                  };
                };
              };

              metricbeat = {
                enable = true;
                package = elk.metricbeat;
                modules.system = {
                  metricsets = [
                    "cpu"
                    "load"
                    "memory"
                    "network"
                    "process"
                    "process_summary"
                    "uptime"
                    "socket_summary"
                  ];
                  enabled = true;
                  period = "5s";
                  processes = [ ".*" ];
                  cpu.metrics = [
                    "percentages"
                    "normalized_percentages"
                  ];
                  core.metrics = [ "percentages" ];
                };
                settings = {
                  output.elasticsearch = {
                    inherit hosts password ssl username;
                  };
                };
              };

              logstash = {
                enable = true;
                package = elk.logstash;
                # The NixOS module runs logstash as root, which logstash 8+
                # refuses by default.
                extraSettings = ''
                  allow_superuser: true
                '';
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
                    user => "${username}"
                    password => "${password}"
                    ssl_enabled => true
                    ssl_certificate_authorities => [ "${caPath}" ]
                  }
                '';
              };

              elasticsearch = {
                enable = true;
                package = elk.elasticsearch;
                # HTTPS without transport TLS (use loopback)
                extraConf = ''
                  xpack.security.enabled: true
                  xpack.security.enrollment.enabled: false
                  xpack.security.http.ssl.enabled: true
                  xpack.security.http.ssl.keystore.path: http.p12
                  xpack.security.transport.ssl.enabled: false
                '';
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

            # Provision keystore + password
            systemd.services.elasticsearch.preStart = lib.mkAfter ''
              cp ${esCerts}/http.p12 /var/lib/elasticsearch/config/http.p12
              echo -n '${password}' \
                | ${elk.elasticsearch}/bin/elasticsearch-keystore add -x -f bootstrap.password
              chown -R elasticsearch:elasticsearch /var/lib/elasticsearch/config
            '';
          };
      };

      passthru.elkPackages = elk;
      testScript = ''
        import json


        def expect_hits(message):
            dictionary = {"query": {"match": {"message": message}}}
            return (
                "curl --silent --show-error --fail-with-body ${curlAuth} '${esUrl}/_search' "
                + "-H 'Content-Type: application/json' "
                + "-d '{}' ".format(json.dumps(dictionary))
                + " | tee /dev/console"
                + " | jq -es 'if . == [] then null else .[] | .hits.total.value > 0 end'"
            )


        def expect_no_hits(message):
            dictionary = {"query": {"match": {"message": message}}}
            return (
                "curl --silent --show-error --fail-with-body ${curlAuth} '${esUrl}/_search' "
                + "-H 'Content-Type: application/json' "
                + "-d '{}' ".format(json.dumps(dictionary))
                + " | tee /dev/console"
                + " | jq -es 'if . == [] then null else .[] | .hits.total.value == 0 end'"
            )


        def has_metricbeat():
            dictionary = {"query": {"match": {"event.dataset": {"query": "system.cpu"}}}}
            return (
                "curl --silent --show-error --fail-with-body ${curlAuth} '${esUrl}/_search' "
                + "-H 'Content-Type: application/json' "
                + "-d '{}' ".format(json.dumps(dictionary))
                + " | tee /dev/console"
                + " | jq -es 'if . == [] then null else .[] | .hits.total.value > 0 end'"
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
            "curl --silent --show-error --fail-with-body ${curlAuth} '${esUrl}/_cluster/health'"
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

      ''
      + lib.optionalString (elk ? filebeat) ''
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
      ''
      + lib.optionalString (elk ? elasticsearch-curator) ''
        with subtest("Elasticsearch-curator works"):
            one.systemctl("stop logstash")
            one.systemctl("start elasticsearch-curator")
            one.wait_until_succeeds(
                '! curl --silent --show-error --fail-with-body ${curlAuth} "${esUrl}/_cat/indices" | grep logstash | grep ^'
            )
      '';
    } { inherit pkgs system; };
in
{
  ELK-8 = mkElkTest "elk-8" {
    elasticsearch = pkgs.elasticsearch8;
    logstash = pkgs.logstash8;
    filebeat = pkgs.filebeat8;
    metricbeat = pkgs.metricbeat8;
  };
}
