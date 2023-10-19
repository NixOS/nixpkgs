# Mjolnir (Matrix Moderation Tool) {#module-services-mjolnir}

This chapter will show you how to set up your own, self-hosted
[Mjolnir](https://github.com/matrix-org/mjolnir) instance.

As an all-in-one moderation tool, it can protect your server from
malicious invites, spam messages, and whatever else you don't want.
In addition to server-level protection, Mjolnir is great for communities
wanting to protect their rooms without having to use their personal
accounts for moderation.

The bot by default includes support for bans, redactions, anti-spam,
server ACLs, room directory changes, room alias transfers, account
deactivation, room shutdown, and more.

See the [README](https://github.com/matrix-org/mjolnir#readme)
page and the [Moderator's guide](https://github.com/matrix-org/mjolnir/blob/main/docs/moderators.md)
for additional instructions on how to setup and use Mjolnir.

For [additional settings](#opt-services.mjolnir.settings)
see [the default configuration](https://github.com/matrix-org/mjolnir/blob/main/config/default.yaml).

## Mjolnir Setup {#module-services-mjolnir-setup}

First create a new Room which will be used as a management room for Mjolnir. In
this room, Mjolnir will log possible errors and debugging information. You'll
need to set this Room-ID in [services.mjolnir.managementRoom](#opt-services.mjolnir.managementRoom).

Next, create a new user for Mjolnir on your homeserver, if not present already.

The Mjolnir Matrix user expects to be free of any rate limiting.
See [Synapse #6286](https://github.com/matrix-org/synapse/issues/6286)
for an example on how to achieve this.

If you want Mjolnir to be able to deactivate users, move room aliases, shutdown rooms, etc.
you'll need to make the Mjolnir user a Matrix server admin.

Now invite the Mjolnir user to the management room.

It is recommended to use [Pantalaimon](https://github.com/matrix-org/pantalaimon),
so your management room can be encrypted. This also applies if you are looking to moderate an encrypted room.

To enable the Pantalaimon E2E Proxy for mjolnir, enable
[services.mjolnir.pantalaimon](#opt-services.mjolnir.pantalaimon.enable). This will
autoconfigure a new Pantalaimon instance, which will connect to the homeserver
set in [services.mjolnir.homeserverUrl](#opt-services.mjolnir.homeserverUrl) and Mjolnir itself
will be configured to connect to the new Pantalaimon instance.

```
{
  services.mjolnir = {
    enable = true;
    homeserverUrl = "https://matrix.domain.tld";
    pantalaimon = {
       enable = true;
       username = "mjolnir";
       passwordFile = "/run/secrets/mjolnir-password";
    };
    protectedRooms = [
      "https://matrix.to/#/!xxx:domain.tld"
    ];
    managementRoom = "!yyy:domain.tld";
  };
}
```

### Element Matrix Services (EMS) {#module-services-mjolnir-setup-ems}

If you are using a managed ["Element Matrix Services (EMS)"](https://ems.element.io/)
server, you will need to consent to the terms and conditions. Upon startup, an error
log entry with a URL to the consent page will be generated.

## Synapse Antispam Module {#module-services-mjolnir-matrix-synapse-antispam}

A Synapse module is also available to apply the same rulesets the bot
uses across an entire homeserver.

To use the Antispam Module, add `matrix-synapse-plugins.matrix-synapse-mjolnir-antispam`
to the Synapse plugin list and enable the `mjolnir.Module` module.

```
{
  services.matrix-synapse = {
    plugins = with pkgs; [
      matrix-synapse-plugins.matrix-synapse-mjolnir-antispam
    ];
    extraConfig = ''
      modules:
        - module: mjolnir.Module
          config:
            # Prevent servers/users in the ban lists from inviting users on this
            # server to rooms. Default true.
            block_invites: true
            # Flag messages sent by servers/users in the ban lists as spam. Currently
            # this means that spammy messages will appear as empty to users. Default
            # false.
            block_messages: false
            # Remove users from the user directory search by filtering matrix IDs and
            # display names by the entries in the user ban list. Default false.
            block_usernames: false
            # The room IDs of the ban lists to honour. Unlike other parts of Mjolnir,
            # this list cannot be room aliases or permalinks. This server is expected
            # to already be joined to the room - Mjolnir will not automatically join
            # these rooms.
            ban_lists:
              - "!roomid:example.org"
    '';
  };
}
```
