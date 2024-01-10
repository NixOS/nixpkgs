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
```
{
    services.athens = {
      enable = true;
    };
}
```

If you want to prevent Athens from writing to disk, you can instead configure it to cache modules only in memory:

```
{
    services.athens = {
      enable = true;
      storageType = "memory";
    };
}
```

To use the local proxy in Go builds, you can set the proxy as environment variable:

```
{
  environment.variables = {
    GOPROXY = "http://localhost:3000"
  };
}
```

It is currently not possible to use the local proxy for builds done by the Nix daemon. This might be enabled
by experimental features, specifically [`configurable-impure-env`](https://nixos.org/manual/nix/unstable/contributing/experimental-features#xp-feature-configurable-impure-env),
in upcoming Nix versions.
