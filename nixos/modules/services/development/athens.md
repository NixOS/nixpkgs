# Athens {#module-athens}

*Source:* {file}`modules/services/development/athens.nix`

*Upstream documentation:* <https://docs.gomods.io/>

[Athens](https://github.com/gomods/athens)
is a Go module datastore and proxy

The main goal of Athens is providing a Go proxy (`$GOPROXY`) in regions without access to `https://proxy.golang.org` or to
improve the speed of Go module downloads for CI/CD systems.

## Configuring {#module-services-development-athens-configuring}

A complete list of options for the Athens module may be found
[here](#opt-services.athens.enable).

## Basic usage for a caching proxy configuration {#opt-services-development-athens-caching-proxy}

A very basic configuration for Athens that acts as a caching and forwarding HTTP proxy is:
```nix
{
    services.athens = {
      enable = true;
    };
}
```

If you want to prevent Athens from writing to disk, you can instead configure it to cache modules only in memory:

```nix
{
    services.athens = {
      enable = true;
      storageType = "memory";
    };
}
```

To use the local proxy in Go builds (outside of `nix`), you can set the proxy as environment variable:

```nix
{
  environment.variables = {
    GOPROXY = "http://localhost:3000";
  };
}
```

To also use the local proxy for Go builds happening in `nix` (with `buildGoModule`), the nix daemon can be configured to pass the GOPROXY environment variable to the `goModules` fixed-output derivation.

This can either be done via the nix-daemon systemd unit:

```nix
{
  systemd.services.nix-daemon.environment.GOPROXY = "http://localhost:3000";
}
```

or via the [impure-env experimental feature](https://nix.dev/manual/nix/2.24/command-ref/conf-file#conf-impure-env):

```nix
{
  nix.settings.experimental-features = [ "configurable-impure-env" ];
  nix.settings.impure-env = "GOPROXY=http://localhost:3000";
}
```
