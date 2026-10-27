# Draupnir (Matrix Moderation Bot) {#module-services-draupnir}

This chapter will show you how to set up your own, self-hosted
[Draupnir](https://github.com/the-draupnir-project/Draupnir) instance.

As an all-in-one moderation tool, it can protect your server from
malicious invites, spam messages, and whatever else you don't want.
In addition to server-level protection, Draupnir is great for communities
wanting to protect their rooms without having to use their personal
accounts for moderation.

The bot by default includes support for bans, redactions, anti-spam,
server ACLs, room directory changes, room alias transfers, account
deactivation, room shutdown, and more. (This depends on homeserver configuration and implementation.)

See the [README](https://github.com/the-draupnir-project/draupnir#readme)
page and the [Moderator's guide](https://the-draupnir-project.github.io/draupnir-documentation/moderator/setting-up-and-configuring)
for additional instructions on how to setup and use Draupnir.

For [additional settings](#opt-services.draupnir.settings)
see [the default configuration](https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml).

## Draupnir Setup {#module-services-draupnir-setup}

First create a new unencrypted, private room which will be used as the management room for Draupnir.
This is the room in which moderators will interact with Draupnir and where it will log possible errors and debugging information.
You'll need to set this room ID or alias in [services.draupnir.settings.managementRoom](#opt-services.draupnir.settings.managementRoom).

Next, create a new user for Draupnir on your homeserver, if one does not already exist.

The Draupnir Matrix user expects to be free of any rate limiting.
See [Synapse #6286](https://github.com/matrix-org/synapse/issues/6286)
for an example on how to achieve this.

If you want Draupnir to be able to deactivate users, move room aliases, shut down rooms, etc.
you'll need to make the Draupnir user a Matrix server admin.

Now invite the Draupnir user to the management room.
Draupnir will automatically try to join this room on startup.

```nix
{
  services.draupnir = {
    enable = true;

    settings = {
      homeserverUrl = "https://matrix.org";
      managementRoom = "!yyy:example.org";
    };

    secrets = {
      accessToken = "/path/to/secret/containing/access-token";
    };
  };
}
```

### Element Matrix Services (EMS) {#module-services-draupnir-setup-ems}

If you are using a managed ["Element Matrix Services (EMS)"](https://ems.element.io/)
server, you will need to consent to the terms and conditions. Upon startup, an error
log entry with a URL to the consent page will be generated.
