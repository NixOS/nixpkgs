{ pkgs, ... }:
{
  name = "openlinkhub";

  nodes.machine = {
    services.openlinkhub.enable = true;
    environment.systemPackages = [ pkgs.curl ];
  };

  testScript = ''
    machine.wait_for_unit("openlinkhub.service")
    machine.wait_until_succeeds("curl --fail --silent http://127.0.0.1:27003/ >/dev/null")
    machine.succeed("systemctl is-active --quiet openlinkhub.service")
    machine.succeed("test $(stat -c %a /var/lib/openlinkhub/database/keyboard/k100.json) = 644")
    machine.succeed("printf 'user state' > /var/lib/openlinkhub/database/profiles/provision-test")
    machine.succeed("ln -sfnT /tmp /var/lib/openlinkhub/static")
    machine.succeed("systemctl restart openlinkhub.service")
    machine.wait_until_succeeds("curl --fail --silent http://127.0.0.1:27003/ >/dev/null")
    machine.succeed("readlink /var/lib/openlinkhub/static | grep -Fx ${pkgs.openlinkhub.assets.static}")
    machine.succeed("grep -Fx 'user state' /var/lib/openlinkhub/database/profiles/provision-test")
  '';
}
