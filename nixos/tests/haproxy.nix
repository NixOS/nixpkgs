import ./make-test-python.nix ({ pkgs, ...}: {
  name = "haproxy";
  nodes = {
    machine = { ... }: {
      imports = [ ../modules/profiles/minimal.nix ];
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
            option http-use-htx
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
    assert "We are all good!" in machine.succeed("curl -k http://localhost:80/index.txt")
    assert "haproxy_process_pool_allocated_bytes" in machine.succeed(
        "curl -k http://localhost:80/metrics"
    )
  '';
})
