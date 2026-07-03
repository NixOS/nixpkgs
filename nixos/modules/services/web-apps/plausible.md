# Plausible {#module-services-plausible}

[Plausible](https://plausible.io/) is a privacy-friendly alternative to
Google analytics.

## Basic Usage {#module-services-plausible-basic-usage}

At first, a secret key is needed to be generated. This can be done with e.g.
```ShellSession
$ openssl rand -base64 64
```

After that, `plausible` can be deployed like this:
```nix
{
  services.plausible = {
    enable = true;
    server = {
      baseUrl = "http://analytics.example.org";
      # secretKeybaseFile is a path to the file which contains the secret generated
      # with openssl as described above.
      secretKeybaseFile = "/run/secrets/plausible-secret-key-base";
      # With an admin user seeded (below), registration can be locked down
      # so only invited users (or nobody) can create further accounts.
      disableRegistration = "invite_only";
    };
    # If you do not declare `adminUser`, Plausible shows an unauthenticated
    # "first launch" setup wizard where anybody reaching the instance can create
    # the first admin account. That may be convenient, but is also a security
    # risk if somebody else uses it before you do.
    adminUser = {
      email = "admin@analytics.example.org";
      # passwordHashFile is a path to a file containing the bcrypt hash of the
      # admin user's password, e.g. generated with `mkpasswd -m bcrypt`.
      passwordHashFile = "/run/secrets/plausible-admin-password-hash";
    };
  };
}
```
