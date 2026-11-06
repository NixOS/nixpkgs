# Casdoor {#module-services-casdoor}

Casdoor is an open-source identity and access management (IAM) / single
sign-on server. It speaks OAuth 2.0, OIDC, SAML 2.0, CAS, LDAP, SCIM 2.0 and
WebAuthn, and it ships a web console for managing organizations, applications,
users, providers and permissions.

## Quickstart {#module-services-casdoor-quickstart}

The following configuration starts Casdoor on port 8000, backed by a SQLite
database in the service's state directory:

```nix
{
  services.casdoor = {
    enable = true;
    settings.origin = "http://localhost:8000";
  };
}
```

The configuration of the server itself lives under
{option}`services.casdoor.settings`, which mirrors the keys of the upstream
configuration file. The options that control the module rather than the
server, such as {option}`services.casdoor.port`,
{option}`services.casdoor.package` or
{option}`services.casdoor.environmentFile`, stay at the top level.

Casdoor always listens on all interfaces and has no option to bind only to
localhost. The firewall is closed by default, so only local clients can reach
the service until the port is opened or a reverse proxy is put in front of it.

The built-in account is `admin` in the `built-in` organization. If no password
is configured, Casdoor starts with an empty password for that account and the
first visitor to the welcome page can set it. Either set the password
explicitly or complete the welcome flow immediately after the first start:

```nix
{
  services.casdoor.settings.initAdminPassword = "a-long-passphrase";
}
```

The value of {option}`services.casdoor.settings.initAdminPassword` is passed
through systemd's environment, so it is visible in the Nix store and to local
users. In production, put `initAdminPassword=...` in a root-readable
environment file and set {option}`services.casdoor.environmentFile` instead:

```nix
{
  services.casdoor.environmentFile = "/run/secrets/casdoor.env";
}
```

Casdoor derives the URLs in its OAuth and OIDC responses from the `Host`
header of the request. When the instance is reachable under a public name,
that name has to be given in {option}`services.casdoor.settings.origin`, and
the instance has to be served over HTTPS.

## Behind a reverse proxy {#module-services-casdoor-reverse-proxy}

When the console is served through nginx, the proxy has to pass the original
`Host` header along, otherwise Casdoor builds URLs pointing at the internal
address:

```nix
{
  services.casdoor = {
    enable = true;
    settings.origin = "https://casdoor.example.com";
  };

  services.nginx = {
    enable = true;
    virtualHosts."casdoor.example.com" = {
      serverName = "casdoor.example.com";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}
```

## Using an external database {#module-services-casdoor-database}

SQLite is convenient, but it only supports a single instance. For a setup
with MySQL, PostgreSQL or Microsoft SQL Server, set the driver and the
connection string:

```nix
{
  services.casdoor = {
    enable = true;
    createDatabase = true;
    settings = {
      driverName = "postgres";
      dataSourceName = "user=casdoor host=localhost dbname=casdoor";
      dbName = "casdoor";
    };
  };
}
```

`dataSourceName` is required for every driver except SQLite. For SQL Server,
use the driver name `mssql`. The `createDatabase` option is only supported by
the MySQL and PostgreSQL drivers. If the connection string contains a
password, put it in {option}`services.casdoor.environmentFile` rather than in
`dataSourceName`, because option values are stored in the Nix store. When
{option}`services.casdoor.environmentFile` is set, it satisfies the
`dataSourceName` requirement on its own, because the file can provide the
`dataSourceName` variable:

```nix
{
  services.casdoor = {
    enable = true;
    settings = {
      driverName = "postgres";
      dbName = "casdoor";
    };
    environmentFile = "/run/secrets/casdoor.env";
  };
}
```

The environment file then holds the connection string:

```bash
dataSourceName=user=casdoor password=secret host=localhost dbname=casdoor
```

Casdoor reads its configuration from the environment first and only falls
back to its configuration file, so the connection string in the environment
file takes precedence over the `dataSourceName` option. The module accepts
either way of setting it, so no placeholder has to be put into the option.

## Running more than one instance {#module-services-casdoor-redis}

Casdoor stores sessions in files below its working directory when no Redis
server is configured, which does not work with more than one replica. Point
{option}`services.casdoor.settings.redisEndpoint` at a Redis server in that
case.

## Initial data {#module-services-casdoor-initial-data}

{option}`services.casdoor.settings.initDataFile` can point at a JSON or YAML
file with initial objects. The file has to be readable by the Casdoor user and
is not modified by Casdoor. It is applied on startup and, when
{option}`services.casdoor.settings.initDataWatchInterval` is greater than zero,
checked periodically for changes.

By default, existing objects are deleted and recreated from the file. With
{option}`services.casdoor.settings.initDataMerge` enabled, existing objects
are merged with the data from the file instead, and masked secrets are
preserved.

## LDAP and RADIUS listeners {#module-services-casdoor-ldap-radius}

Besides the HTTP API, Casdoor starts an LDAP listener on port 389, an LDAPS
listener on port 636 and a RADIUS listener on port 1812. All of them listen on
all interfaces. {option}`services.casdoor.openFirewall` only opens the HTTP
port, not these additional ports.

Set {option}`services.casdoor.settings.ldapServerPort` or
{option}`services.casdoor.settings.ldapsServerPort` to zero if the
corresponding listener is not needed. The RADIUS listener cannot be disabled:
setting {option}`services.casdoor.settings.radiusServerPort` to zero makes it
bind an ephemeral port instead. Change
{option}`services.casdoor.settings.radiusSecret` from its default before
exposing the RADIUS listener.

## Customising the web console {#module-services-casdoor-web-console}

The web console is pre-built and shipped as part of the Casdoor package. Two
options change what it contains.

{option}`services.casdoor.customFooter` replaces the "Powered by Casdoor" line
at the bottom of the console with an HTML fragment:

```nix
{
  services.casdoor.customFooter = "<span>Powered by <a href=\"https://example.com\">Example</a></span>";
}
```

The value is inserted as markup, not as text, so it can contain links and
other HTML. Do not put untrusted input into it.

{option}`services.casdoor.showCloudPromotion` controls whether the links to
Casdoor Cloud are shown in the console. It defaults to `false`.

Both options are compiled into the package, so changing them replaces the
whole Casdoor package in the store. The backend can override
`showCloudPromotion` at runtime through its global settings, in which case the
runtime value wins over the one set here.

## Additional configuration {#module-services-casdoor-extra-configuration}

Every key that Casdoor reads through its configuration loader can be set
through {option}`services.casdoor.extraConfig`. Values are passed as strings
and are applied before the options under
{option}`services.casdoor.settings`, so those options take precedence.
Secrets placed here are visible in the Nix store; prefer
{option}`services.casdoor.environmentFile` for those.
For example, to configure WebAuthn:

```nix
{
  services.casdoor.extraConfig = {
    webAuthnRpId = "casdoor.example.com";
    webAuthnRpOrigins = "https://casdoor.example.com";
  };
}
```

Settings that are left empty are not passed to the server at all, so the
values from the upstream configuration file stay in effect. A setting that is
set, even to an empty string, replaces the value from the file.
