# Pterodactyl Panel {#module-services-pterodactyl-panel}

[Pterodactyl](https://pterodactyl.io/panel/1.0/getting_started.html) is a free, open-source game server management panel built with PHP, React, and Go. Designed with security in mind, Pterodactyl runs all game servers in isolated Docker containers while exposing a beautiful and intuitive UI to end users.

## Basic usage {#module-services-pterodactyl-panel-basic-usage}

The module defaults to Nginx, PHP-FPM, MariaDB, and Redis.
Only the application URL and some secrets must be provided.

```nix
{
  services.pterodactyl.panel = {
    enable = true;
    app = {
      url = "https://panel.example.com";
      keyFile = "/run/secrets/pterodactyl/app-key";
    };

    hashids.saltFile = "/run/secrets/pterodactyl/hashids-salt";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
```

`services.pterodactyl.panel.app.key` and `services.pterodactyl.panel.hashids.salt` are required.
Prefer the `*File` options so secrets do not end up in the Nix store.

By default `services.pterodactyl.panel.app.environmentOnly` is set to `true`, which keeps the application configuration declarative and prevents the Panel from using the settings from the admin UI.

## CLI {#module-services-pterodactyl-panel-cli}

The module adds `pterodactyl-cli` to `environment.systemPackages`.
It runs `php artisan` from `services.pterodactyl.panel.dataDir` with all environment variables loaded.

For example, to create a user:

```sh
sudo pterodactyl-cli p:user:make
# > ...
```
