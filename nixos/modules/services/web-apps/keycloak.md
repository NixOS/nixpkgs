# Keycloak {#module-services-keycloak}

[Keycloak](https://www.keycloak.org/) is an
open source identity and access management server with support for
[OpenID Connect](https://openid.net/connect/),
[OAUTH 2.0](https://oauth.net/2/) and
[SAML 2.0](https://en.wikipedia.org/wiki/SAML_2.0).

## Administration {#module-services-keycloak-admin}

An administrative user with the username
`admin` is automatically created in the
`master` realm. Its initial password can be
configured by setting [](#opt-services.keycloak.initialAdminPassword)
and defaults to `changeme`. The password is
not stored safely and should be changed immediately in the
admin panel.

Refer to the [Keycloak Server Administration Guide](
  https://www.keycloak.org/docs/latest/server_admin/index.html
) for information on
how to administer your Keycloak
instance.

## Database access {#module-services-keycloak-database}

Keycloak can be used with either PostgreSQL, MariaDB or
MySQL. Which one is used can be
configured in [](#opt-services.keycloak.database.type). The selected
database will automatically be enabled and a database and role
created unless [](#opt-services.keycloak.database.host) is changed
from its default of `localhost` or
[](#opt-services.keycloak.database.createLocally) is set to `false`.

External database access can also be configured by setting
[](#opt-services.keycloak.database.host),
[](#opt-services.keycloak.database.name),
[](#opt-services.keycloak.database.username),
[](#opt-services.keycloak.database.useSSL) and
[](#opt-services.keycloak.database.caCert) as
appropriate. Note that you need to manually create the database
and allow the configured database user full access to it.

[](#opt-services.keycloak.database.passwordFile)
must be set to the path to a file containing the password used
to log in to the database. If [](#opt-services.keycloak.database.host)
and [](#opt-services.keycloak.database.createLocally)
are kept at their defaults, the database role
`keycloak` with that password is provisioned
on the local database instance.

::: {.warning}
The path should be provided as a string, not a Nix path, since Nix
paths are copied into the world readable Nix store.
:::

## Hostname {#module-services-keycloak-hostname}

The hostname is used to build the public URL used as base for
all frontend requests and must be configured through
[](#opt-services.keycloak.settings.hostname).

::: {.note}
If you're migrating an old Wildfly based Keycloak instance
and want to keep compatibility with your current clients,
you'll likely want to set [](#opt-services.keycloak.settings.http-relative-path)
to `/auth`. See the option description
for more details.
:::

[](#opt-services.keycloak.settings.hostname-backchannel-dynamic)
Keycloak has the capability to offer a separate URL for backchannel requests,
enabling internal communication while maintaining the use of a public URL
for frontchannel requests. Moreover, the backchannel is dynamically
resolved based on incoming headers endpoint.

For more information on hostname configuration, see the [Hostname
section of the Keycloak Server Installation and Configuration
Guide](https://www.keycloak.org/server/hostname).

## Setting up TLS/SSL {#module-services-keycloak-tls}

By default, Keycloak won't accept
unsecured HTTP connections originating from outside its local
network.

HTTPS support requires a TLS/SSL certificate and a private key,
both [PEM formatted](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail).
Their paths should be set through
[](#opt-services.keycloak.sslCertificate) and
[](#opt-services.keycloak.sslCertificateKey).

::: {.warning}
 The paths should be provided as a strings, not a Nix paths,
since Nix paths are copied into the world readable Nix store.
:::

## Themes {#module-services-keycloak-themes}

You can package custom themes and make them visible to
Keycloak through [](#opt-services.keycloak.themes). See the
[Themes section of the Keycloak Server Development Guide](
  https://www.keycloak.org/docs/latest/server_development/#_themes
) and the description of the aforementioned NixOS option for
more information.

## Configuration file settings {#module-services-keycloak-settings}

Keycloak server configuration parameters can be set in
[](#opt-services.keycloak.settings). These correspond
directly to options in
{file}`conf/keycloak.conf`. Some of the most
important parameters are documented as suboptions, the rest can
be found in the [All
configuration section of the Keycloak Server Installation and
Configuration Guide](https://www.keycloak.org/server/all-config).

Options containing secret data should be set to an attribute
set containing the attribute `_secret` - a
string pointing to a file containing the value the option
should be set to. See the description of
[](#opt-services.keycloak.settings) for an example.

## Example configuration {#module-services-keycloak-example-config}

A basic configuration with some custom settings could look like this:
```nix
{
  services.keycloak = {
    enable = true;
    settings = {
      hostname = "keycloak.example.com";
      hostname-strict-backchannel = true;
    };
    initialAdminPassword = "e6Wcm0RrtegMEHl";  # change on first login
    sslCertificate = "/run/keys/ssl_cert";
    sslCertificateKey = "/run/keys/ssl_key";
    database.passwordFile = "/run/keys/db_password";
  };
}
```
