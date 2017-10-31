import ./make-test.nix ({ pkgs, ...} :
{
  name = "graphite";
  nodes = {
    one =
      { config, pkgs, ... }: {
        services.graphite = {
          web = {
            enable = true;
          };
          carbon = {
            enableCache = true;
          };
        };
      };
    };

  testScript = ''
    startAll;
    $one->waitForUnit("default.target");
    $one->requireActiveUnit("graphiteWeb.service");
    $one->requireActiveUnit("carbonCache.service");
    $one->succeed("echo \"foo 1 `date +%s`\" | nc -q0 localhost 2003");
    $one->waitUntilSucceeds("curl 'http://localhost:8080/metrics/find/?query=foo&format=treejson' --silent | grep foo")
  '';
})
