import ./make-test.nix {
  name = "prometheus";

  nodes = {
    one = { config, pkgs, ... }: {
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
      };
    };
  };

  testScript = ''
    startAll;
    $one->waitForUnit("prometheus.service");
    $one->waitForOpenPort(9090);
    $one->succeed("curl -s http://127.0.0.1:9090/metrics");
  '';
}
