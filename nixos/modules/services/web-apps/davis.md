# Davis {#module-services-davis}

[Davis](https://github.com/tchapi/davis/) is a caldav and carrddav server. It
has a simple, fully translatable admin interface for sabre/dav based on Symfony
5 and Bootstrap 5, initially inspired by Baïkal.

## Basic Usage {#module-services-davis-basic-usage}

At first, an application secret is needed, this can be generated with:
```ShellSession
$ cat /dev/urandom | tr -dc a-zA-Z0-9 | fold -w 48 | head -n 1
```

After that, `davis` can be deployed like this:
```
{
  services.davis = {
    enable = true;
    hostname = "davis.example.com";
    mail = {
      dsn = "smtp://username@example.com:25";
      inviteFromAddress = "davis@example.com";
    };
    adminLogin = "admin";
    adminPasswordFile = "/run/secrets/davis-admin-password";
    appSecretFile = "/run/secrets/davis-app-secret";
    nginx = {};
  };
}
```

This deploys Davis using a sqlite database running out of `/var/lib/davis`.
