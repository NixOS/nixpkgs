# Prosody {#module-services-prosody}

[Prosody](https://prosody.im/) is an open-source, modern XMPP server.

## Basic usage {#module-services-prosody-basic-usage}

A common struggle for most XMPP newcomers is to find the right set
of XMPP Extensions (XEPs) to setup. Forget to activate a few of
those and your XMPP experience might turn into a nightmare!

The XMPP community tackles this problem by creating a meta-XEP
listing a decent set of XEPs you should implement. This meta-XEP
is issued every year, the 2020 edition being
[XEP-0423](https://xmpp.org/extensions/xep-0423.html).

The NixOS Prosody module will implement most of these recommendend XEPs out of
the box. That being said, two components still require some
manual configuration: the
[Multi User Chat (MUC)](https://xmpp.org/extensions/xep-0045.html)
and the [HTTP File Upload](https://xmpp.org/extensions/xep-0363.html) ones.
You'll need to create a DNS subdomain for each of those. The current convention is to name your
MUC endpoint `conference.example.org` and your HTTP upload domain `upload.example.org`.

A good configuration to start with, including a
[Multi User Chat (MUC)](https://xmpp.org/extensions/xep-0045.html)
endpoint as well as a [HTTP File Upload](https://xmpp.org/extensions/xep-0363.html)
endpoint will look like this:
```
services.prosody = {
  enable = true;
  admins = [ "root@example.org" ];
  ssl.cert = "/var/lib/acme/example.org/fullchain.pem";
  ssl.key = "/var/lib/acme/example.org/key.pem";
  virtualHosts."example.org" = {
      enabled = true;
      domain = "example.org";
      ssl.cert = "/var/lib/acme/example.org/fullchain.pem";
      ssl.key = "/var/lib/acme/example.org/key.pem";
  };
  muc = [ {
      domain = "conference.example.org";
  } ];
  uploadHttp = {
      domain = "upload.example.org";
  };
};
```

## Let's Encrypt Configuration {#module-services-prosody-letsencrypt}

As you can see in the code snippet from the
[previous section](#module-services-prosody-basic-usage),
you'll need a single TLS certificate covering your main endpoint,
the MUC one as well as the HTTP Upload one. We can generate such a
certificate by leveraging the ACME
[extraDomainNames](#opt-security.acme.certs._name_.extraDomainNames) module option.

Provided the setup detailed in the previous section, you'll need the following acme configuration to generate
a TLS certificate for the three endponits:
```
security.acme = {
  email = "root@example.org";
  acceptTerms = true;
  certs = {
    "example.org" = {
      webroot = "/var/www/example.org";
      email = "root@example.org";
      extraDomainNames = [ "conference.example.org" "upload.example.org" ];
    };
  };
};
```
