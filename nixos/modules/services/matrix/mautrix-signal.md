# Mautrix-Signal {#module-services-mautrix-signal}

[Mautrix-Signal](https://github.com/mautrix/signal) is a Matrix-Signal puppeting bridge.

## Configuration {#module-services-mautrix-signal-configuration}

1. Set [](#opt-services.mautrix-signal.enable) to `true`. The service will use
   SQLite by default.
2. To create your configuration check the default configuration for
   [](#opt-services.mautrix-signal.settings). To obtain the complete default
   configuration, run
   `nix-shell -p mautrix-signal --run "mautrix-signal -c default.yaml -e"`.

::: {.warning}
Mautrix-Signal allows for some options like `encryption.pickle_key`,
`provisioning.shared_secret`, allow the value `generate` to be set.
Since the configuration file is regenerated on every start of the
service, the generated values would be discarded and might break your
installation. Instead, set those values via
[](#opt-services.mautrix-signal.environmentFile).
:::

## Migrating from an older configuration {#module-services-mautrix-signal-migrate-configuration}

With Mautrix-Signal v0.7.0 the configuration has been rearranged. Mautrix-Signal
performs an automatic configuration migration so your pre-0.7.0 configuration
should just continue to work.

In case you want to update your NixOS configuration, compare the migrated configuration
at `/var/lib/mautrix-signal/config.yaml` with the default configuration
(`nix-shell -p mautrix-signal --run "mautrix-signal -c example.yaml -e"`) and
update your module configuration accordingly.
