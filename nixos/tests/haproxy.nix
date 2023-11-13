import ./make-test-python.nix ({ pkgs, ...}: {
  name = "haproxy";
  nodes = {
    machine = { ... }: {
      services.haproxy = {
        enable = true;
        config = ''
          defaults
            timeout connect 10s

          backend http_server
            mode http
            server httpd [::1]:8000

          frontend http
            bind *:80
            mode http
            http-request use-service prometheus-exporter if { path /metrics }
            use_backend http_server
        '';
      };
      services.httpd = {
        enable = true;
        virtualHosts.localhost = {
          documentRoot = pkgs.writeTextDir "index.txt" "We are all good!";
          adminAddr = "notme@yourhost.local";
          listen = [{
            ip = "::1";
            port = 8000;
          }];
        };
      };
    };
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("haproxy.service")
    machine.wait_for_unit("httpd.service")
    assert "We are all good!" in machine.succeed("curl -fk http://localhost:80/index.txt")
    assert "haproxy_process_pool_allocated_bytes" in machine.succeed(
        "curl -fk http://localhost:80/metrics"
    )

    with subtest("reload"):
        machine.succeed("systemctl reload haproxy")
        # wait some time to ensure the following request hits the reloaded haproxy
        machine.sleep(5)
        assert "We are all good!" in machine.succeed(
            "curl -fk http://localhost:80/index.txt"
        )
  '';
})
