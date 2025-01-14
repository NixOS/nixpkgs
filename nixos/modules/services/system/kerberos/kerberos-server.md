# kerberos_server {#module-services-kerberos-server}

Kerberos is a computer-network authentication protocol that works on the basis of tickets to allow nodes communicating over a non-secure network to prove their identity to one another in a secure manner.

This module provides both the MIT and Heimdal implementations of the a Kerberos server.

## Usage {#module-services-kerberos-server-usage}

To enable a Kerberos server:

```nix
{
  security.krb5 = {
    # Here you can choose between the MIT and Heimdal implementations.
    package = pkgs.krb5;
    # package = pkgs.heimdal;

    # Optionally set up a client on the same machine as the server
    enable = true;
    settings = {
      libdefaults.default_realm = "EXAMPLE.COM";
      realms."EXAMPLE.COM" = {
        kdc = "kerberos.example.com";
        admin_server = "kerberos.example.com";
      };
    };
  }

  services.kerberos-server = {
    enable = true;
    settings = {
      realms."EXAMPLE.COM" = {
        acl = [{ principal = "adminuser"; access=  ["add" "cpw"]; }];
      };
    };
  };
}
```

## Notes {#module-services-kerberos-server-notes}

- The Heimdal documentation will sometimes assume that state is stored in `/var/heimdal`, but this module uses `/var/lib/heimdal` instead.
- Due to the heimdal implementation being chosen through `security.krb5.package`, it is not possible to have a system with one implementation of the client and another of the server.
- While `services.kerberos_server.settings` has a common freeform type between the two implementations, the actual settings that can be set can vary between the two implementations. To figure out what settings are available, you should consult the upstream documentation for the implementation you are using.

## Upstream Documentation {#module-services-kerberos-server-upstream-documentation}

- MIT Kerberos homepage: https://web.mit.edu/kerberos
- MIT Kerberos docs: https://web.mit.edu/kerberos/krb5-latest/doc/index.html

- Heimdal Kerberos GitHub wiki: https://github.com/heimdal/heimdal/wiki
- Heimdal kerberos doc manpages (Debian unstable): https://manpages.debian.org/unstable/heimdal-docs/index.html
- Heimdal Kerberos kdc manpages (Debian unstable): https://manpages.debian.org/unstable/heimdal-kdc/index.html

Note the version number in the URLs, it may be different for the latest version.
