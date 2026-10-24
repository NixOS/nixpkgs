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
      port = 5123;
    };

    environment.systemPackages = [ pkgs.curl ];
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("fail2ban.service")
    machine.wait_for_unit("fail2ban-dashboard.service")

    machine.succeed("curl --fail http://localhost:5123")
  '';
}
