import ./make-test-python.nix ({ pkgs, ... } :
{
  name = "graphite";
  meta = {
    # Fails on dependency `python-2.7-Twisted`'s test suite
    # complaining `ImportError: No module named zope.interface`.
    broken = true;
  };
  nodes = {
    one =
      { ... }: {
        virtualisation.memorySize = 1024;
        time.timeZone = "UTC";
        services.graphite = {
          web.enable = true;
          api = {
            enable = true;
            port = 8082;
            finders = [ pkgs.python27Packages.influxgraph ];
          };
          carbon.enableCache = true;
          seyren.enable = true;
          pager.enable = true;
          beacon.enable = true;
        };
      };
  };

  testScript = ''
    start_all()
    one.wait_for_unit("default.target")
    one.wait_for_unit("graphiteWeb.service")
    one.wait_for_unit("graphiteApi.service")
    one.wait_for_unit("graphitePager.service")
    one.wait_for_unit("graphite-beacon.service")
    one.wait_for_unit("carbonCache.service")
    one.wait_for_unit("seyren.service")
    # The services above are of type "simple". systemd considers them active immediately
    # even if they're still in preStart (which takes quite long for graphiteWeb).
    # Wait for ports to open so we're sure the services are up and listening.
    one.wait_for_open_port(8080)
    one.wait_for_open_port(2003)
    one.succeed('echo "foo 1 `date +%s`" | nc -N localhost 2003')
    one.wait_until_succeeds("curl 'http://localhost:8080/metrics/find/?query=foo&format=treejson' --silent | grep foo >&2")
  '';
})
