import ./make-test-python.nix ({ pkgs, ... } :
{
  name = "graphite";
  nodes = {
    one =
      { ... }: {
        virtualisation.memorySize = 1024;
        time.timeZone = "UTC";
        services.graphite = {
          web = {
            enable = true;
            extraConfig = ''
              SECRET_KEY = "abcd";
            '';
          };
          api = {
            enable = true;
            port = 8082;
            finders = [ ];
          };
          carbon.enableCache = true;
          seyren.enable = false;  # Implicitely requires openssl-1.0.2u which is marked insecure
          beacon.enable = true;
        };
      };
  };

  testScript = ''
    start_all()
    one.wait_for_unit("default.target")
    one.wait_for_unit("graphiteWeb.service")
    one.wait_for_unit("graphiteApi.service")
    one.wait_for_unit("graphite-beacon.service")
    one.wait_for_unit("carbonCache.service")
    # The services above are of type "simple". systemd considers them active immediately
    # even if they're still in preStart (which takes quite long for graphiteWeb).
    # Wait for ports to open so we're sure the services are up and listening.
    one.wait_for_open_port(8080)
    one.wait_for_open_port(8082)
    one.wait_for_open_port(2003)
    one.succeed('echo "foo 1 `date +%s`" | nc -N localhost 2003')
    one.wait_until_succeeds(
        "curl 'http://localhost:8080/metrics/find/?query=foo&format=treejson' --silent | grep foo >&2"
    )
    one.wait_until_succeeds(
        "curl 'http://localhost:8082/metrics/find/?query=foo&format=treejson' --silent | grep foo >&2"
    )
  '';
})
