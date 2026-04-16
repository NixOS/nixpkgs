# Mautrix-Telegram {#module-services-mautrix-telegram}

[Mautrix-Telegram](https://github.com/mautrix/telegram) is a Matrix-Telegram puppeting bridge.

## Configuration {#module-services-mautrix-telegram-configuration}

1. Set [](#opt-services.mautrix-telegram.enable) to `true`. The service will use
   SQLite by default.
2. To create your configuration check the default configuration for
   [](#opt-services.mautrix-telegram.settings). To obtain the complete default
   configuration, run `nix-shell -p mautrix-telegram --run "mautrix-telegram -e"`.

::: {.warning}
Mautrix-Telegram allows for some options like `network.api_hash`,
`appservice.as_token`, and `appservice.hs_token`. Since these values should
not be world-readable, set them using [](#opt-services.mautrix-telegram.environmentFile).
:::

## Migrating from the Python version {#module-services-mautrix-telegram-migrate}

Migrating from a pre-bridgev2 setup is not possible. See also:
[the official release announcement](https://mau.fi/blog/2026-04-mautrix-release/).
