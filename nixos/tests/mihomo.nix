{ pkgs, ... }:
{
  name = "mihomo";
  meta.maintainers = with pkgs.lib.maintainers; [ Guanran928 ];

  nodes.machine = {
    environment.systemPackages = [ pkgs.curl ];

    services.nginx = {
      enable = true;
      statusPage = true;
    };

    services.mihomo = {
      enable = true;
      configFile = pkgs.writeTextFile {
        name = "config.yaml";
        text = ''
          mixed-port: 7890
          external-controller: 127.0.0.1:9090
          authentication:
          - "user:supersecret"
        '';
      };
    };
  };

  testScript = ''
    # Wait until it starts
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("mihomo.service")
    machine.wait_for_open_port(80)
    machine.wait_for_open_port(7890)
    machine.wait_for_open_port(9090)

    # Proxy
    machine.succeed("curl --fail --max-time 10 --proxy http://user:supersecret@localhost:7890 http://localhost")
    machine.succeed("curl --fail --max-time 10 --proxy socks5://user:supersecret@localhost:7890 http://localhost")
    machine.fail("curl --fail --max-time 10 --proxy http://user:supervillain@localhost:7890 http://localhost")
    machine.fail("curl --fail --max-time 10 --proxy socks5://user:supervillain@localhost:7890 http://localhost")

    # Web UI
    result = machine.succeed("curl --fail http://localhost:9090")
    target = '{"hello":"mihomo"}\n'
    assert result == target, f"{result!r} != {target!r}"
  '';
}
