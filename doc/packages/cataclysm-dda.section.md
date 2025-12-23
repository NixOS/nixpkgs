# Cataclysm: Dark Days Ahead {#cataclysm-dark-days-ahead}

## How to install Cataclysm DDA {#how-to-install-cataclysm-dda}

To install the latest stable release of Cataclysm DDA to your profile, execute
`nix-env -f "<nixpkgs>" -iA cataclysm-dda`. For the curses build (build
without tiles), install `cataclysmDDA.stable.curses`. Note: `cataclysm-dda` is
an alias to `cataclysmDDA.stable.tiles`.

If you like access to a development build of your favorite git revision,
override `cataclysm-dda-git` (or `cataclysmDDA.git.curses` if you like the curses
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
cataclysm-dda.override { useXdgDir = true; }
```

## Important note for overriding packages {#important-note-for-overriding-packages}

After applying `overrideAttrs`, you need to fix `passthru.pkgs` and
`passthru.withMods` attributes either manually or by using `attachPkgs`:

```nix
let
  # You enabled parallel building.
  myCDDA = cataclysm-dda-git.overrideAttrs (_: {
    enableParallelBuilding = true;
  });

  # Unfortunately, this refers to the package before overriding and
  # parallel building is still disabled.
  badExample = myCDDA.withMods (_: [ ]);

  inherit (cataclysmDDA) attachPkgs pkgs wrapCDDA;

  # You can fix it by hand
  goodExample1 = myCDDA.overrideAttrs (old: {
    passthru = old.passthru // {
      pkgs = pkgs.override { build = goodExample1; };
      withMods = wrapCDDA goodExample1;
    };
  });

  # or by using a helper function `attachPkgs`.
  goodExample2 = attachPkgs pkgs myCDDA;

  # badExample                     # parallel building disabled
  # goodExample1.withMods (_: [])  # parallel building enabled
in
goodExample2.withMods (_: [ ]) # parallel building enabled
```

## Customizing with mods {#customizing-with-mods}

To install Cataclysm DDA with mods of your choice, you can use `withMods`
attribute:

```nix
cataclysm-dda.withMods (mods: with mods; [ tileset.UndeadPeople ])
```

All mods, soundpacks, and tilesets available in nixpkgs are found in
`cataclysmDDA.pkgs`.

Here is an example to modify existing mods and/or add more mods not available
in nixpkgs:

```nix
let
  customMods =
    self: super:
    lib.recursiveUpdate super {
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
          hash = "...";
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
cataclysm-dda.withMods (
  mods: with mods.extend customMods; [
    tileset.UndeadPeople
    mod.Awesome
    soundpack.Fantastic
    tileset.SuperDuper
  ]
)
```
