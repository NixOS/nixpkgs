# RetroArch

This directory includes [RetroArch](https://www.retroarch.com/), [libretro
cores](https://docs.libretro.com/guides/core-list/) and related packages.

## Adding new cores

The basic steps to add a new core are:

1. Add the core repository to [update_cores.py](./update_cores.py) inside the
   `CORES` map.
   - The minimum required parameter is `repo`
   - If the repository owner is not `libretro`, set `owner` parameter
   - If the core needs submodules, set `fetch_submodules` parameter to `True`
   - To pin the core to a specific release, set `rev` parameter
2. Run `./pkgs/applications/emulators/retroarch/update_cores.py <emulator>` to
   generate [`hashes.json`](./hashes.json) file
3. Add your new core to [`cores.nix`](./cores.nix) file, using
   [`mkLibretroCore`](./mkLibretroCore.nix) function
   - In general, the attribute name should be the same as the repo name, unless
   there is a good reason not to
   - Check the core repo and [Libretro
   documentation](https://docs.libretro.com/) for the core you're trying to add
   for instructions on how to build
   - Also check the examples inside [`cores.nix`](./cores.nix)
   - If your core is recently released, there is a good chance that you may
   need to update [`libretro-core-info`](./libretro-core-info.nix) for things
   to work inside RetroArch
4. Try to build your core with `nix-build -A libretro.<core>`

## Updating cores

Just run:

```console
# From the root of your nixpkgs directory
./pkgs/applications/emulators/retroarch/update_cores.nix
```

Keep in mind that because of the huge amount of cores that we package here, it
is recommended to set `GITHUB_TOKEN` to your GitHub's [Personal Access
Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
(PAT), otherwise the update will probably fail due to GitHub's API rate limit.

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
