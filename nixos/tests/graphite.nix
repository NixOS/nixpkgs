import ./make-test.nix ({ pkgs, ...} :
{
  name = "graphite";
  nodes = {
    one =
      { config, pkgs, ... }: {
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
    $one->requireActiveUnit("graphiteWeb.service");
    $one->requireActiveUnit("graphiteApi.service");
    $one->requireActiveUnit("graphitePager.service");
    $one->requireActiveUnit("carbonCache.service");
    $one->requireActiveUnit("seyren.service");
    $one->succeed("echo \"foo 1 `date +%s`\" | nc -q0 localhost 2003");
    $one->waitUntilSucceeds("curl 'http://localhost:8080/metrics/find/?query=foo&format=treejson' --silent | grep foo")
  '';
})
