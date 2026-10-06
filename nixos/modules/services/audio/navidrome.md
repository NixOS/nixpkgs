# Navidrome {#module-services-navidrome}

[Navidrome](https://www.navidrome.org/) is an open source web-based music collection server and streamer.

## Basic usage {#module-services-navidrome-basic-usage}

A minimal configuration with an existing music directory looks like this:
```nix
{
  services.navidrome = {
    enable = true;
    settings = {
      # This folder will be mounted with BindReadOnlyPaths
      MusicFolder = "/mnt/share/music";
    };
  };
}
```

This will start the Navidrome service on the default port (`4533`) and start
scanning your music folder to build the library.

## Configuration Options {#module-services-navidrome-configuration-options}

Navidrome's documentation lists all the [available
options](https://www.navidrome.org/docs/usage/configuration/options/#available-options)
for configuring your service. The `services.navidrome.settings` option generates
a JSON file which should serve for nearly all the options. Some defaults are
already in place in the module (such as opting out of [Anonymous Data
Collection](https://www.navidrome.org/docs/usage/admin/insights/)) be sure to
consult the defaults for more information.

## Secrets {#module-services-navidrome-secrets}

You may have some secret values that you do not want exposed in the Nix store.
Most configuration values in Navidrome have Environment Variable alternatives
(start with `ND_` see the docs for more). Create a secret file and set
`services.navidrome.environmentFile` with the path, Navidrome's systemd unit
will source this before launching.

## Plugins {#module-services-navidrome-plugins}

Navidrome supports externally created
[plugins](https://www.navidrome.org/docs/usage/features/plugins/). Some of these
already exist in Nixpkgs and builders exist for Rust (`pkgs.buildNavidromeRustPlugin`) and Go (`pkgs.buildNavidromeGoPlugin`). Plugins are compiled to WASM so you must reference them using `pkgsCross` instead of directly from `pkgs`, like so: `pkgs.pkgsCross.wasi32.navidromePlugins.<name>`. An example of adding plugins to a Navidrome configuration is as follows:
```nix
{
  services.navidrome = {
    enable = true;
    plugins = with pkgs.pkgsCross.wasi32.navidromePlugins; [
      listenbrainz-daily-playlist
      lyrics-plugin
    ];
    settings = {
      MusicFolder = "/mnt/share/music";
    };
  };
}
```
