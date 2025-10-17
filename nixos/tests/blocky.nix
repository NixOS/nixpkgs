{
  name = "blocky";

  nodes = {
    server =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.dnsutils ];
        services.blocky = {
          enable = true;

          settings = {
            customDNS = {
              mapping = {
                "printer.lan" = "192.168.178.3,2001:0db8:85a3:08d3:1319:8a2e:0370:7344";
              };
            };
            upstream = {
              default = [
                "8.8.8.8"
                "1.1.1.1"
              ];
            };
            port = 53;
            httpPort = 5000;
            logLevel = "info";
          };
        };
      };
  };

  testScript = ''
    with subtest("Service test"):
        server.wait_for_unit("blocky.service")
        server.wait_for_open_port(53)
        server.wait_for_open_port(5000)
        server.succeed("dig @127.0.0.1 +short -x 192.168.178.3 | grep -qF printer.lan")
  '';
}
