import ./make-test-python.nix ({ lib, pkgs, ... }:
{
  name = "dnsmasq-resolved";
  meta.maintainers = [ lib.maintainers.majiir ];

  nodes = {
    client = { ... }: {
      services.dnsmasq.enable = true;
      services.resolved.enable = true;
      environment.systemPackages = [ pkgs.dig ];
    };
  };

  testScript = ''
    client.wait_for_unit("dnsmasq.service")

    with subtest("Querying dnsmasq works"):
      reply = client.succeed("dig +noall +answer client @127.0.0.1")
      assert (
          "192.168.1.1" in reply
      ), f""""
      The reply does not contain the expected IP address. Reply:
          {reply}"""

    client.wait_for_unit("systemd-resolved.service")

    with subtest("Querying resolved works"):
      reply = client.succeed("dig +noall +answer client @127.0.0.53")
      assert (
          "192.168.1.1" in reply
      ), f""""
      The reply does not contain the expected IP address. Reply:
          {reply}"""
  '';
})
