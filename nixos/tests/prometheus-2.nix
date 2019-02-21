import ./make-test.nix {
  name = "prometheus-2";

  nodes = {
    one = { pkgs, ... }: {
      services.prometheus2 = {
        enable = true;
        scrapeConfigs = [{
          job_name = "prometheus";
          static_configs = [{
            targets = [ "127.0.0.1:9090" ];
            labels = { instance = "localhost"; };
          }];
        }];
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
    };
  };

  testScript = ''
    startAll;
    $one->waitForUnit("prometheus2.service");
    $one->waitForOpenPort(9090);
    $one->succeed("curl -s http://127.0.0.1:9090/metrics");
  '';
}
