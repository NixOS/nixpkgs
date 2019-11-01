import ./make-test.nix ({ pkgs, ... }: {
  name = "trickster";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ "1000101" ];
  };

  nodes = {
    prometheus = { ... }: {
      services.prometheus.enable = true;
      networking.firewall.allowedTCPPorts = [ 9090 ];
    };
    trickster = { ... }: {
      services.trickster.enable = true;
    };
  };

  testScript = ''
    startAll;
    $prometheus->waitForUnit("prometheus.service");
    $prometheus->waitForOpenPort(9090);
    $prometheus->waitUntilSucceeds("curl -L http://localhost:9090/metrics | grep 'promhttp_metric_handler_requests_total{code=\"500\"} 0'");
    $trickster->waitForUnit("trickster.service");
    $trickster->waitForOpenPort(8082);
    $trickster->waitForOpenPort(9090);
    $trickster->waitUntilSucceeds("curl -L http://localhost:8082/metrics | grep 'promhttp_metric_handler_requests_total{code=\"500\"} 0'");
    $trickster->waitUntilSucceeds("curl -L http://prometheus:9090/metrics | grep 'promhttp_metric_handler_requests_total{code=\"500\"} 0'");
    $trickster->waitUntilSucceeds("curl -L http://localhost:9090/metrics | grep 'promhttp_metric_handler_requests_total{code=\"500\"} 0'");
  '';
})