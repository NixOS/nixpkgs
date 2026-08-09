# traggo {#module-services-traggo}

[traggo](https://traggo.net/) is a self-hosted, tag-based time tracking server.

## Configuration {#module-services-traggo-configuration}

```nix
{
  services.traggo = {
    enable = true;
    environment.TRAGGO_PORT = 8080;
    environmentFiles = [ "/run/secrets/traggo" ];
  };
}
```

Put secrets such as `TRAGGO_DEFAULT_USER_PASS` in
{option}`services.traggo.environmentFiles` rather than
{option}`services.traggo.environment`, since the latter ends up
world-readable in the Nix store.

See <https://traggo.net/config/> for the full list of settings.
