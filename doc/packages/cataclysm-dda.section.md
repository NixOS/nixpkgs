# Cataclysm: Dark Days Ahead and Forks {#cataclysm-dark-days-ahead}

## How to install Cataclysm DDA {#how-to-install-cataclysm-dda}

To install the latest stable release of Cataclysm DDA to your profile, add `cataclysmPackages.dark-days-ahead` to your Nix profile.
For the tile build, add `cataclysm.dark-days-ahead.withTiles`.

To install an arbitrary build of unstable Dark Days Ahead, use the following override:
```nix
cataclysmPackages.dark-days-ahead-unstable.overrideAttrs (
  final: prev: {
    version = "YYYY-MM-DD-BUILD";
    src = prev.src // {
      tag = final.version;
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    };
  }
)
```

The sha256 checksum can be obtained by

```sh
nix flake prefetch github:CleverRaven/Cataclysm-DDA/${YOUR_FAVORITE_REVISION}
```
or
```sh
nix-prefetch-url --unpack "https://github.com/CleverRaven/Cataclysm-DDA/archive/${YOUR_FAVORITE_REVISION}.tar.gz"
```

The default configuration directory is `$XDG_CONFIG_HOME/.cataclysm-dda`. If you prefer
`~/.cataclysm-dda`, override the derivation:

```nix
cataclsymPackages.dark-days-ahead.overrideAttrs { useXdgDir = false; }
```

##  cataclysm.mkCataclysm {#cataclysm-mkCataclysm}

`cataclysm.mkCataclysm` *`attrs`*

Cataclysm and its forks can be built with the generic builder provided.

### Inputs {#cataclysm-mkCataclysm-inputs}

This is a derivation builder that can have a fixed-point parameter. It accepts all
arguments as `stdenv.mkDerivation`, and sets some by default.

This derivation builder unconditionally sets `__structuredAttrs` and `strictDeps` to `true`.

*`pname`* (String; _optional_)

: The package name.
: _Default:_ "cataclysm-dda"

*`nativeBuildInputs`* (List; _optional_)
: The binaries required on the build machine to build the game.
: _Default:_ [ gettext pkg-config ]

*`buildInputs`* (List; _optional_)
: The binaries or libraries required on the host machine to run the game.
: _Default:_ [ gettest zlib ncurses ]

*`makeFlags`* (List; _optional_)
: The flags pass to all invocations of the Makefile, if used.
: _Default:_ [ "TESTS=0" "ASTYLE=0" "DYNAMIC_LINKING=1" "VERSION=$version" "PREFIX=$(out)" "LANGUAGES=all" "USE_XDG_DIR=1" "RELEASE=1" ]

*`cmakeFlags`* (List; _optional_)
: The flags to pass to CMake if used for the build.
: _Default:_ [ (lib.cmakeBool "USE_PREFIX_DATA_DIR" true) (lib.cmakeBool "CURSES" true) (lib.cmakeBool "SOUND" false) (lib.cmakeBool "TILES" false) (lib.cmakeBool "USE_XDG_DIR" true) (lib.cmakeBool "USE_HOME_DIR" false) ]

*`useXdgDir`* (bool; _optional_)
: Whether to use XDG_CONFIG_HOME for save data or not
: _Default:_ `true`

:::{.example #cataclysm-mkCataclysm-example}

### `cataclsymPackages.mkCataclysm` usage
```nix
cataclysm.mkCataclysm (finalAttrs: {
  # Provide the name & version
  pname = "cataclsym-super-cool";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "CoolPerson";
    repo = "cataclysm-super-cool";
    tag = finalAttrs.version;
    hash = "sha256-AAAAAAAAAAAAAAAAAA";
  };

  # If it uses Cmake for the build, set to true
  useCmake = true;

  # Set by default to DDA build-time dependencies
  # Any extra executables needed on PATH for the build
  nativeBuildInputs = [
    ripgrep
  ];

  # Set by default to DDA dependencies
  # Any extra libraries or executables needed at runtime
  buildInputs = [
    udev
  ];

  # Any extra cmakeFlags needed
  cmakeFlags = [
    (lib.cmakeBool "ENABLE_THINGY" true)
  ];

  # Any extra makeFlags needed. If using CMake this is ignored.
  makeFlags = [
    "THINGY=1"
  ];

  # Set by default to DDA, should be set for any forks.
  meta = {
    description = "super cool fork of Cataclysm DDA";
    longDescription = ''
      super cool fork of Cataclysm DDA
      Adds really cool things
    '';
    homepage = "supercoolcataclysm.org";
    changelog = "github.com/CoolPerson/cataclysm-super-cool/tag/${finalAttrs.version}";
    maintainers = [ lib.maintainers.person ];
  };
})
```
:::

## Customizing with mods {#customizing-with-mods}

To install Cataclysm DDA with mods of your choice, you can use `withMods`
attribute:

```nix
cataclysm.dark-days-ahead.withTiles.withMods (p: [ p.tileSets.undeadPeople ])
```

All mods, soundpacks, and tilesets available in nixpkgs are found in
`cataclysmPackages.pkgs`.

Here is an example to modify existing mods and/or add more mods not available
in nixpkgs:

```nix
let
  customMods = cataclysmPackages.pkgs.overrideScope (
    final: prev:
    (lib.recursiveUpdate prev {
      # Modify existing mod
      tileSets.undeadPeople = prev.tileSets.undeadPeople.overrideAttrs {
        # If you like to apply a patch to the tileset for example
        patches = [ ./path/to/your.patch ];
      };

      # Add a new mod
      mods.awesome = final.buildMod {
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

      # Add a soundpack
      soundPacks.fantastic = final.buildSoundPack {
        # ditto
      };

      # Add a tileset
      tileSets.superDuper = final.buildTileSet {
        # ditto
      };
    })
  );
in
cataclysmPackages.dark-days-ahead.withTiles.withMods ([
  customMods.tileSets.undeadPeople
  customMods.mods.awesome
  customMods.soundPacks.fantastic
  customMods.tileSets.superDuper
])
```

You can also override the entire `cataclysmPackages` package set:

```nix
let
  # Override the entire cataclysm package set
  myCataclsym = cataclysmPackages.overrideScope (
    final: prev: {
      # Set the `pkgs` attribute to the new pkgSet
      pkgs = prev.pkgs.overrideScope (
        final: prev: {
          # Merge with the old one so the other tileSets are
          # Preserved. This is what the `lib.recursiveUpdate`
          # above does automatically
          tileSets = prev.tileSets // {
            superDuper = final.buildTileSet {
              # Some cool tileset
            };
          };
        }
      );
    }
  );
in
# Then instance dark-days-ahead with the overriden package set
myCataclsym.dark-days-ahead.withTiles.withMods (p: [
  p.tileSets.undeadPeople
  p.mods.awesome
  p.soundPacks.fantastic
  p.tileSets.superDuper
])
```
