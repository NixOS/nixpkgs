# Mautrix-Whatsapp {#module-services-mautrix-whatsapp}

[Mautrix-Whatsapp](https://github.com/mautrix/whatsapp) is a Matrix-Whatsapp puppeting bridge.

## Configuration {#module-services-mautrix-whatsapp-configuration}

1. Set [](#opt-services.mautrix-whatsapp.enable) to `true`. The service will use
   SQLite by default.
2. To create your configuration check the default configuration for
   [](#opt-services.mautrix-whatsapp.settings). To obtain the complete default
   configuration, run
   `nix-shell -p mautrix-whatsapp --run "mautrix-whatsapp -c default.yaml -e"`.

::: {.warning}
Mautrix-Whatsapp allows for some options like `encryption.pickle_key`,
`provisioning.shared_secret`, to allow the value `generate` to be set.
Since the configuration file is regenerated on every start of the
service, the generated values would be discarded and might break your
installation. Instead, set those values via
[](#opt-services.mautrix-whatsapp.environmentFile).
:::

## Migrating from an older configuration {#module-services-mautrix-whatsapp-migrate-configuration}

With Mautrix-Whatsapp v0.11.0 the configuration has been rearranged. Mautrix-Whatsapp
performs an automatic configuration migration so your pre-0.7.0 configuration
should just continue to work.

In case you want to update your NixOS configuration, compare the migrated configuration
at `/var/lib/mautrix-whatsapp/config.yaml` with the default configuration
(`nix-shell -p mautrix-whatsapp --run "mautrix-whatsapp -c example.yaml -e"`) and
update your module configuration accordingly.
