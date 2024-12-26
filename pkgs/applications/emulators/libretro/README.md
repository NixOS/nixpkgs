# Libretro

[libretro cores](https://docs.libretro.com/guides/core-list/) and related
packages.

## Adding new cores

The basic steps to add a new core are:

1. Add a new core using `mkLibretroCore` function (use one of the existing
   cores as an example)
2. Add your new core to [`default.nix`](./default.nix) file
3. Try to build your core with `nix-build -A libretro.<core>`

## Using RetroArch with cores

To create a custom RetroArch derivation with the cores you want (instead of
using `retroarch-full` that includes all cores), you can use `.withCores` like
this:

```nix
{ pkgs, ... }:

let
  retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
    bsnes
    mgba
    quicknes
  ]));
in
{
  environment.systemPackages = [
    retroarchWithCores
  ];
}
```

For advanced customization, see `wrapRetroArch` wrapper.
