import ./make-test.nix ({ pkgs, ...} :
{
  name = "graphite";
  nodes = {
    one =
      { config, pkgs, ... }: {
        virtualisation.memorySize = 1024;
        time.timeZone = "UTC";
        services.graphite = {
          web.enable = true;
          api = {
            enable = true;
            port = 8082;
          };
          carbon.enableCache = true;
          seyren.enable = true;
          pager.enable = true;
        };
      };
  };

  testScript = ''
    startAll;
    $one->waitForUnit("default.target");
    $one->waitForUnit("graphiteWeb.service");
    $one->waitForUnit("graphiteApi.service");
    $one->waitForUnit("graphitePager.service");
    $one->waitForUnit("carbonCache.service");
    $one->waitForUnit("seyren.service");
    # The services above are of type "simple". systemd considers them active immediately
    # even if they're still in preStart (which takes quite long for graphiteWeb).
    # Wait for ports to open so we're sure the services are up and listening.
    $one->waitForOpenPort(8080);
    $one->waitForOpenPort(2003);
    $one->succeed("echo \"foo 1 `date +%s`\" | nc -N localhost 2003");
    $one->waitUntilSucceeds("curl 'http://localhost:8080/metrics/find/?query=foo&format=treejson' --silent | grep foo >&2");
  '';
})
