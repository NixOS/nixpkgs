import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "ndppd";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fpletz ];
  };

  nodes = {
    upstream = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.tcpdump ];
      networking.useDHCP = false;
      networking.interfaces = {
        eth1 = {
          ipv6.addresses = [
            { address = "fd23::1"; prefixLength = 112; }
          ];
          ipv6.routes = [
            { address = "fd42::";
              prefixLength = 112;
            }
          ];
        };
      };
    };
    server = { pkgs, ... }: {
      boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = "1";
        "net.ipv6.conf.default.forwarding" = "1";
      };
      environment.systemPackages = [ pkgs.tcpdump ];
      networking.useDHCP = false;
      networking.interfaces = {
        eth1 = {
          ipv6.addresses = [
            { address = "fd23::2"; prefixLength = 112; }
          ];
        };
      };
      services.ndppd = {
        enable = true;
        proxies.eth1.rules."fd42::/112" = {};
      };
      containers.client = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.255.1";
        localAddress = "192.168.255.2";
        hostAddress6 = "fd42::1";
        localAddress6 = "fd42::2";
        config = {};
      };
    };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("multi-user.target")
    upstream.wait_for_unit("multi-user.target")
    upstream.wait_until_succeeds("ping -c5 fd42::2")
  '';
})
