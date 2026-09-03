# Netbird Relay {#module-services-netbird-relay}

The Netbird Relay service is a TURN server. The purpose of the Relay service is to gracefully implement a "Plan B" by relaying traffic between peers when a direct point-to-point connection is not possible.

For more information, check [external relays](https://docs.netbird.io/selfhosted/maintenance/scaling/set-up-external-relays) documentation.

## Quickstart {#module-services-netbird-relay-quickstart}

You can run the relay directly, or behind a reverse proxy, like `traefik`.

To run it directly, you'll have to run it on HTTPS port (443) and it will need the TLS certificates. Which you can configure using the `acme` module.

In the following example, we can see the `traefik` route and the relay configuration.
The operator should configure the TLS for the domain used by the relay, whether it's via `trafik` itself or using the `acme` module.

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

The relay can obtain and renew certificates itself via `settings."letsencrypt-domains"`.
The relay only enables TLS when both the domain and data directory are configured (`settings."letsencrypt-data-dir"`).

Certificates are stored on disk, and the services runs as a systemd dynamic user.
The only writable location is therefore a `StateDirectory`, which can only be under `/var/lib`

So besides the settings, you'll have to update the systemd's state directory.

Example

```nix
{
  services.netbird.relay = {
    enable = true;
    settings = {
      listen-address = ":33080";
      exposed-address = "rels://${relayDomain}:443";
      log-level = "info";
      enable-stun = true;
      stun-ports = [ 3479 ];
      letsencrypt-domains = [ relayDomain ];
      letsencrypt-data-dir = "/var/lib/netbird-relay";
    };
    openFirewall = true;
    authSecretFile = "/run/auth_secret";
  };
  systemd.services.netbird-relay.serviceConfig.StateDirectory = "netbird-relay";
}
```

You will have to manually open the ports `tcp/443` and `tcp/80` for the HTTP challenge.
