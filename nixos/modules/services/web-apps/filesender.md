# FileSender {#module-services-filesender}

[FileSender](https://filesender.org/software/) is a software that makes it easy to send and receive big files.

## Quickstart {#module-services-filesender-quickstart}

FileSender needs an authentication backend.
The module currently only supports `oidc` (the default) and `fake` (for testing).
Other backends are listed under [](#opt-services.filesender.auth.backend).

A minimal instance that authenticates against an OpenID Connect provider looks like this:

```nix
{
  services.filesender = {
    enable = true;
    configureNginx = true;
    database.createLocally = true;

    localDomain = "filesender.example.com";

    settings = {
      admin = "admin";
      admin_email = "admin@example.com";
      email_reply_to = "noreply@example.com";
    };

    auth = {
      oidc = {
        issuer = "https://login.example.com";
        clientID = "filesender";
        clientSecretFile = "/run/keys/filesender-oidc-client-secret";
      };

      backend = "oidc";
    };
  };

  networking.firewall.allowedTCPPorts = [
    443
    80
  ];
}
```

The OIDC provider must be configured with `https://filesender.example.com/oidc.php` as the redirect URI for the client and the `issuer` above must exactly match the issuer URL announced by your provider.

::: {.warning}
When passing `clientSecretFile`, make sure to use a path outside the Nix store, such as `/run/keys/...`, and make sure it is readable by [](#opt-services.filesender.user).
:::
