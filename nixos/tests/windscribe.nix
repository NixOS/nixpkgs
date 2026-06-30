{
  name = "windscribe";

  meta.maintainers = with (import ../../maintainers/maintainer-list.nix); [ syntheit ];

  nodes.machine = {
    services.windscribe.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("windscribe-helper.service")
    machine.succeed("test -S /var/run/windscribe/helper.sock")
    machine.succeed("test -f /etc/windscribe/platform")
    machine.succeed("test -d /opt/windscribe")
    machine.succeed("mountpoint -q /opt/windscribe")
    machine.succeed("test -x /opt/windscribe/helper")
    machine.succeed("test -x /opt/windscribe/windscribeopenvpn")
    machine.succeed("test -x /opt/windscribe/windscribewstunnel")
    machine.succeed("/opt/windscribe/windscribeopenvpn --version")
  '';
}
