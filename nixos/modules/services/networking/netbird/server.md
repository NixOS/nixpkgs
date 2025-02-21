# Netbird server {#module-services-netbird-server}

NetBird is a VPN built on top of WireGuard® making it easy to create secure private networks for your organization or home.

## Quickstart {#module-services-netbird-server-quickstart}

To fully setup Netbird as a self-hosted server, we need both a Coturn server and an identity provider,
the list of supported SSOs and their setup are available [on Netbird's documentation](https://docs.netbird.io/selfhosted/selfhosted-guide#step-3-configure-identity-provider-idp).

There are quite a few settings that need to be passed to Netbird for it to function, and a minimal config might look like :

```nix
services.netbird.server = {
  enable = true;

  domain = "netbird.example.selfhosted";

  dashboard.settings.AUTH_AUTHORITY = "https://sso.example.selfhosted/oauth2/openid/netbird";

  relay.authSecretFile = pkgs.writeText "very secure secret";


  coturn = {
    enable = true;

    passwordFile = "/path/to/a/secret/password";
  };

  management = {
    oidcConfigEndpoint = "https://sso.example.selfhosted/oauth2/openid/netbird/.well-known/openid-configuration";
    settings.Signal.URI = "publicly reachable signal endpoint";
  };
};
```

## Proxy {#module-services-netbird-server-proxy}
The proxy allows you to have an nginux proxy in front of your netbird instance.
The proxy currently assumes that nginx is server over https.

Rememeber to set all public options to use the proxy instead of the instance. These include
```nix
relay.setting.NB_EXPOSED_ADDRESS

```
