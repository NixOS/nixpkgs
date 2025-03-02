# Sharkey {#module-services-sharkey}

[Sharkey](https://joinsharkey.org) is a feature-rich ActivityPub microblogging server forked from Misskey.

## Service configuration {#modules-services-sharkey-service-configuration}

The YAML configuration file required by Sharkey is generated automatically from
[{option}`services.sharkey.settings`](options.html#opt-services.akkoma.settings).

Here is how such a config can look:

```nix
{ config, ... }:

{
  services.misskey = {
    enable = true;
    settings = {
      url = "https://fediverse.example.com/";
      port = 11231;
      id = "aid";
      db = {
        host = "/run/postgresql";
        port = config.services.postgresql.port;
        user = "sharkey";
        db = "sharkey";
      };
      redis = {
        host = "localhost";
        port = config.services.redis.servers.sharkey.port;
      };
    };
  };
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "sharkey" ];
    ensureUsers = [
      {
        name = "sharkey;
        ensurePermissions."DATABASE sharkey" = "ALL PRIVILEGES";
      }
    ];
  };
  services.redis.servers.sharkey = {
    enable = true;
    bind = "127.0.0.1";
    port = 16434;
  };
  services.nginx.virtualHosts."fediverse.example.com" = {
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.sharkey.settings.port}/";
        proxyWebsockets = true;
      };
    };
  };
}
```

Please refer to the [official docs](https://docs.joinsharkey.org/docs/)
for additional configuration options.

