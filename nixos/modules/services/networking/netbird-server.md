# Netbird server {#module-services-netbird-server}

NetBird is a VPN built on top of WireGuard® making it easy to create secure private networks for your organization or home.

## Quickstart {#module-services-netbird-quickstart}

To setup Netbird as a self-hosted server, we need both a Coturn server and an identity provider, the list of supported SSOs and their setup are available [on Netbird's documentation](https://docs.netbird.io/selfhosted/selfhosted-guide#step-3-configure-identity-provider-idp).

There are quite a few settings that need to be passed to Netbird for it to function, and a minimal config looks like :

```nix
services.netbird-server = {
  enable = true;

  enableNginx = true;
  enableCoturn = true;
  setupAutoOidc = true;

  settings = rec {
    NETBIRD_DOMAIN = "netbird.example.selfhosted";

    TURN_PASSWORD = "netbird-password";
    NETBIRD_AUTH_OIDC_CONFIGURATION_ENDPOINT = "https://sso.example.selfhosted/oauth2/openid/netbird/.well-known/openid-configuration";
    NETBIRD_AUTH_AUDIENCE = "netbird";
    NETBIRD_AUTH_CLIENT_SECRET = "a-very-secure-secret";
  };
};
```

This will start the netbird management server as well as a dedicated coturn server on the same domain.

It is also possible to use an existing TURN/STUN server, which can be configured with :

```nix
services.netbird-server = {
  enable = true;

  enableNginx = true;
  setupAutoOidc = true;

  settings = rec {
    NETBIRD_DOMAIN = "netbird.example.selfhosted";

    TURN_USER = "netbird";
    TURN_PASSWORD = "netbird-password";
    TURN_DOMAIN = "turn.example.selfhosted";
    TURN_PORT = 3478;
    TURN_MIN_PORT = 49512;
    TURN_MAX_PORT = 65535;
    TURN_SECRET = "another-secure-secret";

    STUN_USERNAME = "netbird";
    STUN_PASSWORD = "password";

    NETBIRD_AUTH_OIDC_CONFIGURATION_ENDPOINT = "https://sso.example.selfhosted/oauth2/openid/netbird/.well-known/openid-configuration";
    NETBIRD_AUTH_AUDIENCE = "netbird";
    NETBIRD_AUTH_CLIENT_SECRET = "a-very-secure-secret";
  };
};
```

Secrets can be passed in files so that they don't appear in the nix store (except for TURN_PASSWORD when using the automatic coturn server) :

```nix
services.netbird-server = {
  enable = true;

  enableNginx = true;
  setupAutoOidc = true;

  settings = rec {
    NETBIRD_DOMAIN = "netbird.example.selfhosted";

    NETBIRD_AUTH_OIDC_CONFIGURATION_ENDPOINT = "https://sso.example.selfhosted/oauth2/openid/netbird/.well-known/openid-configuration";
    NETBIRD_AUTH_AUDIENCE = "netbird";
  };

  secretFiles.TURN_PASSWORD = path.to.secret;
  secretFiles.AUTH_CLIENT_SECRET = path.to.another.secret;
};
```
