# Mautrix-Discord {#module-services-mautrix-discord}

*Source:* {file}`modules/services/matrix/mautrix/discord.nix`

*Upstream documentation:* <https://docs.mau.fi/bridges/go/discord/index.html>

[Mautrix-Discord](https://github.com/mautrix/discord) is a Matrix-Discord bridge.

## Basic Usage {#module-services-mautrix-discord-basic-usage}

The common setup is to enable the bridge, point it at your homeserver, and set the permissions you want to allow:

1. Set `services.mautrix-discord.enable` to `true`.
2. Set `services.mautrix-discord.settings.homeserver.address` and `services.mautrix-discord.settings.homeserver.domain` (auto-detected when a local Synapse or Conduit is enabled).
3. Override `services.mautrix-discord.settings.bridge.permissions` if the default relay permissions do not fit your deployment.

The module provides sensible defaults for the appservice listener, registration tokens, and relay permissions.

### Basic Example {#module-services-mautrix-discord-basic-example}

```nix
{
  services.mautrix-discord = {
    enable = true;
    registerToSynapse = true;
    settings = {
      homeserver = {
        address = "http://localhost:8008";
        domain = "example.com";
      };
      bridge.permissions = {
        "example.com" = "user";
        "@admin:example.com" = "admin";
      };
    };
  };
}
```

### Server Defaults {#module-services-mautrix-discord-server-defaults}

By default, the bridge listens on `0.0.0.0:29334` (advertised as `http://127.0.0.1:29334`) and generates its appservice tokens automatically.

## Authentication {#module-services-mautrix-discord-authentication}

If you want to store the bridge database outside the default SQLite file, set `settings.appservice.database` to use PostgreSQL instead of SQLite:

```nix
{
  services.mautrix-discord.settings.appservice.database = {
    type = "postgres";
    uri = "postgresql:///mautrix-discord?host=/run/postgresql";
  };
}
```

If the connection needs a password, combine it with `services.mautrix-discord.environmentFiles`:

```nix
{
  services.mautrix-discord = {
    environmentFiles = [ "/run/secrets/mautrix-discord-env" ];
    settings.appservice.database.uri = "postgresql://mautrix:$DB_PASSWORD@localhost/mautrix-discord";
  };
}
```

Use `services.mautrix-discord.environmentFiles` for any secret you do not want in the Nix store.
This includes database passwords, shared secrets, and similar values.
String values referencing `$VARIABLE` or `${VARIABLE}` are substituted from the loaded environment files (`$$` produces a literal `$`, and a `json::` prefix parses the substituted value as JSON).

Example:

```nix
{
  services.mautrix-discord = {
    environmentFiles = [ "/run/secrets/mautrix-discord-env" ];
    settings.bridge.login_shared_secret_map = {
      "example.com" = "$SHARED_SECRET";
    };
  };
}
```

## Bridge Setup {#module-services-mautrix-discord-setup}

After the service starts, open a chat with `@discordbot:example.com`, send `login`, and follow the instructions to link your Discord account.

For more detail, see the [Mautrix-Discord documentation](https://docs.mau.fi/bridges/go/discord/index.html).

## Advanced Configuration {#module-services-mautrix-discord-advanced}

The upstream default configuration is available at [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml).

### Encryption {#module-services-mautrix-discord-encryption}

```nix
{
  services.mautrix-discord.settings.bridge.encryption = {
    allow = true;
    default = true;
    require = false;
  };
}
```

Encryption needs additional bridge-side setup. See the [bridge encryption documentation](https://docs.mau.fi/bridges/general/end-to-bridge-encryption.html) for details.

### Backfill {#module-services-mautrix-discord-backfill}

```nix
{
  services.mautrix-discord.settings.bridge.backfill.forward_limits.initial = {
    dm = 50;
    channel = 50;
    thread = 50;
  };
}
```

### Double Puppeting {#module-services-mautrix-discord-double-puppet}

```nix
{
  services.mautrix-discord = {
    environmentFiles = [ "/run/secrets/mautrix-discord-env" ];
    settings.bridge.login_shared_secret_map = {
      "example.com" = "$SHARED_SECRET";
    };
  };
}
```
where `/run/secrets/mautrix-discord-env` contains
```
SHARED_SECRET=aProtectedSecret
```
Alternatively, setting `MAUTRIX_BRIDGE_LOGIN_SHARED_SECRET` (or `MAUTRIX_DISCORD_BRIDGE_LOGIN_SHARED_SECRET`) in an environment file populates `bridge.login_shared_secret_map` for `settings.homeserver.domain` automatically.

## Synapse Integration {#module-services-mautrix-discord-synapse}

When `services.mautrix-discord.registerToSynapse` is `true`, a dedicated `mautrix-discord-registration.service` writes the registration file before Synapse starts and Synapse picks it up automatically. Registrations disable rate limiting by default (`rateLimited = false`).

If Synapse is enabled, this option defaults to `true`.

## Troubleshooting {#module-services-mautrix-discord-troubleshooting}

- View logs with `journalctl -u mautrix-discord.service -f`.
- Check `systemctl status mautrix-discord` if the bridge does not start.
- Verify the homeserver can reach the configured appservice address.
- Ensure the registration file exists and Synapse can read it.

For more help, see the
[Mautrix-Discord documentation](https://docs.mau.fi/bridges/go/discord/index.html)
or the support room at [#discord:maunium.net](https://matrix.to/#/#discord:maunium.net).
