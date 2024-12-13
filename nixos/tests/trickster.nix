import ./make-test-python.nix ({ pkgs, ... }: {
  name = "trickster";
  meta = with pkgs.lib; {
    maintainers = with maintainers; [ _1000101 ];
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
    start_all()
    prometheus.wait_for_unit("prometheus.service")
    prometheus.wait_for_open_port(9090)
    prometheus.wait_until_succeeds(
        "curl -fL http://localhost:9090/metrics | grep 'promhttp_metric_handler_requests_total{code=\"500\"} 0'"
    )
    trickster.wait_for_unit("trickster.service")
    trickster.wait_for_open_port(8082)
    trickster.wait_for_open_port(9090)
    trickster.wait_until_succeeds(
        "curl -fL http://localhost:8082/metrics | grep 'promhttp_metric_handler_requests_total{code=\"500\"} 0'"
    )
    trickster.wait_until_succeeds(
        "curl -fL http://prometheus:9090/metrics | grep 'promhttp_metric_handler_requests_total{code=\"500\"} 0'"
    )
    trickster.wait_until_succeeds(
        "curl -fL http://localhost:9090/metrics | grep 'promhttp_metric_handler_requests_total{code=\"500\"} 0'"
    )
  '';
})
