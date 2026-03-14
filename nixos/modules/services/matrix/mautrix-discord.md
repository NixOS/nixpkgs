# Mautrix-Discord {#module-services-mautrix-discord}

[Mautrix-Discord](https://github.com/mautrix/discord) is a Matrix-Discord puppeting/relay-bot bridge.

## Configuration {#module-services-mautrix-discord-configuration}

1. Set [](#opt-services.mautrix-discord.enable) to `true`. The service will use
   SQLite by default.
2. Configure the required settings for your homeserver and appservice:
   - [](#opt-services.mautrix-discord.settings.homeserver.address) - Your Matrix homeserver URL
   - [](#opt-services.mautrix-discord.settings.homeserver.domain) - Your Matrix homeserver domain
   - [](#opt-services.mautrix-discord.settings.appservice.address) - The address where the bridge will listen
   - [](#opt-services.mautrix-discord.settings.appservice.port) - The port where the bridge will listen
   - [](#opt-services.mautrix-discord.settings.bridge.permissions) - Who can use the bridge

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
      appservice = {
        address = "http://localhost:29334";
        port = 29334;
      };
      bridge = {
        permissions = {
          "example.com" = "user";
          "@admin:example.com" = "admin";
        };
      };
    };
  };
}
```

### Using PostgreSQL {#module-services-mautrix-discord-postgresql}

To use PostgreSQL instead of SQLite:

```nix
{
  services.mautrix-discord.settings.appservice.database = {
    type = "postgres";
    uri = "postgresql:///mautrix-discord?host=/run/postgresql";
  };
}
```

If your PostgreSQL connection requires a password, use the [](#opt-services.mautrix-discord.environmentFile)
option to avoid storing secrets in the Nix store:

```nix
{
  services.mautrix-discord = {
    settings.appservice.database.uri = "postgresql://mautrix:$DB_PASSWORD@localhost/mautrix-discord";
    environmentFile = "/run/secrets/mautrix-discord-env";
  };
}
```

Where `/run/secrets/mautrix-discord-env` contains:
```
DB_PASSWORD=your-secure-password
```

### Direct Media {#module-services-mautrix-discord-direct-media}

To enable direct media for more efficient media handling:

```nix
{
  services.mautrix-discord.settings.bridge.direct_media = {
    enabled = true;
    server_name = "discord-media.example.com";
  };
}
```

::: {.note}
You'll need to configure your reverse proxy to route `discord-media.example.com`
to the bridge's media endpoint. See the
[direct media documentation](https://docs.mau.fi/bridges/go/discord/direct-media.html)
for details.
:::

## Managing Secrets {#module-services-mautrix-discord-secrets}

::: {.warning}
Mautrix-Discord allows for some options like `bridge.provisioning.shared_secret`
and `bridge.direct_media.server_key` to have the value `generate`. The service
will automatically generate these secrets on first start and persist them.

However, for the appservice tokens (`as_token` and `hs_token`), these are
automatically managed by the service. You generally don't need to set these
manually unless migrating from another installation.
:::

For other secrets (like database passwords, Discord bot tokens, etc.), use
[](#opt-services.mautrix-discord.environmentFile):

```nix
{
  services.mautrix-discord = {
    environmentFile = "/run/secrets/mautrix-discord-env";
    settings = {
      appservice.database.uri = "postgresql://mautrix:$DB_PASSWORD@localhost/mautrix-discord";
      # Other settings with $VARIABLES
    };
  };
}
```

## Bridge Setup {#module-services-mautrix-discord-setup}

After starting the service for the first time:

1. Start a chat with `@discordbot:example.com` (or whatever username you configured)
2. Send `login` to begin the Discord login process
3. Follow the instructions to link your Discord account
4. Once logged in, your Discord chats will begin appearing in Matrix

For detailed usage instructions, see the
[Mautrix-Discord documentation](https://docs.mau.fi/bridges/go/discord/index.html).

## Advanced Configuration {#module-services-mautrix-discord-advanced}

For all available configuration options, check the default configuration at
[example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml).

To view the complete default configuration with all available options, run:
```bash
nix-shell -p mautrix-discord --run "mautrix-discord -e"
```

Common advanced settings:

### Encryption {#module-services-mautrix-discord-encryption}

To enable end-to-end encryption support:

```nix
{
  services.mautrix-discord.settings.bridge.encryption = {
    allow = true;
    default = true;
    require = false;
  };
}
```

::: {.note}
Encryption requires additional setup. See the
[bridge encryption documentation](https://docs.mau.fi/bridges/general/end-to-bridge-encryption.html)
for details.
:::

### Backfill {#module-services-mautrix-discord-backfill}

To enable message history backfill when creating new portals:

```nix
{
  services.mautrix-discord.settings.bridge.backfill.forward_limits = {
    initial = {
      dm = 50;
      channel = 50;
      thread = 50;
    };
  };
}
```

### Double Puppeting {#module-services-mautrix-discord-double-puppet}

Double puppeting allows the bridge to send messages as your real Matrix account
instead of ghost users. To enable it with Synapse's shared secret:

```nix
{
  services.mautrix-discord = {
    environmentFile = "/run/secrets/mautrix-discord-env";
    settings.bridge.login_shared_secret_map = {
      "example.com" = "$SHARED_SECRET";
    };
  };
}
```

Where the environment file contains your Synapse registration shared secret:
```
SHARED_SECRET=your-synapse-registration-shared-secret
```

## Synapse Integration {#module-services-mautrix-discord-synapse}

When [](#opt-services.mautrix-discord.registerToSynapse) is `true` (the default
when Synapse is enabled), the bridge will automatically register itself with
Synapse. The registration file is managed automatically and no manual
intervention is required.

::: {.note}
The Mautrix-Discord user should be free of rate limiting. For Synapse, you can
configure this by setting the bridge bot user in
`services.matrix-synapse.settings.rc_message.per_second` exemptions or by
making it an admin user.
:::

## Troubleshooting {#module-services-mautrix-discord-troubleshooting}

### Viewing Logs

To view the bridge logs:
```bash
journalctl -u mautrix-discord.service -f
```

### Configuration Issues

The service will validate your configuration on startup. Common issues:
- Missing required settings (homeserver address/domain, appservice address/port, permissions)
- Incorrect database connection strings
- Permission issues with the data directory

### Bridge Not Responding

1. Check that the bridge is running: `systemctl status mautrix-discord`
2. Verify the homeserver can reach the bridge at the configured address
3. Check that the registration file exists and is readable by Synapse
4. Ensure the bridge bot user is invited to any management rooms

For more help, see the [Mautrix-Discord documentation](https://docs.mau.fi/bridges/go/discord/index.html)
or join the support room at [#discord:maunium.net](https://matrix.to/#/#discord:maunium.net).
