# Netbird server {#module-services-netbird-server}

NetBird is a VPN built on top of WireGuard® making it easy to create secure private networks for your organization or home.

## Quickstart {#module-services-netbird-server-quickstart}

To fully setup Netbird as a self-hosted server, you need an identity provider (or use the embedded IDP) and either a Coturn server or the modern relay server. The list of supported SSOs and their setup are available [on Netbird's documentation](https://docs.netbird.io/selfhosted/selfhosted-guide#step-3-configure-identity-provider-idp).

### Minimal Configuration with Coturn {#module-services-netbird-server-quickstart-coturn}

This is the traditional setup using Coturn as the TURN server:

```nix
{
  services.netbird.server = {
    enable = true;

    domain = "netbird.example.selfhosted";

    enableNginx = true;

    coturn = {
      enable = true;
      passwordFile = "/path/to/a/secret/password";
    };

    management = {
      oidcConfigEndpoint = "https://sso.example.selfhosted/oauth2/openid/netbird/.well-known/openid-configuration";

      settings = {
        TURNConfig = {
          Turns = [
            {
              Proto = "udp";
              URI = "turn:netbird.example.selfhosted:3478";
              Username = "netbird";
              Password._secret = "/path/to/a/secret/password";
            }
          ];
        };
      };
    };
  };
}
```

### Modern Setup with Relay Server {#module-services-netbird-server-quickstart-relay}

NetBird v0.28+ introduced a modern relay server that replaces Coturn with better performance and simpler configuration. The relay server includes an embedded STUN server.

```nix
{
  services.netbird.server = {
    enable = true;

    domain = "netbird.example.selfhosted";

    enableNginx = true;

    # Use the modern relay instead of Coturn
    useRelay = true;
    relayAuthSecretFile = "/run/secrets/relay-auth";

    management = {
      oidcConfigEndpoint = "https://sso.example.selfhosted/oauth2/openid/netbird/.well-known/openid-configuration";
    };
  };
}
```

## Relay vs Coturn {#module-services-netbird-server-relay-vs-coturn}

| Feature | Relay Server | Coturn |
|---------|--------------|--------|
| Protocol | WebSocket/HTTP(S) | TURN (UDP/TCP) |
| Firewall | Single port (443) | Multiple ports + UDP range |
| Setup | Simple | More complex |
| Embedded STUN | Yes | No (separate config) |
| Performance | Optimized for NetBird | General-purpose |

**Recommendation:** Use the relay server for new deployments. Only use Coturn if you have specific requirements for standard TURN protocol compatibility.

## Embedded Identity Provider {#module-services-netbird-server-embedded-idp}

NetBird supports an embedded identity provider for simplified deployments that don't require an external SSO. Enable it with `idp.embedded.enable`, then customize via the freeform `settings` option:

```nix
{
  services.netbird.server.management = {
    enable = true;
    domain = "netbird.example.com";
    turnDomain = "netbird.example.com";

    idp.embedded.enable = true;

    settings = {
      ProviderConfig = {
        Owner = {
          Email = "admin@example.com";
          Username = "admin";
          # Generate with: htpasswd -bnBC 10 "" 'your-password' | tr -d ':\n'
          Password._secret = "/run/secrets/admin-password-hash";
        };
      };
    };
  };
}
```

## Database Backends {#module-services-netbird-server-database}

By default, the management server uses SQLite. For larger deployments, PostgreSQL or MySQL is recommended.

### PostgreSQL {#module-services-netbird-server-database-postgres}

```nix
{
  services.netbird.server.management = {
    store = {
      engine = "postgres";
      postgres.dsnFile = "/run/secrets/postgres-dsn";
    };
  };

  # Example DSN file content:
  # postgres://netbird:password@localhost:5432/netbird?sslmode=disable

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "netbird" ];
    ensureUsers = [
      {
        name = "netbird";
        ensureDBOwnership = true;
      }
    ];
  };
}
```

## Relay Server Configuration {#module-services-netbird-server-relay-config}

The relay server can be configured independently. Advanced TLS settings (Let's Encrypt, custom certificates) can be passed via `extraOptions`:

```nix
{
  services.netbird.server.relay = {
    enable = true;
    exposedAddress = "rels://relay.example.com:443";
    authSecretFile = "/run/secrets/relay-auth";

    stun = {
      enable = true;
      ports = [ 3478 ];
    };

    openFirewall = true;

    # For direct TLS (without nginx reverse proxy):
    extraOptions = [
      "--tls-cert-file"
      "/path/to/cert.pem"
      "--tls-key-file"
      "/path/to/key.pem"
    ];
  };
}
```

## Complete Self-Hosted Example {#module-services-netbird-server-complete-example}

Here's a complete example using the modern relay server with an external identity provider:

```nix
{ config, ... }:

{
  services.netbird.server = {
    enable = true;
    domain = "netbird.example.com";
    enableNginx = true;

    useRelay = true;
    relayAuthSecretFile = "/run/secrets/netbird/relay-auth";

    management = {
      oidcConfigEndpoint = "https://auth.example.com/.well-known/openid-configuration";

      settings = {
        DataStoreEncryptionKey._secret = "/run/secrets/netbird/encryption-key";
      };
    };

    dashboard.settings = {
      AUTH_AUTHORITY = "https://auth.example.com";
      AUTH_CLIENT_ID = "netbird-dashboard";
    };
  };

  # Configure Nginx with ACME
  services.nginx.virtualHosts."netbird.example.com" = {
    enableACME = true;
    forceSSL = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@example.com";
  };

  # Open firewall for STUN (relay handles the rest via nginx)
  networking.firewall.allowedUDPPorts = [ 3478 ];
}
```
