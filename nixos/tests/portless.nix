{ lib, ... }:

{
  name = "portless";

  meta.maintainers = with lib.maintainers; [ GuillaumeDesforges ];

  nodes.machine =
    { ... }:
    {
      services.portless = {
        enable = true;
        # Use a non-privileged port to avoid needing CAP_NET_BIND_SERVICE in
        # the test VM, keeping the test focused on daemon behaviour.
        port = 9443;
      };
    };

  testScript = ''
    machine.wait_for_unit("portless.service")
    machine.wait_for_open_port(9443)
    machine.wait_until_succeeds("test -f /var/lib/portless/ca.pem", timeout=30)
    machine.succeed("test -f /var/lib/portless/ca-key.pem")
    machine.succeed("openssl x509 -in /var/lib/portless/ca.pem -noout -subject | grep -i 'portless'")
  '';
}
