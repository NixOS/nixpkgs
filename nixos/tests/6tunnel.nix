import ./make-test-python.nix ({ pkgs, lib, ... } : {
  name = "6tunnel";
  meta.maintainers = with pkgs.lib.maintainers; [ ymarkus ];

  nodes = {

    client = { ... }: {
      networking.enableIPv6 = false;
    };

    tunnel = { ... }: {
      services._6tunnel = {
        tunnels = [
          # to check if CAP_NET_BIND_SERVICE works
          { port = 80; remoteHost = "webhost"; }
          # to check if "remotePort" works
          { port = 8080; remoteHost = "webhost"; remotePort = 80; }
        ];
        openFirewall = true;
      };
    };

    webhost = { ... }: {
      networking.firewall.enable = false;
      services.httpd = {
        enable = true;
        adminAddr = "foo@example.org";
      };
    };

  };

  testScript = ''
    start_all()

    client.wait_for_unit("network.target")
    tunnel.wait_for_unit("6tunnel-80")
    tunnel.wait_for_unit("6tunnel-8080")
    webhost.wait_for_unit("httpd")

    # test if we can curl the webserver
    client.succeed("curl http://tunnel:80/")
    client.succeed("curl http://tunnel:8080/")
  '';
})
