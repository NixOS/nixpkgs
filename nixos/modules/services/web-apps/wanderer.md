# Wanderer {#module-services-wanderer}

[Wanderer](https://github.com/open-wanderer/wanderer) is an open-source, self-hosted web application for tracking, organizing, and visualizing outdoor trails and GPS tracks. It uses PocketBase as its backend database and optionally integrates with Meilisearch for fast search functionality.

## Configuration {#module-services-wanderer-basic-usage}

To enable Wanderer with default settings and a local Meilisearch instance, add the following to your configuration:

```nix
{ config, pkgs, ... }: {
  services.wanderer = {
    enable = true;
    port = 8080;
    origin = "https://wanderer.example.com";
    dataDir = "/var/lib/wanderer";
    environmentFile = "/run/secrets/wanderer.env";

    pocketbase = {
      port = 8081;
      publicUrl = "http://wanderer-db.example.com";
    };

    meilisearch = {
      enable = true;
      port = 7700;
      masterKeyFile = "/run/secrets/meili_master_key";
    };
  };
}
```

This starts the PocketBase backend service (`wanderer-db.service`) on port 8081 and the Node.js frontend (`wanderer.service`) on port 8080.
Wanderer requires the environment variables `MEILI_MASTER_KEY` and `POCKETBASE_ENCRYPTION_KEY` to securely access its search engine and encrypt database contents.

## Managing Secrets with sops-nix {#module-services-wanderer-sops}

When using sops-nix, construct a combined environment template for {option}`services.wanderer.environmentFile`:

```nix
{ config, pkgs, ... }: {
  sops.secrets = {
    "meili_master_key" = { mode = "0444"; };
    "wanderer_pb_encryption_key" = { mode = "0444"; };
  };

  sops.templates."wanderer.env" = {
    owner = "wanderer";
    group = "wanderer";
    content = ''
      MEILI_MASTER_KEY=${config.sops.placeholder."meili_master_key"}
      POCKETBASE_ENCRYPTION_KEY=${config.sops.placeholder."wanderer_pb_encryption_key"}
    '';
  };

  services.wanderer = {
    enable = true;
    environmentFile = config.sops.templates."wanderer.env".path;

    meilisearch = {
      enable = true;
      masterKeyFile = config.sops.secrets."meili_master_key".path;
    };

    # Rest of config
  };
}
```

## Using an External Meilisearch Instance {#module-services-wanderer-external-meiliserach}

If you already have a shared Meilisearch instance running, set {option}`services.wanderer.meilisearch.enable` to false and point to your endpoint using {option}`services.wanderer.meilisearch.url`:

```nix
{ config, pkgs, ... }:
{
  services.wanderer = {
    meilisearch = {
      enable = false;
      url = "http://127.0.0.1:7700";
    };

    # Rest of config
  };
}
```

## Reverse Proxy Configuration {#module-services-wanderer-reverse-proxy-configuration}
Wanderer requires two public-facing endpoints:
the web engine ({option}`services.wanderer.port`) and the PocketBase backend ({option}`services.wanderer.pocketbase.port`).

The following example configures NGINX for both endpoints:

```nix
{ config, pkgs, ... }: {
  services.wanderer = {
    enable = true;
    port = 8003;
    origin = "https://wanderer.example.com";

    pocketbase = {
      port = 8004;
      publicUrl = "https://wanderer-db.example.com";
    };

    # Rest of config
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "wanderer.example.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8003";
          proxyWebsockets = true;
        };
      };
      "wanderer-db.example.com" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8004";
          proxyWebsockets = true;
        };
      };
    };
  };
}
```

