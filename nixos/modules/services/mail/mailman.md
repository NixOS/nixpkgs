# Mailman {#module-services-mailman}

[Mailman](https://www.list.org) is free
software for managing electronic mail discussion and e-newsletter
lists. Mailman and its web interface can be configured using the
corresponding NixOS module. Note that this service is best used with
an existing, securely configured Postfix setup, as it does not automatically configure this.

## Basic usage with Postfix {#module-services-mailman-basic-usage}

For a basic configuration with Postfix as the MTA, the following settings are suggested:
```nix
{ config, ... }: {
  services.postfix = {
    enable = true;
    relayDomains = ["hash:/var/lib/mailman/data/postfix_domains"];
    sslCert = config.security.acme.certs."lists.example.org".directory + "/full.pem";
    sslKey = config.security.acme.certs."lists.example.org".directory + "/key.pem";
    config = {
      transport_maps = ["hash:/var/lib/mailman/data/postfix_lmtp"];
      local_recipient_maps = ["hash:/var/lib/mailman/data/postfix_lmtp"];
    };
  };
  services.mailman = {
    enable = true;
    serve.enable = true;
    hyperkitty.enable = true;
    webHosts = ["lists.example.org"];
    siteOwner = "mailman@example.org";
  };
  services.nginx.virtualHosts."lists.example.org".enableACME = true;
  networking.firewall.allowedTCPPorts = [ 25 80 443 ];
}
```

DNS records will also be required:

  - `AAAA` and `A` records pointing to the host in question, in order for browsers to be able to discover the address of the web server;
  - An `MX` record pointing to a domain name at which the host is reachable, in order for other mail servers to be able to deliver emails to the mailing lists it hosts.

After this has been done and appropriate DNS records have been
set up, the Postorius mailing list manager and the Hyperkitty
archive browser will be available at
https://lists.example.org/. Note that this setup is not
sufficient to deliver emails to most email providers nor to
avoid spam -- a number of additional measures for authenticating
incoming and outgoing mails, such as SPF, DMARC and DKIM are
necessary, but outside the scope of the Mailman module.

## Using with other MTAs {#module-services-mailman-other-mtas}

Mailman also supports other MTA, though with a little bit more configuration. For example, to use Mailman with Exim, you can use the following settings:
```nix
{ config, ... }: {
  services = {
    mailman = {
      enable = true;
      siteOwner = "mailman@example.org";
      enablePostfix = false;
      settings.mta = {
        incoming = "mailman.mta.exim4.LMTP";
        outgoing = "mailman.mta.deliver.deliver";
        lmtp_host = "localhost";
        lmtp_port = "8024";
        smtp_host = "localhost";
        smtp_port = "25";
        configuration = "python:mailman.config.exim4";
      };
    };
    exim = {
      enable = true;
      # You can configure Exim in a separate file to reduce configuration.nix clutter
      config = builtins.readFile ./exim.conf;
    };
  };
}
```

The exim config needs some special additions to work with Mailman. Currently
NixOS can't manage Exim config with such granularity. Please refer to
[Mailman documentation](https://mailman.readthedocs.io/en/latest/src/mailman/docs/mta.html)
for more info on configuring Mailman for working with Exim.
