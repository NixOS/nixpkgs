# Netbird server {#module-services-netbird-server}

NetBird is a VPN built on top of WireGuard® making it easy to create secure private networks for your organization or home.

## Quickstart {#module-services-netbird-server-quickstart}

To fully setup Netbird as a self-hosted server, you need a Coturn or relay server, a netbird-signal server, an identity provider, and
a netbird management instance.
A list of supported SSOs and their setup are available [on Netbird's documentation](https://docs.netbird.io/selfhosted/selfhosted-guide#step-3-configure-identity-provider-idp).

There are quite a few settings that need to be passed to Netbird for it to function, and a minimal config might look like :

::: {.example}

# Netbird minmal Configuration

```nix
{pkgs, ...}: {
  services.netbird.server = {
    enable = true;

    # Publicly exposed domain
    domain = "netbird.example.selfhosted";

    # website for administration
    dashboard = {
      enableNginx = true;
      settings.AUTH_AUTHORITY = "https://sso.example.selfhosted/oauth2/openid/netbird";
    };

    # Netbirds own relay implementation
    relay.authSecretFile = pkgs.writeText "secret-file" "very secure secret";

    # Relay using coturn
    coturn = {
      enable = true;
      passwordFile = pkgs.writeText "password-file" "very secure password";
    };

    # Backend management api
    management = {
      oidcConfigEndpoint = "https://sso.example.selfhosted/oauth2/openid/netbird/.well-known/openid-configuration";
      settings.Signal.URI = "publicly reachable signal endpoint";
      DataStoreEncryptionKey._secret = pkgs.writeText "encryption-key" "another very secure secret";
    };
  };
}
```
:::

## Proxy {#module-services-netbird-server-proxy}

The proxy module sets up a unified nginx proxy in front of your netbird instance.

::: {.warning}
The proxy module is completely independent from netbird upstream.
If you have any problems with it DO NOT open an issue in any `netbirdio` repositories. Instead open them in [`nixos/nixpkgs`](https://github.com/nixos/nixpkgs/issues) and ping the proxy maintainers.
:::

The proxy assumes being hosted over https.

When using the proxy remember to set all public address options to use the proxy host instead of the instance itself. These include:

- {option}`server.domain`
- {option}`management.settings.Signal.URI`
- {option}`relay.setting.NB_EXPOSED_ADDRESS`
