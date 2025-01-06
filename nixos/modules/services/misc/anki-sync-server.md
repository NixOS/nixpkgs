# Anki Sync Server {#module-services-anki-sync-server}

[Anki Sync Server](https://docs.ankiweb.net/sync-server.html) is the built-in
sync server, present in recent versions of Anki. Advanced users who cannot or
do not wish to use AnkiWeb can use this sync server instead of AnkiWeb.

This module is compatible only with Anki versions >=2.1.66, due to [recent
enhancements to the Nix anki
package](https://github.com/NixOS/nixpkgs/commit/05727304f8815825565c944d012f20a9a096838a).

## Basic Usage {#module-services-anki-sync-server-basic-usage}

By default, the module creates a
[`systemd`](https://www.freedesktop.org/wiki/Software/systemd/)
unit which runs the sync server with an isolated user using the systemd
`DynamicUser` option.

This can be done by enabling the `anki-sync-server` service:
```nix
{ ... }:

{
  services.anki-sync-server.enable = true;
}
```

It is necessary to set at least one username-password pair under
{option}`services.anki-sync-server.users`. For example

```nix
{
  services.anki-sync-server.users = [
    {
      username = "user";
      passwordFile = /etc/anki-sync-server/user;
    }
  ];
}
```

Here, `passwordFile` is the path to a file containing just the password in
plaintext. Make sure to set permissions to make this file unreadable to any
user besides root.

By default, the server listen address {option}`services.anki-sync-server.host`
is set to localhost, listening on port
{option}`services.anki-sync-server.port`, and does not open the firewall. This
is suitable for purely local testing, or to be used behind a reverse proxy. If
you want to expose the sync server directly to other computers (not recommended
in most circumstances, because the sync server doesn't use HTTPS), then set the
following options:

```nix
{
  services.anki-sync-server.address = "0.0.0.0";
  services.anki-sync-server.openFirewall = true;
}
```
