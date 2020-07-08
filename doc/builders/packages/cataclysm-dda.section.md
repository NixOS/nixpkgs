# Cataclysm: Dark Days Ahead

## How to install Cataclysm DDA

To install the latest stable release of Cataclysm DDA to your profile, execute
`nix-env -f "<nixpkgs>" -iA cataclysm-dda`. For the curses build (build
without tiles), install `cataclysmDDA.stable.curses`. Note: `cataclysm-dda` is
an alias to `cataclysmDDA.stable.tiles`.

If you like access to a development build of your favorite git revision,
override `cataclysm-dda-git` (or `cataclysmDDA.git.curses` if you like curses
build):

```nix
cataclysm-dda-git.override {
  version = "YYYY-MM-DD";
  rev = "YOUR_FAVORITE_REVISION";
  sha256 = "CHECKSUM_OF_THE_REVISION";
}
```

The sha256 checksum can be obtained by

```sh
nix-prefetch-url --unpack "https://github.com/CleverRaven/Cataclysm-DDA/archive/${YOUR_FAVORITE_REVISION}.tar.gz"
```

The default configuration directory is `~/.cataclysm-dda`. If you prefer
`$XDG_CONFIG_HOME/cataclysm-dda`, override the derivation:

```nix
cataclysm-dda.override {
  useXdgDir = true;
}
```

## Customizing with mods

To install Cataclysm DDA with mods of your choice, you can use `withMods`
attribute:

```nix
cataclysm-dda.withMods (mods: with mods; [
  tileset.UndeadPeople
])
```

All mods, soundpacks, and tilesets available in nixpkgs are found in
`cataclysmDDA.pkgs`.

Here is an example to modify existing mods and/or add more mods not available
in nixpkgs:

```nix
let
  customMods = self: super: lib.recursiveUpdate super {
    # Modify existing mod
    tileset.UndeadPeople = super.tileset.UndeadPeople.overrideAttrs (old: {
      # If you like to apply a patch to the tileset for example
      patches = [ ./path/to/your.patch ];
    });

    # Add another mod
    mod.Awesome = cataclysmDDA.buildMod {
      modName = "Awesome";
      version = "0.x";
      src = fetchFromGitHub {
        owner = "Someone";
        repo = "AwesomeMod";
        rev = "...";
        sha256 = "...";
      };
      # Path to be installed in the unpacked source (default: ".")
      modRoot = "contents/under/this/path/will/be/installed";
    };

    # Add another soundpack
    soundpack.Fantastic = cataclysmDDA.buildSoundPack {
      # ditto
    };

    # Add another tileset
    tileset.SuperDuper = cataclysmDDA.buildTileSet {
      # ditto
    };
  };
in
cataclysm-dda.withMods (mods: with mods.extend customMods; [
  tileset.UndeadPeople
  mod.Awesome
  soundpack.Fantastic
  tileset.SuperDuper
])
```
