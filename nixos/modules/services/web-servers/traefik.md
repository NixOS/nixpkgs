# Traefik {#module-services-traefik}

[Traefik][upstream-1] is an open-source, cloud-native reverse proxy with that
can be configured in NixOS using the {option}`services.traefik` option set.

## Basic Usage {#module-services-traefik-usage}

A key feature of Traefik is that the reverse proxy configuration is split into
two: a **static configuration** that requires Traefik to be restarted in order
to update it, and a **dynamic configuration** that can change without a need to
restart the server. The [upstream documentation][upstream-2] has a detailed
overview on the difference between both configuration types.

### Static Configuration {#module-services-traefik-usage-static}

The static configuration is controlled by the {option}`services.traefik.static`
option set.

- The {option}`services.traefik.static.file` option allows you to pass a path to
  a file containing a Traefik configuration.

- The {option}`services.traefik.static.settings` option instead allows you to
  declare the Traefik configuration directly in the NixOS configuration, using
  the usual Nix syntax.

### Dynamic Configuration {#module-services-traefik-usage-dynamic}

The dynamic configuration has a similar option set to the static configuration,
but it also has the {option}`services.traefik.dynamic.dir` option, which allows
you to define a directory containing several Traefik dynamic configuration files.

## Plugins {#module-services-traefik-plugins}

When using the structured `settings` configuration options, the Traefik module
supports [plugins][upstream-3]. Plugins in Traefik are an additional dynamic
configuration source and can programatically set up routes and proxies.

The {option}`services.traefik.plugins` option takes in a list of derivations
that contain Traefik plugins. Some plugins are available in the package set, and
can be called directly from `pkgs`. The example below sets up `geoblock`, a
Traefik plugin that blocks connections from a given list of countries based on
the client's IP address, to block all connections not coming from the Netherlands.

```nix
{
  services.traefik = {
    plugins = with pkgs; [ geoblock ];
    static.settings.entryPoints.websecure.http.middlewares = "my-geoblock";
    dynamic.settings.http.middlewares.my-geoblock.plugin.geoblock.countries = [ "NL" ];
  };
}
```

### Custom Plugins {#module-services-traefik-plugins-custom}

Plugins that are not currently packaged in Nixpkgs can also be added to the
{option}`services.traefik.plugins` option after being built with the
`fetchTraefikPlugin` builder. See the [Nixpkgs manual section on
`fetchTraefikPlugin`][fetcher] for more information on the available options.

```nix
{
  services.traefik.plugins = [
    (pkgs.fetchTraefikPlugin {
      plugin = "example";
      owner = "example-author";
      version = "1.0.0";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    })
  ];
}
```

For plugins not found in `plugins.traefik.io`, simply use the
[`lib.fileset.toSource` library function][fileset] to build a derivation from a path to a
local plugin. The module will generate a warning mentioning that the local plugin
may be misconfigured, but it can be safely ignored, or removed by updating the
derivation to include the `_isTraefikPlugin` attribute.

```nix
{
  services.traefik.plugins = [
    (
      (lib.fileset.toSource {
        root = ./my-plugin;
        fileset = ./my-plugin;
      })
      # Supress Traefik module warning.
      # Don't forget to ensure that ./my-plugin has an appropriate
      # directory structure as expected by Traefik.
      // {
        _isTraefikPlugin = true;
      }
    )
  ];
}
```

## Environment Files {#module-services-traefik-environment}

Although the Traefik module offers the {option}`services.traefik.environmentFiles`
option to set up environment files for the running server, *it is not recommended
to use them as static configuration sources*. The environment files are intended
to provision secrets for ACME/Let's Encrypt and other certificate setups.

See the [upstream documentation][upstream-4] for more information on passing
ACME secrets for setting up DNS-01 challenges.

If you are passing secrets and other data but **not configuration options** via
the {option}`services.traefik.environmentFiles` option, then it is a good idea to
disable the {option}`services.traefik.useEnvSubst` option for increased startup
performance.

[fetcher]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-fetchers-fetchtraefikplugin
[fileset]: https://nixos.org/manual/nixpkgs/stable/#function-library-lib.fileset.toSource
[upstream-1]: https://traefik.io
[upstream-2]: https://doc.traefik.io/traefik/getting-started/configuration-overview
[upstream-3]: https://plugins.traefik.io/plugins
[upstream-4]: https://doc.traefik.io/traefik/https/acme/#providers
