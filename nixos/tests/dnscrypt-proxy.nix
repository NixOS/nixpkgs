{ lib, ... }:
let
  localProxyPort = 43;
  localProxyExtraPort = 44;
in
{
  name = "dnscrypt-proxy";
  meta.maintainers = [ ];

  nodes = {
    # A client running the recommended setup: DNSCrypt proxy as a forwarder
    # for a caching DNS client.
    client =
      { ... }:
      {
        imports = [
          # Tests if dnscrypt-proxy settings correctly deep-merge across modules,
          # and that the resulting config works.
          # See https://github.com/NixOS/nixpkgs/issues/523152
          {
            services.dnscrypt-proxy.settings.listen_addresses = [ "127.0.0.1:${toString localProxyPort}" ];
          }
          {
            services.dnscrypt-proxy.settings.listen_addresses = [ "127.0.0.1:${toString localProxyExtraPort}" ];
          }
        ];

        security.apparmor.enable = true;
        services.dnscrypt-proxy.enable = true;
        services.dnscrypt-proxy.settings = {
          sources.public-resolvers = {
            urls = [ "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md" ];
            cache_file = "public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
            refresh_delay = 72;
          };
        };

        services.dnsmasq.enable = true;
        services.dnsmasq.settings.server = [
          "127.0.0.1#${toString localProxyPort}"
          "127.0.0.1#${toString localProxyExtraPort}"
        ];
      };
  };

  testScript = ''
    client.wait_for_unit("dnsmasq")
    client.wait_for_unit("dnscrypt-proxy")
    client.wait_until_succeeds("ss --numeric --udp --listening | grep -q ${toString localProxyPort}")
    client.wait_until_succeeds("ss --numeric --udp --listening | grep -q ${toString localProxyExtraPort}")
  '';
}
