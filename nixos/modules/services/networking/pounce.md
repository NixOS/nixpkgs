# Pounce {#module-services-pounce}

[Pounce](https://git.causal.agency/pounce/about/) is a multi-client, TLS-only
IRC bouncer. Pounce includes the
[Calico](https://git.causal.agency/pounce/about/calico.1) dispatcher for
serving multiple networks over a single port.

## Basic Usage {#module-services-pounce-quick-start}

To support connecting to multiple networks, Pounce will always be configured
to serve through Calico with each network's bouncer at a subdomain of
{option}`service.pounce.host`.

A complete list of Pounce's options is availiable in the
[pounce(1)](https://git.causal.agency/pounce/about/pounce.1) manual page. For
additional notes about connecting to various popular networks, see Pounce's
[QUIRKS(7)](https://git.causal.agency/pounce/about/QUIRKS.7) document.

Pounce must be served over TLS. By default, this module will generate a
self-signed certificate valid for 100 years. To disable this, set
{option}`services.pounce.generateCerts` to `false` and point
{option}`services.pounce.certDir` to a folder containing TLS certificates in
the certbot format (a {file}`fullchain.pem` and {file}`privkey.pem` in a
folder named the full domain name of the instance). Certificates can be
generated with certbot using {command}`certbot certonly -d ...`, or using
NixOS's built-in ACME module.

Below is an example configuration which joins #nixos and #nixos-chat on Libera
Chat and #ascii.town on tilde.chat. The bouncer for Libera Chat can be reached
at `libera.irc.example.org/6697`, and will and connect with CertFP using the
certificate stored at {file}`/var/lib/pounce/certfp/libera.pem` (This
certificate can be generated with
{command}`pounce -g /var/lib/pounce/certfp/libera.pem`). The bouncer for
tilde.chat is at `tilde.irc.example.org/6697` and is additionally configured
to run the script {file}`/var/lib/pounce/notify.sh` when the user is messaged
or mentioned and no clients are currently connected to the bouncer.

```nix
services.pounce = {
  enable = true;
  host = "irc.example.org";
  openFirewall = true;
  networks = {
    libera.config = {
      host = "irc.libera.chat";
      port = 6697; # This is the default port. This field can be ommitted.
      nick = "...";
      client-cert = "/var/lib/pounce/certfp/libera.pem";
      sasl-external = true;
      join = "#nixos,#nixos-chat";
    };
    tilde = {
      config = {
        host = "irc.tilde.chat";
        nick = "...";
        join = "#ascii.town";
      };
      notify.command = "/var/lib/pounce/notify.sh";
    };
  };
};
```
