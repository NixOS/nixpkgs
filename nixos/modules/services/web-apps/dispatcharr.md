# Dispatcharr {#module-services-dispatcharr}

Dispatcharr is a web-based IPTV stream, M3U/EPG, and HDHomeRun management companion.

## Basic usage {#module-services-dispatcharr-basic-usage}

A minimal working configuration looks like this:

```nix
{ pkgs, ... }:
{
  services.dispatcharr = {
    enable = true;
    secretKeyFile = "/run/secrets/dispatcharr-secret-key";
  };

  # Create the secret file before the service starts. In a real deployment you
  # would use a secret management tool such as sops-nix or agenix.
  systemd.services.dispatcharr-migrations.serviceConfig.EnvironmentFile =
    pkgs.writeText "dispatcharr-secret-key" ''
      DJANGO_SECRET_KEY=change-me-to-a-long-random-string
    '';
}
```

The module automatically provisions a local PostgreSQL database and a local
Redis server for Dispatcharr.

## Reverse proxy {#module-services-dispatcharr-reverse-proxy}

The module does not serve static files itself. In production, place Dispatcharr
behind a reverse proxy such as nginx and serve the static files collected under
`''${config.services.dispatcharr.dataDir}/static/` from the `/static/` path.
