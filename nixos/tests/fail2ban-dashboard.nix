{ pkgs, ... }:
{
  name = "fail2ban-dashboard";

  nodes.machine = _: {
    services.fail2ban = {
      enable = true;
      bantime-increment.enable = true;
    };

    services.fail2ban-dashboard = {
      enable = true;
    };

    networking.nftables.enable = true;

    environment.systemPackages = [ pkgs.curl ];
  };

  testScript = ''
    start_all()

    # Wait for everything to be ready.
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("fail2ban")
    machine.wait_for_unit("fail2ban-dashboard")

    # Check whether fail2ban-dashboard is returning something on its default port
    machine.succeed("curl localhost:3000")
  '';
}
