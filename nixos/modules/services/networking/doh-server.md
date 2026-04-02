# DNS-over-HTTPS Server {#module-service-doh-server}

[DNS-over-HTTPS](https://github.com/m13253/dns-over-https) is a high performance DNS over HTTPS client & server. This module enables its server part (`doh-server`).

## Quick Start {#module-service-doh-server-quick-start}

Setup with Nginx + ACME (recommended):

```nix
{
  services.doh-server = {
    enable = true;
    settings = {
      upstream = [ "udp:1.1.1.1:53" ];
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."doh.example.com" = {
      enableACME = true;
      forceSSL = true;
      http2 = true;
      locations."/".return = 404;
      locations."/dns-query" = {
        proxyPass = "http://127.0.0.1:8053/dns-query";
        recommendedProxySettings = true;
      };
    };
    # and other virtual hosts ...
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "you@example.com";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
```

`doh-server` can also work as a standalone HTTPS web server (with SSL cert and key specified), but this is not recommended as `doh-server` does not do OCSP Stabbing.

Setup a standalone instance with ACME:

```nix
let
  domain = "doh.example.com";
in
{
  security.acme.certs.${domain} = {
    dnsProvider = "cloudflare";
    credentialFiles."CF_DNS_API_TOKEN_FILE" = "/run/secrets/cf-api-token";
  };

  services.doh-server = {
    enable = true;
    settings = {
      listen = [ ":443" ];
      upstream = [ "udp:1.1.1.1:53" ];
    };
    useACMEHost = domain;
  };

  networking.firewall.allowedTCPPorts = [ 443 ];
}
```

See a full configuration in <https://github.com/m13253/dns-over-https/blob/master/doh-server/doh-server.conf>.
