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
    adminUser = {
      # activate is used to skip the email verification of the admin-user that's
      # automatically created by plausible. This is only supported if
      # postgresql is configured by the module. This is done by default, but
      # can be turned off with services.plausible.database.postgres.setup.
      activate = true;
      email = "admin@localhost";
      passwordFile = "/run/secrets/plausible-admin-pwd";
    };
    server = {
      baseUrl = "http://analytics.example.org";
      # secretKeybaseFile is a path to the file which contains the secret generated
      # with openssl as described above.
      secretKeybaseFile = "/run/secrets/plausible-secret-key-base";
    };
  };
}
```
