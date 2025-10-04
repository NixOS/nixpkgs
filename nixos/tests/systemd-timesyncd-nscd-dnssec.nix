# This test verifies that systemd-timesyncd can resolve the NTP server hostname when DNSSEC validation
# fails even though it is enforced in the systemd-resolved settings. It is required in order to solve
# the chicken-and-egg problem when DNSSEC validation needs the correct time to work, but to set the
# correct time, we need to connect to an NTP server, which usually requires resolving its hostname.
#
# This test does the following:
# - Sets up a DNS server (tinydns) listening on the eth1 ip address, serving .ntp and fake.ntp records.
# - Configures that DNS server as a resolver and enables DNSSEC in systemd-resolved settings.
# - Configures systemd-timesyncd to use fake.ntp hostname as an NTP server.
# - Performs a regular DNS lookup, to ensure it fails due to broken DNSSEC.
# - Waits until systemd-timesyncd resolves fake.ntp by checking its debug output.
#   Here, we don't expect systemd-timesyncd to connect and synchronize time because there is no NTP
#   server running. For this test to succeed, we only need to ensure that systemd-timesyncd
#   resolves the IP address of the fake.ntp host.

{ pkgs, ... }:

let
  ntpHostname = "fake.ntp";
  ntpIP = "192.0.2.1";
in
{
  name = "systemd-timesyncd";
  nodes.machine =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      eth1IP = (lib.head config.networking.interfaces.eth1.ipv4.addresses).address;
    in
    {
      # Setup a local DNS server for the NTP domain on the eth1 IP address
      services.tinydns = {
        enable = true;
        ip = eth1IP;
        data = ''
          .ntp:${eth1IP}
          +.${ntpHostname}:${ntpIP}
        '';
      };

      # Enable systemd-resolved with DNSSEC and use the local DNS as a name server
      services.resolved.enable = true;
      services.resolved.dnssec = "true";
      networking.nameservers = [ eth1IP ];

      # Configure systemd-timesyncd to use our NTP hostname
      services.timesyncd.enable = lib.mkForce true;
      services.timesyncd.servers = [ ntpHostname ];
      services.timesyncd.extraConfig = ''
        FallbackNTP=${ntpHostname}
      '';

      # The debug output is necessary to determine whether systemd-timesyncd successfully resolves our NTP hostname or not
      systemd.services.systemd-timesyncd.environment.SYSTEMD_LOG_LEVEL = "debug";
    };

  testScript = ''
    machine.wait_for_unit("tinydns.service")
    machine.wait_for_unit("systemd-timesyncd.service")
    machine.fail("resolvectl query ${ntpHostname}")
    machine.wait_until_succeeds("journalctl -u systemd-timesyncd.service --grep='Resolved address ${ntpIP}:123 for ${ntpHostname}'")
  '';
}
