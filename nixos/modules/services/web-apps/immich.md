# Immich {#module-immich}

*Source:* {file}`modules/services/web-apps/immich.nix`

*Upstream documentation:* <https://immich.app/docs/overview/introduction/>

[Immich](https://immich.app/) is a self-hosted photo and video management solution.

## Configuring

A complete list of options for the Immich module may be found
[here](#opt-services.immich.enable).

### Basic setup

Using the following configuration you can setup a basic installation of Immich:

```nix
{
  services.immich = {
    enable = true;

    # Optionally set a different location for your media files
    mediaLocation = "/my/immich/media";
  };
}
```

This will configure Immich and its components as well as Postgres and Redis databases and users for Immich.
