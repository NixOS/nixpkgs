{ pkgs, ... }:
{
  name = "tinyproxy";

  nodes = {
    machine =
      { config, pkgs, ... }:
      {
        services.tinyproxy = {
          enable = true;
          settings = {
            Listen = [
              "127.0.0.1"
              "::1"
            ];
            Port = 8080;
          };
        };

        # Disable firewall so we can be sure curl fails because of the
        # listening address and not the firewall.
        networking.firewall.enable = false;
      };

    other = { ... }: { };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("tinyproxy.service")
    machine.wait_for_open_port(8080)

    machine.succeed('curl -s http://localhost:8080 |grep -i tinyproxy')
    machine.succeed('curl -s http://127.0.0.1:8080 |grep -i tinyproxy')
    machine.succeed('curl -s "http://[::1]:8080" |grep -i tinyproxy')

    other.wait_for_unit("multi-user.target")
    other.fail('curl -s http://machine:8080')
  '';
}
