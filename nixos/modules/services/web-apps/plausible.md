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
    };
  };
}
```
