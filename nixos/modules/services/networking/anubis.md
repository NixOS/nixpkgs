# Anubis {#module-services-anubis}

[Anubis](https://anubis.techaro.lol) is a scraper defense software that blocks AI scrapers. It is designed to sit
between a reverse proxy and the service to be protected.

## Quickstart {#module-services-anubis-quickstart}

This module is designed to use Unix domain sockets as the socket paths can be automatically configured for multiple
instances, but TCP sockets are also supported.

Configuring multiple instances may look like the following.

Notes:

- Each instance as its runtime directory set to `anubis/anubis-<instance name>`.
- When a single instance is declared with unix sockets, the runtime directory `anubis` is allowed for backward
  compatibility.

```nix
{
  services.anubis.instances."instance-1" = {
    # Runtime directory: "anubis/anubis-instance-1".
    settings = {
      BIND = "/run/anubis/anubis-instance-1/anubis.sock";
      TARGET = "http://localhost:8001";
    };
  };

  services.anubis.instances."instance-2" = {
    # Runtime directory: "anubis/anubis-instance-2".
    settings = {
      BIND = "/run/anubis/anubis-instance-2/anubis.sock";
      TARGET = "http://localhost:8002";
    };
  };
}
```

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
    settings.DIFFICULTY = 3;
  };
}
```

By default, this module uses Anubis's built-in policy (`botPolicies.yaml`), which includes sensible defaults for bot
rules, thresholds, status codes, and storage backend. A custom policy file is only generated when you explicitly
customize the policy via {option}`services.anubis.instances.<name>.policy`.

To add custom bot rules while keeping the defaults:

```nix
{
  services.anubis.instances.default = {
    settings.TARGET = "http://localhost:8000";
    policy.extraBots = [
      {
        name = "my-allowed-bot";
        user_agent_regex = "MyBot/.*";
        action = "ALLOW";
      }
    ];
  };
}
```

To opt out of the default bot rules entirely and define your own:

```nix
{
  services.anubis.instances.default = {
    settings.TARGET = "http://localhost:8000";
    policy = {
      useDefaultBotRules = false;
      extraBots = [
        {
          name = "my-rule";
          path_regex = ".*";
          action = "CHALLENGE";
        }
      ];
    };
  };
}
```

::: {.note}
When you customize the policy, a custom policy file is generated. This file imports the default bot rules via
`(data)/meta/default-config.yaml` when {option}`services.anubis.instances.<name>.policy.useDefaultBotRules` is enabled,
but uses Anubis's simpler legacy threshold instead of the 5-tier thresholds from `botPolicies.yaml`. If you need custom
thresholds, specify them in {option}`services.anubis.instances.<name>.policy.settings`.
:::

See [the upstream documentation](https://anubis.techaro.lol/docs/admin/policies) for all available policy options.
