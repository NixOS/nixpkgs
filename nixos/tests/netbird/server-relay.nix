{
  lib,
  ...
}:
{
  name = "netbird-server-relay";

  meta.maintainers = with lib.maintainers; [
    shuuri-labs
  ];

  nodes = {
    relay =
      { pkgs, ... }:
      {
        services.netbird.server.relay = {
          enable = true;
          port = 8443;
          exposedAddress = "rels://relay.test:8443";
          # pkgs.writeText is world-readable but acceptable for tests
          authSecretFile = pkgs.writeText "relay-auth" "test-auth-secret";
          logLevel = "debug";

          stun = {
            enable = true;
            ports = [ 3478 ];
          };

          openFirewall = true;
        };
      };
  };

  testScript = ''
    start_all()

    # Test basic relay server
    relay.wait_for_unit("netbird-relay.service")
    relay.wait_for_open_port(8443)

    # Verify state directory exists
    relay.succeed("test -d /var/lib/netbird-relay")

    # Verify firewall is configured (relay port and STUN)
    relay.succeed("iptables -L INPUT -n | grep -q 8443")
    relay.succeed("iptables -L INPUT -n | grep -q 3478")
  '';
}
