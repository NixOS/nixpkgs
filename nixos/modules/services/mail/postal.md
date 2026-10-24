# Postal {#module-services-postal}

[Postal](https://github.com/postalserver/postal) is an open source mail
delivery platform for incoming & outgoing e-mail.

## Minimal example {#module-services-postal-minimal-example}

Here is a minimal example, running SMTP and HTTP without security layer:

```nix
{
  services.postal = {
    enable = true;
    domain = "localhost";

    # Enable and configure nginx
    nginx = { };

    # Open ports 25 and 80
    openFirewall = true;
  };
}
```

## Basic usage {#module-services-postal-basic-usage}

Start by setting up your [domain and DNS](https://docs.postalserver.io/getting-started/dns-configuration).

[Postal configuration](https://docs.postalserver.io/getting-started/configuration) can be defined via
option [`services.postal.settings`](#opt-services.postal.settings).

Secrets should be defined in [`services.postal.environmentFile`](#opt-services.postal.environmentFile),
using a secrets management solution like sops-nix. No secret is mandatory, but it's recommended to set
`RAILS_MASTER_KEY`.

```nix
{
  services.postal = {
    enable = true;
    domain = "postal.example.com";

    # Enable and configure nginx, with TLS for web and smtp services
    enableACME = true;
    nginx = { };

    # Open ports 80, 443 and 587
    openFirewall = true;

    # Secrets should be provided here
    # environmentFile =

    # Example to configure postal to use itsef to send emails (not mandatory).
    # You will need to complete this configuration once you have created SMTP
    # credentials from the Postal's GUI. Use `environmentFile` to set SMTP_PASSWORD.
    settings.smtp = {
      host = "postal.example.com";
      from_address = "postal@example.com";
    };
  };

  # Needed because we enabled ACME
  security.acme = {
    acceptTerms = true;
    defaults.email = "info@example.com";
  };
}
```

## Create user from the Postal CLI {#module-services-create-user-from-cli}

Once installed, Postal's CLI will let you create an initial user:

```sh
postal make-user
```

## Emails deliverability {#module-services-postal-emails-deliverability}

To have good email deliverability, you need to maintain your
IP reputation and ensure your configuration is set up correctly.
Tools like mail-tester.com can help identify misconfigurations.
