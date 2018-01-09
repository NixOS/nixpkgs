import ./make-test.nix ({ pkgs, ... }: {
  name = "dnscrypt-proxy";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ joachifm ];
  };

  nodes = {
    # A client running the recommended setup: DNSCrypt proxy as a forwarder
    # for a caching DNS client.
    client =
    { config, pkgs, ... }:
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
    $client->waitForUnit("dnsmasq");

    # The daemon is socket activated; sending a single ping should activate it.
    $client->execute("${pkgs.iputils}/bin/ping -c1 example.com");
    $client->succeed("systemctl is-active dnscrypt-proxy");
  '';
})
