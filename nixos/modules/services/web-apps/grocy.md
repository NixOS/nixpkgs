# Grocy {#module-services-grocy}

[Grocy](https://grocy.info/) is a web-based self-hosted groceries
& household management solution for your home.

## Basic usage {#module-services-grocy-basic-usage}

A very basic configuration may look like this:
```
{ pkgs, ... }:
{
  services.grocy = {
    enable = true;
    hostName = "grocy.tld";
  };
}
```
This configures a simple vhost using [nginx](#opt-services.nginx.enable)
which listens to `grocy.tld` with fully configured ACME/LE (this can be
disabled by setting [services.grocy.nginx.enableSSL](#opt-services.grocy.nginx.enableSSL)
to `false`). After the initial setup the credentials `admin:admin`
can be used to login.

The application's state is persisted at `/var/lib/grocy/grocy.db` in a
`sqlite3` database. The migration is applied when requesting the `/`-route
of the application.

## Settings {#module-services-grocy-settings}

The configuration for `grocy` is located at `/etc/grocy/config.php`.
By default, the following settings can be defined in the NixOS-configuration:
```
{ pkgs, ... }:
{
  services.grocy.settings = {
    # The default currency in the system for invoices etc.
    # Please note that exchange rates aren't taken into account, this
    # is just the setting for what's shown in the frontend.
    currency = "EUR";

    # The display language (and locale configuration) for grocy.
    culture = "de";

    calendar = {
      # Whether or not to show the week-numbers
      # in the calendar.
      showWeekNumber = true;

      # Index of the first day to be shown in the calendar (0=Sunday, 1=Monday,
      # 2=Tuesday and so on).
      firstDayOfWeek = 2;
    };
  };
}
```

If you want to alter the configuration file on your own, you can do this manually with
an expression like this:
```
{ lib, ... }:
{
  environment.etc."grocy/config.php".text = lib.mkAfter ''
    // Arbitrary PHP code in grocy's configuration file
  '';
}
```
