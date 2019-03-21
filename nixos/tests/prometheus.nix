import ./make-test.nix {
  name = "prometheus";

  nodes = {
    one = { ... }: {
      services.prometheus = {
        enable = true;
        scrapeConfigs = [{
          job_name = "prometheus";
          static_configs = [{
            targets = [ "127.0.0.1:9090" ];
            labels = { instance = "localhost"; };
          }];
        }];
        rules = [ ''testrule = count(up{job="prometheus"})'' ];

        # a very simple version of the alertmanager configuration just to see if
        # configuration checks & service startup are working
        alertmanager = {
          enable = true;
          listenAddress = "[::1]";
          port = 9093;
          configuration = {
            route.receiver = "webhook";
            receivers = [
              {
                name = "webhook";
                webhook_configs = [
                  { url = "http://localhost"; }
                ];
              }
            ];
          };
        };
      };
    };
  };

  testScript = ''
    startAll;
    $one->waitForUnit("prometheus.service");
    $one->waitForOpenPort(9090);
    $one->succeed("curl -s http://127.0.0.1:9090/metrics");
    $one->waitForUnit("alertmanager.service");
    $one->waitForOpenPort("9093");
    $one->succeed("curl -f -s http://localhost:9093/");
  '';
}
