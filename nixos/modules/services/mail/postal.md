# Postal {#module-services-postal}

[Postal](https://github.com/postalserver/postal) is an open source mail
delivery platform for incoming & outgoing e-mail.

## Basic usage {#module-services-postal-basic-usage}

Start by setting up your [domain and DNS](https://docs.postalserver.io/getting-started/dns-configuration).

Except for secrets, which should be stored in [`services.postal.environmentFile`](#opt-services.postal.environmentFile),
[Postal configuration](https://docs.postalserver.io/getting-started/configuration)
can be defined in [`services.postal.settings`](#opt-services.postal.settings).

**This example is unsafe, don't store secrets in the nix store.**

```nix
let
  # generate a rails secret key: `openssl rand -hex 64`
  # smtp password will need to be set later, once you have generated credentials in Postal’s UI
  unsafeEnvironmentFile = pkgs.writeText "env-file" ''
    RAILS_SECRET_KEY=00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
    SMTP_PASSWORD=
  '';

  # generate a signing key: `openssl genrsa 4096`
  unsafeSigningKey = pkgs.writeText "signingKey" ''
    -----BEGIN PRIVATE KEY-----
    MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEAtssGlCncaEQfOP7y
    50ZuTTacnwv5Twz4dBDE3L/JeIE0HOvcX+Na0h4DPbn276mciYhkS4RFpQawgkig
    j2NuZQIDAQABAkBWYsSNKOtc6zTGPtaUrhharUB/ea0syrhwQayHlqukIr6k7uBC
    isR3ozdDOHCJVN1iAjWvIPk+m/Nk+RmPKLKBAiEA5bBKyCn1NGo7XqXMvZ3RpY+k
    mYFuHaAC2/IfVj6Mf50CIQDLu4C7/TydV+s/iRWPy6p7Xb2kGHzpCimrfgoGkcFD
    aQIhALHQuRQc52ecljm/wbFJ7HNvsM3mFYl5xrzfxMLPyZVBAiBLaPHzo36GNv7K
    m7Exco997mq9jJrfn3VhFtwbJmRE0QIhAM7fzud2xue48DlTvvD7TsrjyGGw+Tha
    Vn45rvYNYAyq
    -----END PRIVATE KEY-----
  '';

in {
  networking.firewall.allowedTCPPorts = [ 443 ];

  services.postal = {
    enable = true;
    environmentFile = unsafeEnvFile;
    domain = "postal.example.com";

    # if you want to open the SMTP service port
    openFirewall = true;

    settings = {
      postal = {
        signing_key_path = unsafeSigningKey;
      };
      smtp = {
        host = "postal.example.com"
        from_address = "postal@example.com";
      };
      smtp_server = {
        tls_enabled = true;
        tls_certificate_path = "/var/lib/acme/postal.example.com/cert.pem";
        tls_private_key_path = "/var/lib/acme/postal.example.com/key.pem";
      };
    };
  };

  # we can use the same ACME's certificate both for HTTPS and SMTPS encryption
  security.acme = {
    acceptTerms = true;
    defaults.email = "info@example.com";
    certs."postal.example.com" = {
      group = "postal";
    };
  };

  # example proxy using nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts.${config.services.postal.domain} = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:${toString config.services.postal.settings.web_server.default_port}";
    };
  };

  # needed because we changed the certificate group owner
  users.users.nginx.extraGroups = [ "postal" ];
}
```

Create the initial user using the cli:

```sh
postal make-user
```

You should then configure Postal from its UI. Setup your domain and
a credential for Postal itself, put the credential key in your
`SMTP_PASSWORD` environment variable, and ensure your
[`services.postal.settings.smtp`](#opt-services.postal.settings) are correct.

You can now test sending mail from the CLI:

```sh
postal test-app-smtp you@example.com
```

## Emails deliverability {#module-services-postal-emails-deliverability}

To have good email deliverability, you need to maintain your
IP reputation and ensure your configuration is set up correctly.
Tools like mail-tester.com can help identify misconfigurations.
