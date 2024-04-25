# Draupnir (Matrix Moderation Tool) {#module-services-draupnir}

This chapter will show you how to set up your own, self-hosted
[Draupnir](https://github.com/the-draupnir-project/Draupnir) instance.

As an all-in-one moderation tool, it can protect your server from
malicious invites, spam messages, and whatever else you don't want.
In addition to server-level protection, Draupnir is great for communities
wanting to protect their rooms without having to use their personal
accounts for moderation.

The bot by default includes support for bans, redactions, anti-spam,
server ACLs, room directory changes, room alias transfers, account
deactivation, room shutdown, and more.

See the [README](https://github.com/the-draupnir-project/draupnir#readme)
page and the [Moderator's guide](https://github.com/the-draupnir-project/Draupnir/blob/main/docs/moderators.md)
for additional instructions on how to setup and use Draupnir.

For [additional settings](#opt-services.draupnir.settings)
see [the default configuration](https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml).

## Draupnir Setup {#module-services-draupnir-setup}

First create a new Room which will be used as a management room for Draupnir. In
this room, Draupnir will log possible errors and debugging information. You'll
need to set this Room-ID in [services.draupnir.settings.managementRoom](#opt-services.draupnir.settings.managementRoom).

Next, create a new user for Draupnir on your homeserver, if not present already.

The Draupnir Matrix user expects to be free of any rate limiting.
See [Synapse #6286](https://github.com/matrix-org/synapse/issues/6286)
for an example on how to achieve this.

If you want Draupnir to be able to deactivate users, move room aliases, shut down rooms, etc.
you'll need to make the Draupnir user a Matrix server admin.

Now invite the Draupnir user to the management room.

It is recommended to use [Pantalaimon](https://github.com/matrix-org/pantalaimon),
so your management room can be encrypted. This also applies if you are looking to moderate an encrypted room.

To enable the Pantalaimon E2E Proxy for draupnir, enable
[services.draupnir.pantalaimon](#opt-services.draupnir.pantalaimon.enable). This will
autoconfigure a new Pantalaimon instance, which will connect to the homeserver
set in [services.draupnir.settings.homeserverUrl](#opt-services.draupnir.settings.homeserverUrl) and Draupnir itself
will be configured to connect to the new Pantalaimon instance.

```
{
  services.draupnir = {
    enable = true;
    pantalaimon = {
       enable = true;
       username = "draupnir";
       passwordFile = "/run/secrets/draupnir-password";
       options = {
        homeserver = "http://localhost:8008";
        ssl = false;
       };
    };
    settings = {
      managementRoom = "!yyy:domain.tld";
      protectedRooms = [
        "https://matrix.to/#/!xxx:domain.tld"
      ];
    };
  };
}
```

### Element Matrix Services (EMS) {#module-services-draupnir-setup-ems}

If you are using a managed ["Element Matrix Services (EMS)"](https://ems.element.io/)
server, you will need to consent to the terms and conditions. Upon startup, an error
log entry with a URL to the consent page will be generated.

## Synapse Antispam Module {#module-services-draupnir-matrix-synapse-antispam}

Use the Mjolnir Antispam module, Draupnir made no changes here and as such was not packaged.
