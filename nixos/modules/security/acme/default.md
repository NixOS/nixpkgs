# SSL/TLS Certificates with ACME {#module-security-acme}

NixOS supports automatic domain validation & certificate retrieval and
renewal using the ACME protocol. Any provider can be used, but by default
NixOS uses Let's Encrypt. The alternative ACME client
[lego](https://go-acme.github.io/lego/) is used under
the hood.

Automatic cert validation and configuration for Apache and Nginx virtual
hosts is included in NixOS, however if you would like to generate a wildcard
cert or you are not using a web server you will have to configure DNS
based validation.

## Prerequisites {#module-security-acme-prerequisites}

To use the ACME module, you must accept the provider's terms of service
by setting [](#opt-security.acme.acceptTerms)
to `true`. The Let's Encrypt ToS can be found
[here](https://letsencrypt.org/repository/).

You must also set an email address to be used when creating accounts with
Let's Encrypt. You can set this for all certs with
[](#opt-security.acme.defaults.email)
and/or on a per-cert basis with
[](#opt-security.acme.certs._name_.email).
This address is only used for registration and renewal reminders,
and cannot be used to administer the certificates in any way.

Alternatively, you can use a different ACME server by changing the
[](#opt-security.acme.defaults.server) option
to a provider of your choosing, or just change the server for one cert with
[](#opt-security.acme.certs._name_.server).

You will need an HTTP server or DNS server for verification. For HTTP,
the server must have a webroot defined that can serve
{file}`.well-known/acme-challenge`. This directory must be
writeable by the user that will run the ACME client. For DNS, you must
set up credentials with your provider/server for use with lego.

## Using ACME certificates in Nginx {#module-security-acme-nginx}

NixOS supports fetching ACME certificates for you by setting
`enableACME = true;` in a virtualHost config. We first create self-signed
placeholder certificates in place of the real ACME certs. The placeholder
certs are overwritten when the ACME certs arrive. For
`foo.example.com` the config would look like this:

```
security.acme.acceptTerms = true;
security.acme.defaults.email = "admin+acme@example.com";
services.nginx = {
  enable = true;
  virtualHosts = {
    "foo.example.com" = {
      forceSSL = true;
      enableACME = true;
      # All serverAliases will be added as extra domain names on the certificate.
      serverAliases = [ "bar.example.com" ];
      locations."/" = {
        root = "/var/www";
      };
    };

    # We can also add a different vhost and reuse the same certificate
    # but we have to append extraDomainNames manually beforehand:
    # security.acme.certs."foo.example.com".extraDomainNames = [ "baz.example.com" ];
    "baz.example.com" = {
      forceSSL = true;
      useACMEHost = "foo.example.com";
      locations."/" = {
        root = "/var/www";
      };
    };
  };
}
```

## Using ACME certificates in Apache/httpd {#module-security-acme-httpd}

Using ACME certificates with Apache virtual hosts is identical
to using them with Nginx. The attribute names are all the same, just replace
"nginx" with "httpd" where appropriate.

## Manual configuration of HTTP-01 validation {#module-security-acme-configuring}

First off you will need to set up a virtual host to serve the challenges.
This example uses a vhost called `certs.example.com`, with
the intent that you will generate certs for all your vhosts and redirect
everyone to HTTPS.

```
security.acme.acceptTerms = true;
security.acme.defaults.email = "admin+acme@example.com";

# /var/lib/acme/.challenges must be writable by the ACME user
# and readable by the Nginx user. The easiest way to achieve
# this is to add the Nginx user to the ACME group.
users.users.nginx.extraGroups = [ "acme" ];

services.nginx = {
  enable = true;
  virtualHosts = {
    "acmechallenge.example.com" = {
      # Catchall vhost, will redirect users to HTTPS for all vhosts
      serverAliases = [ "*.example.com" ];
      locations."/.well-known/acme-challenge" = {
        root = "/var/lib/acme/.challenges";
      };
      locations."/" = {
        return = "301 https://$host$request_uri";
      };
    };
  };
}
# Alternative config for Apache
users.users.wwwrun.extraGroups = [ "acme" ];
services.httpd = {
  enable = true;
  virtualHosts = {
    "acmechallenge.example.com" = {
      # Catchall vhost, will redirect users to HTTPS for all vhosts
      serverAliases = [ "*.example.com" ];
      # /var/lib/acme/.challenges must be writable by the ACME user and readable by the Apache user.
      # By default, this is the case.
      documentRoot = "/var/lib/acme/.challenges";
      extraConfig = ''
        RewriteEngine On
        RewriteCond %{HTTPS} off
        RewriteCond %{REQUEST_URI} !^/\.well-known/acme-challenge [NC]
        RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301]
      '';
    };
  };
}
```

Now you need to configure ACME to generate a certificate.

```
security.acme.certs."foo.example.com" = {
  webroot = "/var/lib/acme/.challenges";
  email = "foo@example.com";
  # Ensure that the web server you use can read the generated certs
  # Take a look at the group option for the web server you choose.
  group = "nginx";
  # Since we have a wildcard vhost to handle port 80,
  # we can generate certs for anything!
  # Just make sure your DNS resolves them.
  extraDomainNames = [ "mail.example.com" ];
};
```

The private key {file}`key.pem` and certificate
{file}`fullchain.pem` will be put into
{file}`/var/lib/acme/foo.example.com`.

Refer to [](#ch-options) for all available configuration
options for the [security.acme](#opt-security.acme.certs)
module.

## Configuring ACME for DNS validation {#module-security-acme-config-dns}

This is useful if you want to generate a wildcard certificate, since
ACME servers will only hand out wildcard certs over DNS validation.
There are a number of supported DNS providers and servers you can utilise,
see the [lego docs](https://go-acme.github.io/lego/dns/)
for provider/server specific configuration values. For the sake of these
docs, we will provide a fully self-hosted example using bind.

```
services.bind = {
  enable = true;
  extraConfig = ''
    include "/var/lib/secrets/dnskeys.conf";
  '';
  zones = [
    rec {
      name = "example.com";
      file = "/var/db/bind/${name}";
      master = true;
      extraConfig = "allow-update { key rfc2136key.example.com.; };";
    }
  ];
}

# Now we can configure ACME
security.acme.acceptTerms = true;
security.acme.defaults.email = "admin+acme@example.com";
security.acme.certs."example.com" = {
  domain = "*.example.com";
  dnsProvider = "rfc2136";
  credentialsFile = "/var/lib/secrets/certs.secret";
  # We don't need to wait for propagation since this is a local DNS server
  dnsPropagationCheck = false;
};
```

The {file}`dnskeys.conf` and {file}`certs.secret`
must be kept secure and thus you should not keep their contents in your
Nix config. Instead, generate them one time with a systemd service:

```
systemd.services.dns-rfc2136-conf = {
  requiredBy = ["acme-example.com.service" "bind.service"];
  before = ["acme-example.com.service" "bind.service"];
  unitConfig = {
    ConditionPathExists = "!/var/lib/secrets/dnskeys.conf";
  };
  serviceConfig = {
    Type = "oneshot";
    UMask = 0077;
  };
  path = [ pkgs.bind ];
  script = ''
    mkdir -p /var/lib/secrets
    chmod 755 /var/lib/secrets
    tsig-keygen rfc2136key.example.com > /var/lib/secrets/dnskeys.conf
    chown named:root /var/lib/secrets/dnskeys.conf
    chmod 400 /var/lib/secrets/dnskeys.conf

    # extract secret value from the dnskeys.conf
    while read x y; do if [ "$x" = "secret" ]; then secret="''${y:1:''${#y}-3}"; fi; done < /var/lib/secrets/dnskeys.conf

    cat > /var/lib/secrets/certs.secret << EOF
    RFC2136_NAMESERVER='127.0.0.1:53'
    RFC2136_TSIG_ALGORITHM='hmac-sha256.'
    RFC2136_TSIG_KEY='rfc2136key.example.com'
    RFC2136_TSIG_SECRET='$secret'
    EOF
    chmod 400 /var/lib/secrets/certs.secret
  '';
};
```

Now you're all set to generate certs! You should monitor the first invocation
by running `systemctl start acme-example.com.service &
journalctl -fu acme-example.com.service` and watching its log output.

## Using DNS validation with web server virtual hosts {#module-security-acme-config-dns-with-vhosts}

It is possible to use DNS-01 validation with all certificates,
including those automatically configured via the Nginx/Apache
[`enableACME`](#opt-services.nginx.virtualHosts._name_.enableACME)
option. This configuration pattern is fully
supported and part of the module's test suite for Nginx + Apache.

You must follow the guide above on configuring DNS-01 validation
first, however instead of setting the options for one certificate
(e.g. [](#opt-security.acme.certs._name_.dnsProvider))
you will set them as defaults
(e.g. [](#opt-security.acme.defaults.dnsProvider)).

```
# Configure ACME appropriately
security.acme.acceptTerms = true;
security.acme.defaults.email = "admin+acme@example.com";
security.acme.defaults = {
  dnsProvider = "rfc2136";
  credentialsFile = "/var/lib/secrets/certs.secret";
  # We don't need to wait for propagation since this is a local DNS server
  dnsPropagationCheck = false;
};

# For each virtual host you would like to use DNS-01 validation with,
# set acmeRoot = null
services.nginx = {
  enable = true;
  virtualHosts = {
    "foo.example.com" = {
      enableACME = true;
      acmeRoot = null;
    };
  };
}
```

And that's it! Next time your configuration is rebuilt, or when
you add a new virtualHost, it will be DNS-01 validated.

## Using ACME with services demanding root owned certificates {#module-security-acme-root-owned}

Some services refuse to start if the configured certificate files
are not owned by root. PostgreSQL and OpenSMTPD are examples of these.
There is no way to change the user the ACME module uses (it will always be
`acme`), however you can use systemd's
`LoadCredential` feature to resolve this elegantly.
Below is an example configuration for OpenSMTPD, but this pattern
can be applied to any service.

```
# Configure ACME however you like (DNS or HTTP validation), adding
# the following configuration for the relevant certificate.
# Note: You cannot use `systemctl reload` here as that would mean
# the LoadCredential configuration below would be skipped and
# the service would continue to use old certificates.
security.acme.certs."mail.example.com".postRun = ''
  systemctl restart opensmtpd
'';

# Now you must augment OpenSMTPD's systemd service to load
# the certificate files.
systemd.services.opensmtpd.requires = ["acme-finished-mail.example.com.target"];
systemd.services.opensmtpd.serviceConfig.LoadCredential = let
  certDir = config.security.acme.certs."mail.example.com".directory;
in [
  "cert.pem:${certDir}/cert.pem"
  "key.pem:${certDir}/key.pem"
];

# Finally, configure OpenSMTPD to use these certs.
services.opensmtpd = let
  credsDir = "/run/credentials/opensmtpd.service";
in {
  enable = true;
  setSendmail = false;
  serverConfiguration = ''
    pki mail.example.com cert "${credsDir}/cert.pem"
    pki mail.example.com key "${credsDir}/key.pem"
    listen on localhost tls pki mail.example.com
    action act1 relay host smtp://127.0.0.1:10027
    match for local action act1
  '';
};
```

## Regenerating certificates {#module-security-acme-regenerate}

Should you need to regenerate a particular certificate in a hurry, such
as when a vulnerability is found in Let's Encrypt, there is now a convenient
mechanism for doing so. Running
`systemctl clean --what=state acme-example.com.service`
will remove all certificate files and the account data for the given domain,
allowing you to then `systemctl start acme-example.com.service`
to generate fresh ones.

## Fixing JWS Verification error {#module-security-acme-fix-jws}

It is possible that your account credentials file may become corrupt and need
to be regenerated. In this scenario lego will produce the error `JWS verification error`.
The solution is to simply delete the associated accounts file and
re-run the affected service(s).

```
# Find the accounts folder for the certificate
systemctl cat acme-example.com.service | grep -Po 'accounts/[^:]*'
export accountdir="$(!!)"
# Move this folder to some place else
mv /var/lib/acme/.lego/$accountdir{,.bak}
# Recreate the folder using systemd-tmpfiles
systemd-tmpfiles --create
# Get a new account and reissue certificates
# Note: Do this for all certs that share the same account email address
systemctl start acme-example.com.service
```
