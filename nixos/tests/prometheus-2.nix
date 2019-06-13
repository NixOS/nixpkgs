import ./make-test.nix {
  name = "prometheus-2";

  nodes = {
    one = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.jq ];
      services.prometheus2 = {
        enable = true;
        scrapeConfigs = [
          {
            job_name = "prometheus";
            static_configs = [
              {
                targets = [ "127.0.0.1:9090" ];
                labels = { instance = "localhost"; };
              }
            ];
          }
          {
            job_name = "pushgateway";
            scrape_interval = "1s";
            static_configs = [
              {
                targets = [ "127.0.0.1:9091" ];
              }
            ];
          }
        ];
        rules = [
          ''
            groups:
              - name: test
                rules:
                  - record: testrule
                    expr: count(up{job="prometheus"})
          ''
        ];
      };
      services.prometheus.pushgateway = {
        enable = true;
        persistMetrics = true;
        persistence.interval = "1s";
        stateDir = "prometheus-pushgateway";
      };
    };
  };

  testScript = ''
    startAll;
    $one->waitForUnit("prometheus2.service");
    $one->waitForOpenPort(9090);
    $one->succeed("curl -s http://127.0.0.1:9090/metrics");

    # Let's test if pushing a metric to the pushgateway succeeds
    # and whether that metric gets ingested by prometheus.
    $one->waitForUnit("pushgateway.service");
    $one->succeed(
      "echo 'some_metric 3.14' | " .
      "curl --data-binary \@- http://127.0.0.1:9091/metrics/job/some_job");
    $one->waitUntilSucceeds(
      "curl -sf 'http://127.0.0.1:9090/api/v1/query?query=some_metric' " .
      "| jq '.data.result[0].value[1]' | grep '\"3.14\"'");

    # Let's test if the pushgateway persists metrics to the configured location.
    $one->waitUntilSucceeds("test -e /var/lib/prometheus-pushgateway/metrics");
  '';
}
