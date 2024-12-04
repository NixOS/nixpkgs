# Libretro

[libretro cores](https://docs.libretro.com/guides/core-list/) and related
packages.

## Adding new cores

The basic steps to add a new core are:

1. Add a new core using `mkLibretroCore` function (use one of the existing
   files as an example)
2. Add your new core to [`default.nix`](./default.nix) file
3. Try to build your core with `nix-build -A libretro.<core>`

## Using RetroArch with cores

To create a custom RetroArch derivation with the cores you want (instead of
using `retroarchFull` that includes all cores), you can use `.override` like
this:

```nix
{ pkgs, ... }:

let
  retroarchWithCores = (pkgs.retroarch.override {
    cores = with pkgs.libretro; [
      bsnes
      mgba
      quicknes
    ];
  });
in
{
  environment.systemPackages = [
    retroarchWithCores
  ];
}
```
