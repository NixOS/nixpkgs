# wanderer {#module-services-wanderer}

[wanderer](https://wanderer.to) is a self-hosted trail database for storing and managing GPS tracks.
It consists of a PocketBase backend (`wanderer.service`), a web frontend (`wanderer-web.service`) and a [meilisearch](https://www.meilisearch.com) instance.
By default, the module sets up meilisearch through {option}`services.meilisearch`.

## Basic usage {#module-services-wanderer-basic-usage}

Run wanderer with a local meilisearch instance:

```nix
{
  services.meilisearch.masterKeyFile = "/run/secrets/meilisearch-master-key";

  services.wanderer = {
    enable = true;
    settings.ORIGIN = "https://wanderer.example.com";
    secrets = {
      POCKETBASE_ENCRYPTION_KEY = "/run/secrets/wanderer-encryption-key";
      POCKETBASE_PROXY_SECRET = "/run/secrets/wanderer-proxy-secret";
    };
  };
}
```

Set {option}`services.wanderer.settings.ORIGIN` to exactly the address users enter into their browser.
Otherwise, wanderer shows a warning about mismatched hosts on every page.

Expose the frontend through NGINX:

```nix
{ config, ... }:
{
  services.nginx = {
    enable = true;
    virtualHosts."wanderer.example.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.wanderer.port}";
        proxyWebsockets = true;
      };
    };
  };
}
```

Users only need to reach the frontend.
The backend listens on `127.0.0.1` by default.

## Creating the first superuser {#module-services-wanderer-superuser}

A PocketBase superuser is required to manage the instance via the admin interface.
Until such a superuser exists, the backend prints a setup link on every start.
The link is valid for 30 minutes.

1. Forward the backend port to your machine:

   ```shell
   ssh -L 8090:127.0.0.1:8090 <YOUR-HOST>
   ```

2. Find the setup link in the backend log:

   ```shell
   journalctl -u wanderer.service | grep pbinstall
   ```

3. Open the link in your browser and create the superuser.

If the link has expired, restart `wanderer.service` to get a new one.

## Secrets {#module-services-wanderer-secrets}

Set each attribute of {option}`services.wanderer.secrets` to a file.
The backend reads the content of each file into the environment variable of the same name.
wanderer requires the following secrets:

- {env}`MEILI_MASTER_KEY`: defaults to {option}`services.meilisearch.masterKeyFile` if the local meilisearch instance is enabled.
- {env}`POCKETBASE_ENCRYPTION_KEY`: exactly 32 characters, for example generated with `openssl rand -hex 16`.
- {env}`POCKETBASE_PROXY_SECRET`: for example generated with `openssl rand -hex 32`. The frontend receives this secret as well.

Add further secrets, such as {env}`POCKETBASE_SMTP_PASSWORD`, the same way.

## Plugins {#module-services-wanderer-plugins}

Install plugins to integrate third-party services:

```nix
{ pkgs, ... }:
{
  services.wanderer.plugins = with pkgs.wanderer.plugins; [
    komoot
    strava
  ];
}
```

Users configure installed plugins in the plugin settings of the web interface.

## Using an external meilisearch instance {#module-services-wanderer-external-meilisearch}

Use an existing meilisearch instance instead of a local one:

```nix
{
  services.wanderer = {
    meilisearch.enable = false;
    settings.MEILI_URL = "https://meilisearch.example.com";
    secrets.MEILI_MASTER_KEY = "/run/secrets/meilisearch-master-key";
  };
}
```
