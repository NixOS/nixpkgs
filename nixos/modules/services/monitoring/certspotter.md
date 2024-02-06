# Cert Spotter {#module-services-certspotter}

Cert Spotter is a tool for monitoring [Certificate Transparency](https://en.wikipedia.org/wiki/Certificate_Transparency)
logs.

## Service Configuration {#modules-services-certspotter-service-configuration}

A basic config that notifies you of all certificate changes for your
domain would look as follows:

```nix
services.certspotter = {
  enable = true;
  # replace example.org with your domain name
  watchlist = [ ".example.org" ];
  emailRecipients = [ "webmaster@example.org" ];
};

# Configure an SMTP client
programs.msmtp.enable = true;
# Or you can use any other module that provides sendmail, like
# services.nullmailer, services.opensmtpd, services.postfix
```

In this case, the leading dot in `".example.org"` means that Cert
Spotter should monitor not only `example.org`, but also all of its
subdomains.

## Operation {#modules-services-certspotter-operation}

**By default, NixOS configures Cert Spotter to skip all certificates
issued before its first launch**, because checking the entire
Certificate Transparency logs requires downloading tens of terabytes of
data. If you want to check the *entire* logs for previously issued
certificates, you have to set `services.certspotter.startAtEnd` to
`false` and remove all previously saved log state in
`/var/lib/certspotter/logs`. The downloaded logs aren't saved, so if you
add a new domain to the watchlist and want Cert Spotter to go through
the logs again, you will have to remove `/var/lib/certspotter/logs`
again.

After catching up with the logs, Cert Spotter will start monitoring live
logs. As of October 2023, it uses around **20 Mbps** of traffic on
average.

## Hooks {#modules-services-certspotter-hooks}

Cert Spotter supports running custom hooks instead of (or in addition
to) sending emails. Hooks are shell scripts that will be passed certain
environment variables.

To see hook documentation, see Cert Spotter's man pages:

```ShellSession
nix-shell -p certspotter --run 'man 8 certspotter-script'
```

For example, you can remove `emailRecipients` and send email
notifications manually using the following hook:

```nix
services.certspotter.hooks = [
  (pkgs.writeShellScript "certspotter-hook" ''
    function print_email() {
      echo "Subject: [certspotter] $SUMMARY"
      echo "Mime-Version: 1.0"
      echo "Content-Type: text/plain; charset=US-ASCII"
      echo
      cat "$TEXT_FILENAME"
    }
    print_email | ${config.services.certspotter.sendmailPath} -i webmaster@example.org
  '')
];
```
