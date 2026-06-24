# Pelican Panel {#module-pelican-panel}

Pelican Panel is a game server panel forked from Pterodactyl which manages Docker containers on multiple machines, using their control plane Wings.
Wings is required to use it and vice versa. To set it up, see the docs for `services.wings`.

You should probably read the [official docs](https://pelican.dev/docs/panel/getting-started) before continuing.

## Using traefik as a reverse proxy {#module-pelican-panel-traefik}

By default, the panel runs using Caddy on an insecure port (`services.pelican-panel.port`). Caddy will not listen on ports 80 and 443.
This is so you can use any reverse proxy, even another webserver like nginx.

The package has support for using traefik as a reverse proxy. See the docs for `services.traefik` on how to enable it.
For example, this could look like this:

```nix
# configuration.nix
{ pkgs, ... }:
{
  services = {
    wings = {
      # See `services.wings`
      # ...

      environment.remote = "https://panel.your.domain";
    };

    pelican-panel = {
      enable = true;

      enableTraefik = true;
      domain = "panel.your.domain";

      # in production, use a secrets manager like agenix or sops-nix
      # secrets saved like this will be world-readable in the store
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
          email = "you@your.domain";
          storage = "/var/lib/traefik/acme.json";
          tlsChallenge = { };
        };
      };
    };
  };
}
```

## Note on the database {#module-pelican-panel-mysql}

Pelican runs on MySQL (`pkgs.mysql80`) by default, but does not support socket authentication.
Because of this, the module runs an init script and creates the user with an empty password, with localhost-only access.

If this is a problem for you, overwrite `services.mysql.initialScript` or create the database yourself, then set `DB_PASSWORD` inside the secret env file.


