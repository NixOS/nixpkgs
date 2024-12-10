import ./make-test-python.nix (
  { pkgs, ... }:
  let
    localProxyPort = 43;
  in
  {
    name = "dnscrypt-proxy2";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ joachifm ];
    };

    nodes = {
      # A client running the recommended setup: DNSCrypt proxy as a forwarder
      # for a caching DNS client.
      client =
        { ... }:
        {
          security.apparmor.enable = true;

          services.dnscrypt-proxy2.enable = true;
          services.dnscrypt-proxy2.settings = {
            listen_addresses = [ "127.0.0.1:${toString localProxyPort}" ];
            sources.public-resolvers = {
              urls = [ "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md" ];
              cache_file = "public-resolvers.md";
              minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
              refresh_delay = 72;
            };
          };

          services.dnsmasq.enable = true;
          services.dnsmasq.settings.server = [ "127.0.0.1#${toString localProxyPort}" ];
        };
    };

    testScript = ''
      client.wait_for_unit("dnsmasq")
      client.wait_for_unit("dnscrypt-proxy2")
      client.wait_until_succeeds("ss --numeric --udp --listening | grep -q ${toString localProxyPort}")
    '';
  }
)
