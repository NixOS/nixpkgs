# Netbird Relay {#module-services-netbird-relay}

The Relay service forwards encrypted WireGuard traffic between peers that cannot establish a direct P2P connection

For more information, check [external relays](https://docs.netbird.io/selfhosted/maintenance/scaling/set-up-external-relays) documentation.

## Quickstart {#module-services-netbird-relay-quickstart}

You can run the relay directly, or behind a reverse proxy, like `traefik`.

To run it directly, you'll have to run it on HTTPS port (443) and it will need the TLS certificates. Which you can configure using the `acme` module.

In the following example, we can see the `traefik` route and the relay configuration.
The operator should configure the TLS for the domain used by the relay, whether it's via `traefik` itself or using the `acme` module.

```nix
let
  relayDomain = "relay.example.com";
in
{
  services.netbird.relay = {
    enable = true;
    settings = {
      listen-address = ":33080";
      exposed-address = "rels://${relayDomain}:443";
      log-level = "info";
      enable-stun = true;
      stun-ports = [ 3479 ];
    };
    openFirewall = true;
    authSecretFile = "/run/auth_secret";
  };

  services.traefik = {
    enable = true;
    dynamicConfigOptions = {
      http = {
        routers = {
          vpn-relay = {
            rule = "Host(`${relayDomain}`)";
            entryPoints = [ "websecure" ];
            service = "vpn-relay-svc";
            tls = { };
          };
        };
        services = {
          vpn-relay-svc = {
            loadBalancer.servers = [ { url = "http://[::1]:33080"; } ];
          };
        };
      };
    };
  };
}
```

Finally, you must let `netbird.server` know about the new relay:

```nix
{ }:
{
  services.netbird.server = {
    # ...other config...
    management = {
      # ...other config...
      settings = {
        # ...other config...
        Relay = {
          Addresses = [ "rels://${relayDomain}:443" ];
          CredentialsTTL = "24h0m0s";
          Secret = {
            _secret = "/run/auth_secret";
          };
        };
      };
    };
  };
}
```
Done!

## TLS with Let's Encrypt {#module-services-netbird-relay-tls}

You can expose the netbird relay directly to the internet with TLS. Then you won't need a reverse proxy.

To use TLS, set `settings."letsencrypt-domains"`.
The relay gets and renews the certificates only when `settings."letsencrypt-domains"` is set.

Certificates are stored on disk, and the services runs as a systemd dynamic user.
The only writable location is therefore a `StateDirectory`, which can only be under `/var/lib`.

Open the ports `tcp/443` and `tcp/80` manually for the HTTP challenge.
