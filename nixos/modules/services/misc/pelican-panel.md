# Pelican Panel {#module-pelican-panel}

[Pelican Panel](https://pelican.dev/) is a game server panel forked from [Pterodactyl](https://pterodactyl.io/) which manages Docker containers on multiple machines, using their control plane Wings.
Wings is required to use it and vice versa. To set up Wings, see the docs for [](#opt-services.pelican-wings.enable).

Read the [official docs](https://pelican.dev/docs/panel/getting-started) before continuing.

::: {.note}
Pelican Panel plugins are currently not supported on NixOS.
:::

## Basic Usage {#module-pelican-panel-basic-usage}

```nix
# configuration.nix
{ pkgs, ... }:
{
  services.pelican-panel = {
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
You can configure Caddy to serve via https by setting [](#opt-services.pelican-panel.domain) to a valid domain and the port to 443.

## Environment {#module-pelican-panel-environment}

All changes to `.env` will be stored in `/var/lib/pelican`, but it is recommended to configure everything through Nix where possible;
make changes with [](#opt-services.pelican-panel.environment) or [](#opt-services.pelican-panel.secretEnvironmentFile).


## Reverse proxying {#module-pelican-panel-reverse-proxy}

Currently, only Caddy is supported as the webserver.
By default, it doesn't listen on :80 or :443, but can be configured to serve the panel via HTTPS:

```nix
# configuration.nix
{ pkgs, ... }:
{
  services.pelican-panel = {
    enable = true;

    webserver = "caddy";
    domain = "https://panel.domain.com";
    port = 443;

    secretEnvironmentFile = pkgs.writeText "secrets.env" ''
      APP_KEY="my-super-secret-app-key"
    '';
  };
}
```

You may also set `webserver` to `"none"` to serve `/var/lib/pelican/www` using your own webserver.
Alternatively, you can set `caddy.domain` to `null` and `port` to something else than 80 or 443 (8080 by default).
For example, to serve the panel using Caddy, with Traefik as the reverse proxy, use:

```nix
# configuration.nix
{ pkgs, config, ... }:
let
  domain = "panel.domain.com";
in
{
  services = {
    pelican-panel = {
      enable = true;

      webserver = "caddy";
      domain = "https://${domain}";
      caddy.domain = null;

      secretEnvironmentFile = pkgs.writeText "secrets.env" ''
        APP_KEY="my-super-secret-app-key"
      '';
    };

    traefik.dynamicConfigOptions.http = {
      routers.pelican = {
        entryPoints = [ "websecure" ];
        rule = "Host(`${domain}`)";
        service = "pelican";
        tls.certResolver = "letsencrypt";
      };

      services.pelican.loadBalancer = {
        passHostHeader = true;
        servers = [ { url = "http://127.0.0.1:${toString config.services.pelican-panel.port}"; } ];
      };
    };
  };
}
```
