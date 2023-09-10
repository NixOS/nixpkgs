# Discourse {#module-services-discourse}

[Discourse](https://www.discourse.org/) is a
modern and open source discussion platform.

## Basic usage {#module-services-discourse-basic-usage}

A minimal configuration using Let's Encrypt for TLS certificates looks like this:
```
services.discourse = {
  enable = true;
  hostname = "discourse.example.com";
  admin = {
    email = "admin@example.com";
    username = "admin";
    fullName = "Administrator";
    passwordFile = "/path/to/password_file";
  };
  secretKeyBaseFile = "/path/to/secret_key_base_file";
};
security.acme.email = "me@example.com";
security.acme.acceptTerms = true;
```

Provided a proper DNS setup, you'll be able to connect to the
instance at `discourse.example.com` and log in
using the credentials provided in
`services.discourse.admin`.

## Using a regular TLS certificate {#module-services-discourse-tls}

To set up TLS using a regular certificate and key on file, use
the [](#opt-services.discourse.sslCertificate)
and [](#opt-services.discourse.sslCertificateKey)
options:

```
services.discourse = {
  enable = true;
  hostname = "discourse.example.com";
  sslCertificate = "/path/to/ssl_certificate";
  sslCertificateKey = "/path/to/ssl_certificate_key";
  admin = {
    email = "admin@example.com";
    username = "admin";
    fullName = "Administrator";
    passwordFile = "/path/to/password_file";
  };
  secretKeyBaseFile = "/path/to/secret_key_base_file";
};
```

## Database access {#module-services-discourse-database}

Discourse uses PostgreSQL to store most of its
data. A database will automatically be enabled and a database
and role created unless [](#opt-services.discourse.database.host) is changed from
its default of `null` or [](#opt-services.discourse.database.createLocally) is set
to `false`.

External database access can also be configured by setting
[](#opt-services.discourse.database.host),
[](#opt-services.discourse.database.username) and
[](#opt-services.discourse.database.passwordFile) as
appropriate. Note that you need to manually create a database
called `discourse` (or the name you chose in
[](#opt-services.discourse.database.name)) and
allow the configured database user full access to it.

## Email {#module-services-discourse-mail}

In addition to the basic setup, you'll want to configure an SMTP
server Discourse can use to send user
registration and password reset emails, among others. You can
also optionally let Discourse receive
email, which enables people to reply to threads and conversations
via email.

A basic setup which assumes you want to use your configured
[hostname](#opt-services.discourse.hostname) as
email domain can be done like this:

```
services.discourse = {
  enable = true;
  hostname = "discourse.example.com";
  sslCertificate = "/path/to/ssl_certificate";
  sslCertificateKey = "/path/to/ssl_certificate_key";
  admin = {
    email = "admin@example.com";
    username = "admin";
    fullName = "Administrator";
    passwordFile = "/path/to/password_file";
  };
  mail.outgoing = {
    serverAddress = "smtp.emailprovider.com";
    port = 587;
    username = "user@emailprovider.com";
    passwordFile = "/path/to/smtp_password_file";
  };
  mail.incoming.enable = true;
  secretKeyBaseFile = "/path/to/secret_key_base_file";
};
```

This assumes you have set up an MX record for the address you've
set in [hostname](#opt-services.discourse.hostname) and
requires proper SPF, DKIM and DMARC configuration to be done for
the domain you're sending from, in order for email to be reliably delivered.

If you want to use a different domain for your outgoing email
(for example `example.com` instead of
`discourse.example.com`) you should set
[](#opt-services.discourse.mail.notificationEmailAddress) and
[](#opt-services.discourse.mail.contactEmailAddress) manually.

::: {.note}
Setup of TLS for incoming email is currently only configured
automatically when a regular TLS certificate is used, i.e. when
[](#opt-services.discourse.sslCertificate) and
[](#opt-services.discourse.sslCertificateKey) are
set.
:::

## Additional settings {#module-services-discourse-settings}

Additional site settings and backend settings, for which no
explicit NixOS options are provided,
can be set in [](#opt-services.discourse.siteSettings) and
[](#opt-services.discourse.backendSettings) respectively.

### Site settings {#module-services-discourse-site-settings}

"Site settings" are the settings that can be
changed through the Discourse
UI. Their *default* values can be set using
[](#opt-services.discourse.siteSettings).

Settings are expressed as a Nix attribute set which matches the
structure of the configuration in
[config/site_settings.yml](https://github.com/discourse/discourse/blob/master/config/site_settings.yml).
To find a setting's path, you only need to care about the first
two levels; i.e. its category (e.g. `login`)
and name (e.g. `invite_only`).

Settings containing secret data should be set to an attribute
set containing the attribute `_secret` - a
string pointing to a file containing the value the option
should be set to. See the example.

### Backend settings {#module-services-discourse-backend-settings}

Settings are expressed as a Nix attribute set which matches the
structure of the configuration in
[config/discourse.conf](https://github.com/discourse/discourse/blob/stable/config/discourse_defaults.conf).
Empty parameters can be defined by setting them to
`null`.

### Example {#module-services-discourse-settings-example}

The following example sets the title and description of the
Discourse instance and enables
GitHub login in the site settings,
and changes a few request limits in the backend settings:
```
services.discourse = {
  enable = true;
  hostname = "discourse.example.com";
  sslCertificate = "/path/to/ssl_certificate";
  sslCertificateKey = "/path/to/ssl_certificate_key";
  admin = {
    email = "admin@example.com";
    username = "admin";
    fullName = "Administrator";
    passwordFile = "/path/to/password_file";
  };
  mail.outgoing = {
    serverAddress = "smtp.emailprovider.com";
    port = 587;
    username = "user@emailprovider.com";
    passwordFile = "/path/to/smtp_password_file";
  };
  mail.incoming.enable = true;
  siteSettings = {
    required = {
      title = "My Cats";
      site_description = "Discuss My Cats (and be nice plz)";
    };
    login = {
      enable_github_logins = true;
      github_client_id = "a2f6dfe838cb3206ce20";
      github_client_secret._secret = /run/keys/discourse_github_client_secret;
    };
  };
  backendSettings = {
    max_reqs_per_ip_per_minute = 300;
    max_reqs_per_ip_per_10_seconds = 60;
    max_asset_reqs_per_ip_per_10_seconds = 250;
    max_reqs_per_ip_mode = "warn+block";
  };
  secretKeyBaseFile = "/path/to/secret_key_base_file";
};
```

In the resulting site settings file, the
`login.github_client_secret` key will be set
to the contents of the
{file}`/run/keys/discourse_github_client_secret`
file.

## Plugins {#module-services-discourse-plugins}

You can install Discourse plugins
using the [](#opt-services.discourse.plugins)
option. Pre-packaged plugins are provided in
`<your_discourse_package_here>.plugins`. If
you want the full suite of plugins provided through
`nixpkgs`, you can also set the [](#opt-services.discourse.package) option to
`pkgs.discourseAllPlugins`.

Plugins can be built with the
`<your_discourse_package_here>.mkDiscoursePlugin`
function. Normally, it should suffice to provide a
`name` and `src` attribute. If
the plugin has Ruby dependencies, however, they need to be
packaged in accordance with the [Developing with Ruby](https://nixos.org/manual/nixpkgs/stable/#developing-with-ruby)
section of the Nixpkgs manual and the
appropriate gem options set in `bundlerEnvArgs`
(normally `gemdir` is sufficient). A plugin's
Ruby dependencies are listed in its
{file}`plugin.rb` file as function calls to
`gem`. To construct the corresponding
{file}`Gemfile` manually, run {command}`bundle init`, then add the `gem` lines to it
verbatim.

Much of the packaging can be done automatically by the
{file}`nixpkgs/pkgs/servers/web-apps/discourse/update.py`
script - just add the plugin to the `plugins`
list in the `update_plugins` function and run
the script:
```bash
./update.py update-plugins
```

Some plugins provide [site settings](#module-services-discourse-site-settings).
Their defaults can be configured using [](#opt-services.discourse.siteSettings), just like
regular site settings. To find the names of these settings, look
in the `config/settings.yml` file of the plugin
repo.

For example, to add the [discourse-spoiler-alert](https://github.com/discourse/discourse-spoiler-alert)
and [discourse-solved](https://github.com/discourse/discourse-solved)
plugins, and disable `discourse-spoiler-alert`
by default:

```
services.discourse = {
  enable = true;
  hostname = "discourse.example.com";
  sslCertificate = "/path/to/ssl_certificate";
  sslCertificateKey = "/path/to/ssl_certificate_key";
  admin = {
    email = "admin@example.com";
    username = "admin";
    fullName = "Administrator";
    passwordFile = "/path/to/password_file";
  };
  mail.outgoing = {
    serverAddress = "smtp.emailprovider.com";
    port = 587;
    username = "user@emailprovider.com";
    passwordFile = "/path/to/smtp_password_file";
  };
  mail.incoming.enable = true;
  plugins = with config.services.discourse.package.plugins; [
    discourse-spoiler-alert
    discourse-solved
  ];
  siteSettings = {
    plugins = {
      spoiler_enabled = false;
    };
  };
  secretKeyBaseFile = "/path/to/secret_key_base_file";
};
```
