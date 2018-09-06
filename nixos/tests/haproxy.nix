import ./make-test.nix ({ pkgs, ...}: {
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
            use_backend http_server
        '';
      };
      services.httpd = {
        enable = true;
        documentRoot = pkgs.writeTextDir "index.txt" "We are all good!";
        adminAddr = "notme@yourhost.local";
        listen = [{
          ip = "::1";
          port = 8000;
        }];
      };
    };
  };
  testScript = ''
    startAll;
    $machine->waitForUnit('multi-user.target');
    $machine->waitForUnit('haproxy.service');
    $machine->waitForUnit('httpd.service');
    $machine->succeed('curl -k http://localhost:80/index.txt | grep "We are all good!"');

  '';
})
