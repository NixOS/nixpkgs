{ lib, ... }:
{
  name = "paseo";
  meta.maintainers = with lib.maintainers; [ chansuke ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.jq ];
      services.paseo = {
        enable = true;
        # The VM has no network access to reach the hosted relay.
        settings.daemon.relay.enabled = false;
      };
    };

  testScript = ''
    machine.wait_for_unit("paseo.service")
    machine.wait_for_open_port(6767)
    machine.wait_until_succeeds("journalctl -u paseo.service --grep 'Launched terminal worker'")

    machine.succeed("curl --fail http://127.0.0.1:6767/api/health")
    machine.succeed("test \"$(stat -c %U /var/lib/paseo/config.json)\" = paseo")
    machine.succeed("jq -e '.daemon.relay.enabled == false' /var/lib/paseo/config.json")
  '';
}
