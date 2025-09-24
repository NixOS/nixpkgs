# Anubis {#module-services-anubis}

[Anubis](https://anubis.techaro.lol) is a scraper defense software that blocks AI scrapers. It is designed to sit
between a reverse proxy and the service to be protected.

## Quickstart {#module-services-anubis-quickstart}

This module is designed to use Unix domain sockets as the socket paths can be automatically configured for multiple
instances, but TCP sockets are also supported.

A minimal configuration with [nginx](#opt-services.nginx.enable) may look like the following:

```nix
{ config, ... }:
{
  services.anubis.instances.default.settings.TARGET = "http://localhost:8000";

  # required due to unix socket permissions
  users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];
  services.nginx.virtualHosts."example.com" = {
    locations = {
      "/".proxyPass = "http://unix:${config.services.anubis.instances.default.settings.BIND}";
    };
  };
}
```

If Unix domain sockets are not needed or desired, this module supports operating with only TCP sockets.

```nix
{
  services.anubis = {
    instances.default = {
      settings = {
        TARGET = "http://localhost:8080";
        BIND = ":9000";
        BIND_NETWORK = "tcp";
        METRICS_BIND = "127.0.0.1:9001";
        METRICS_BIND_NETWORK = "tcp";
      };
    };
  };
}
```

## Configuration {#module-services-anubis-configuration}

It is possible to configure default settings for all instances of Anubis, via {option}`services.anubis.defaultOptions`.

```nix
{
  services.anubis.defaultOptions = {
    botPolicy = {
      dnsbl = false;
    };
    settings.DIFFICULTY = 3;
  };
}
```

Note that at the moment, a custom bot policy is not merged with the baked-in one. That means to only override a setting
like `dnsbl`, copying the entire bot policy is required. Check
[the upstream repository](https://github.com/TecharoHQ/anubis/blob/1509b06cb921aff842e71fbb6636646be6ed5b46/cmd/anubis/botPolicies.json)
for the policy.
