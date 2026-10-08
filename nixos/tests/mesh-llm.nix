{ lib, ... }:

{
  name = "mesh-llm";
  meta.maintainers = with lib.maintainers; [ kleinbem ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.mesh-llm = {
        enable = true;
        settings.version = 1;
        meshPort = 7842;
        openFirewall = true;
      };
      environment.systemPackages = [
        pkgs.curl
        pkgs.mesh-llm
      ];
      virtualisation.memorySize = 2048;
    };

  testScript = ''
    machine.wait_for_unit("mesh-llm.service")
    machine.wait_for_open_port(9337)
    machine.wait_for_open_port(3131)

    with subtest("console and management API answer"):
        page = machine.succeed("curl -fsS http://127.0.0.1:3131/")
        assert "<html" in page.lower(), "the console must serve its web UI"
        machine.succeed("curl -fsS http://127.0.0.1:3131/api/status")

    with subtest("OpenAI-compatible API answers"):
        machine.succeed("curl -fsS http://127.0.0.1:9337/v1/models")

    with subtest("settings are installed in the node's home"):
        machine.succeed("grep -qx 'version = 1' /var/lib/mesh-llm/.mesh-llm/config.toml")

    with subtest("QUIC listens on the fixed mesh port, and the firewall allows it"):
        machine.wait_until_succeeds("ss -Hulnp | grep -q ':7842 '")
        machine.succeed("iptables -S | grep -q 'udp.*--dport 7842'")

    with subtest("the Nix-built runtimes are found"):
        out = machine.succeed("HOME=/tmp mesh-llm runtime list 2>&1")
        assert "-nixpkgs" in out, out
  '';
}
