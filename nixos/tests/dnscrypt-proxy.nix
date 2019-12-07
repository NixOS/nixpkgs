import ./make-test-python.nix ({ pkgs, ... }: {
  name = "dnscrypt-proxy";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ joachifm ];
  };

  nodes = {
    # A client running the recommended setup: DNSCrypt proxy as a forwarder
    # for a caching DNS client.
    client =
    { ... }:
    let localProxyPort = 43; in
    {
      security.apparmor.enable = true;

      services.dnscrypt-proxy.enable = true;
      services.dnscrypt-proxy.localPort = localProxyPort;
      services.dnscrypt-proxy.extraArgs = [ "-X libdcplugin_example.so" ];

      services.dnsmasq.enable = true;
      services.dnsmasq.servers = [ "127.0.0.1#${toString localProxyPort}" ];
    };
  };

  testScript = ''
    client.wait_for_unit("dnsmasq")

    # The daemon is socket activated; sending a single ping should activate it.
    client.fail("systemctl is-active dnscrypt-proxy")
    client.execute(
        "${pkgs.iputils}/bin/ping -c1 example.com"
    )
    client.wait_until_succeeds("systemctl is-active dnscrypt-proxy")
  '';
})
