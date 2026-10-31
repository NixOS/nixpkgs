# Spreed standalone signaling server {#module-services-nextcloud-spreed-signaling}

`pkgs.nextcloud-spreed-signaling` is a standalone signaling server for use with [Nextcloud Talk](https://apps.nextcloud.com/apps/spreed), as a "High Performance Backend".
The project is situated at <https://github.com/strukturag/nextcloud-spreed-signaling>.

Upstream's documentation for setting up a signaling server can be found at <https://github.com/strukturag/nextcloud-spreed-signaling#setup-of-nextcloud-talk>.

The method of choice for running the signaling server is [`services.nextcloud-spreed-signaling`](#opt-services.nextcloud-spreed-signaling.enable).

To set up `nextcloud-spreed-signaling` as a high performance backend, the following minimal configuration can provide a good starting point:

```nix
{
  services.nextcloud-spreed-signaling = {
    enable = true;

    # optional, recommended by upstream instead of connecting to the signaling server directly
    # see https://github.com/strukturag/nextcloud-spreed-signaling?tab=readme-ov-file#setup-of-frontend-webserver
    configureNginx = true;
    hostName = "talk.mydomain.org";

    backends.nextcloud = {
      urls = [ "https://cloud.example.com" ];
      secretFile = "/run/secrets/nextcloud";
    };
    settings = {
      clients = {
        internalsecretFile = "/run/secrets/internalsecret";
      };
      sessions = {
        hashkeyFile = "/run/secrets/hashkey";
        blockkeyFile = "/run/secrets/blockkey";
      };
      http = {
        listen = "127.0.0.1:8080";
      };
    };
  };

  # optional, for SSL support
  services.nginx.virtualHosts."${config.services.nextcloud-spreed-signaling.hostName}" = {
    enableACME = true;
    forceSSL = true;
  };
}
```

## NATS {#module-services-nextcloud-spreed-signaling-nats}

By default, `services.nextcloud-spreed-signaling` uses an internal / loopback NATS implementation.
To connect to an actual NATS backend (e.g. one enabled via `services.nats`), set [`services.nextcloud-spreed-signaling.settings.nats.url`](#opt-services.nextcloud-spreed-signaling.settings.nats.url) to the URL of your NATS backend.

## Configuration & Secrets Management {#module-services-nextcloud-spreed-signaling-config}

Configuration is done declaratively via [`services.nextcloud-spreed-signaling.settings`](#opt-services.nextcloud-spreed-signaling.settings).
Secrets that are normally embedded into the server config file (e.g. `clients.internalsecret`) can be declared using auxiliary options that take in a file path instead, e.g. [`services.nextcloud-spreed-signaling.settings.clients.internalsecretFile`](#opt-services.nextcloud-spreed-signaling.settings.clients.internalsecretFile).
On startup, the secrets contained within the files will be substituted in the server's config file.

Backends (Nextcloud installations to be given access permissions) are configured via [`services.nextcloud-spreed-signaling.backends`](#opt-services.nextcloud-spreed-signaling.backends) and will automatically populate the `backend.backends` config entry with the correct values.

Many config options have been adapted to better suit Nix' declarative style, e.g. "comma-separated lists" can be declared using proper Nix lists instead.

Any other attributes that are not explicitly listed as Nix options will be copied into the config verbatim.
See <https://github.com/strukturag/nextcloud-spreed-signaling/blob/master/server.conf.in> for a comprehensive overview of possible configuration options.
