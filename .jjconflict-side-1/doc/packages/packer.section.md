# Packer {#sec-packer}

[Packer](https://www.packer.io) is a tool for creating identical machine images
for multiple platforms from a single source configuration.

## Using Packer with plugins {#sec-packer-with-plugins}

Packer's functionality is extended through
[plugins](https://developer.hashicorp.com/packer/docs/plugins). Rather than
letting Packer download plugins at runtime, you can build a Packer wrapper that
bundles the plugins you need with `packer.withPlugins`.

`packer.withPlugins` takes a function that receives the set of available plugins
and returns the list of plugins to include:

```nix
packer.withPlugins (ps: [ ps.docker ])
```

This produces a `packer` executable wrapped with the `PACKER_PLUGIN_PATH`
environment variable set, so the selected plugins are available without a
separate `packer plugins install` step.

For example, to get a development shell with Packer and the Docker plugin:

```nix
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = [
    (pkgs.packer.withPlugins (ps: [ ps.docker ]))
  ];
}
```

Multiple plugins can be selected at once:

```nix
packer.withPlugins (ps: [
  ps.docker
  ps.qemu
])
```

## Listing available plugins {#sec-packer-list-plugins}

The packaged plugins are exposed as the `packer.plugins` attribute set. To list
every plugin available in your version of Nixpkgs, query its attribute names:

```ShellSession
$ nix eval nixpkgs#packer.plugins --apply builtins.attrNames
[ "docker" "qemu" ]
```

Without flakes:

```ShellSession
$ nix-env -f '<nixpkgs>' -qaP -A packer.plugins
packer.plugins.docker  packer-plugin-docker-1.1.2
packer.plugins.qemu    packer-plugin-qemu-1.1.4
```

The attribute name (for example `docker` or `qemu`) is what you pass to
`packer.withPlugins`.

Notes:

- `mkPackerPlugin` currently only supports `fetchFromGitHub` as the fetcher.
