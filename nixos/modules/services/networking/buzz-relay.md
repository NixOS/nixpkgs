# Buzz {#module-services-buzz-relay}

[Buzz](https://github.com/block/buzz) is a workspace for team chat, git
hosting and AI agents, built on Nostr. A community runs on one relay; people
join with the Buzz app (`buzz-desktop`, or the mobile app).

## Basic usage {#module-services-buzz-relay-basic-usage}

```nix
{
  services.buzz-relay = {
    enable = true;
    relayUrl = "wss://buzz.example.com";
    # Your public key, as hex (`nak decode npub1…`).
    settings.RELAY_OWNER_PUBKEY = "<64 hex characters>";
    # BUZZ_RELAY_PRIVATE_KEY and BUZZ_GIT_HOOK_HMAC_SECRET; create the key
    # with `buzz-admin generate-key`.
    environmentFile = "/run/secrets/buzz-relay.env";
    members = {
      "npub1…" = "admin";
    };
  };
}
```

This creates a local PostgreSQL database and a Redis instance. Like upstream's
production setup, the relay is closed: only the owner and members can use it,
and its REST API requires tokens. The relay listens on `127.0.0.1:3000`; put a
reverse proxy with TLS in front of it for `relayUrl`, which also serves media
under `/media`. The relay serves the invite page (`/invite/<code>`) that invite
links open.

The relay also always listens on ports 8080 (health) and 9102 (metrics) on all
interfaces; change them with `BUZZ_HEALTH_PORT` and `BUZZ_METRICS_PORT` in
{option}`services.buzz-relay.settings` if they are taken. Other settings, such
as S3 storage (`BUZZ_S3_ENDPOINT`) or search (`TYPESENSE_URL`), go there too.

Members are added after every start. `buzz-relay-admin` runs the relay's
`buzz-admin` with the relay's user and environment, for example
`buzz-relay-admin list-members` or `buzz-relay-admin remove-member --pubkey …`.

## Pairing the mobile app {#module-services-buzz-relay-pairing}

The mobile app pairs with a desktop through a separate pairing relay, which the
relay advertises to clients:

```nix
{
  services.buzz-relay = {
    pairRelay.enable = true;
    settings.BUZZ_PAIRING_RELAY_URL = "wss://pair.buzz.example.com";
  };
}
```

Route that URL through the reverse proxy to
{option}`services.buzz-relay.pairRelay.port`.

## Moderation dashboard {#module-services-buzz-relay-admin}

Set `BUZZ_ADMIN_HOST` in {option}`services.buzz-relay.settings` to a host
name that reaches the relay, for example `admin.buzz.example.com`. Requests for that host get the
dashboard; admins sign in with their Nostr key.

## Updates {#module-services-buzz-relay-updates}

Update the relay before the apps that use it. New Buzz apps can rely on relay
changes; an older relay may, for example, reject large uploads from them.
NixOS releases therefore receive relay updates as backports.

The relay migrates its database when it starts. After an update that changed
the schema, rolling NixOS back stops the relay: the older version refuses the
newer schema, which keeps the data intact. It runs again after rolling forward,
or after restoring a backup taken before the update. Back up the database
regularly, for example:

```nix
{
  services.postgresqlBackup = {
    enable = true;
    databases = [ "buzz-relay" ];
  };
}
```

To migrate at a time of your choice instead, set `BUZZ_AUTO_MIGRATE` to
`false` in {option}`services.buzz-relay.settings` and run
`buzz-relay-admin migrate` after a backup.
