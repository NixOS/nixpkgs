# Pelican Panel {#module-pelican-panel}

[Pelican Panel](https://pelican.dev/) is a game server panel forked from [Pterodactyl](https://pterodactyl.io/) which manages Docker containers on multiple machines, using their control plane Wings.
Wings is required to use it and vice versa. To set up Wings, see the docs for [](#module-pelican-wings).

Read the [official docs](https://pelican.dev/docs/panel/getting-started) before continuing.

::: {.note}
Pelican Panel plugins are currently not supported on NixOS.
:::

## Basic Usage {#module-pelican-panel-basic-usage}

```nix
# configuration.nix
{ pkgs, ... }:
{
  pelican-panel = {
    enable = true;
    openFirewall = true;

    # Secrets saved like this will be world-readable in the store:
    secretEnvironmentFile = pkgs.writeText "secrets.env" ''
      APP_KEY="my-super-secret-app-key"
    '';
  };
}
```

The web installer is disabled by default. This means that you have to create the first admin user yourself. Run

```sh
pelican-artisan p:user:make --admin
```

The `secretEnvironmentFile` option has to be set to the absolute path of a file that exists. Please use a [proper secret management scheme](https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes) to provide it.

By default, the panel runs using Caddy on an insecure port ([](#opt-services.pelican-panel.port)). Caddy will not listen on ports 80 and 443.
This is so you can use any reverse proxy, even another webserver like nginx.

## Environment {#module-pelican-panel-environment}

All changes to `.env` will be stored in `/var/lib/pelican`, but it is recommended to configure everything through Nix where possible;
make changes with [](#opt-services.pelican-panel.environment) or [](#opt-services.pelican-panel.secretEnvironmentFile).

## Using traefik as a reverse proxy {#module-pelican-panel-traefik}

The module has support for using traefik as a reverse proxy. See the docs for [](#module-traefik) on how to enable it.
For example, a full configuration could look like this:

```nix
# configuration.nix
{ pkgs, ... }:
{
  services = {
    pelican-wings = {
      # See `services.pelican-wings`
      # ...

      configuration.remote = "https://panel.example.com";
    };

    pelican-panel = {
      enable = true;

      enableTraefik = true;
      domain = "https://panel.example.com";

      secretEnvironmentFile = pkgs.writeText "secrets.env" ''
        APP_KEY="my-super-secret-app-key"
      '';
    };

    traefik = {
      enable = true;

      staticConfigOptions = {
        entryPoints = {
          web = {
            address = ":80";

            # Redirect http to https
            http.redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
            };
          };

          websecure = {
            address = ":443";
          };
        };

        certificatesResolvers.letsencrypt.acme = {
          email = "alice@example.com";
          storage = "/var/lib/traefik/acme.json";
          tlsChallenge = { };
        };
      };
    };
  };
}
```

