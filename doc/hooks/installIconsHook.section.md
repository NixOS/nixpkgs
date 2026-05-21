# installIconsHook {#install-icons-hook}

This hook attempts to detect icons in a project, and install them in the [standard freedesktop locations](https://specifications.freedesktop.org/icon-theme/latest/#directory_layout)

This hook runs in the [`postInstall`](#var-stdenv-postInstall) stdenv phase.

This hook will install the icons to the stdenv-standard prefix location.

:::{.note}
This hook requires `__structuredAttrs` to be enabled.
:::

## Examples {#install-icons-hook-examples}

:::{.example #exinstall-icons-hook-examples-manual}
# Installing icons with manual specification

Imagine a package source directory with the following layout:
```
$sourceRoot
└── assets
   ├── icon16.png
   ├── icon32.png
   ├── icon64.png
   ├── icon126.png
   ├── icon256.png
   └── icon.svg
```
The following derivation would install the icons:
```nix
{
  lib,
  stdenv,
  installIconsHook,
  emptyDir,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "example1";
  version = "1.0";

  src = emptyDir;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    installIconsHook
  ];

  # Paths are all relative to the derivations CWD
  iconsToInstall = {
    "16x16" = "asssets/icon16.png";
    "32x32" = "asssets/icon32.png";
    "64x64" = "assets/icon64.png";
    "128x128" = "asssets/icon128.png";
    "256x256" = "asssets/icon256.png";
    "svg" = "assets/icon.svg";
  };
})
```
:::

:::{.example #exinstall-icons-hook-examples-detection}
# Installing icons with automatic detection
This hook can also detect name matches for icons as well.

Imagine a package source directory with the following layout:
```
$sourceRoot
└── assets
   └── icons
      ├── icon16x16.png
      ├── icon32x32.png
      ├── icon64x64.png
      ├── icon128x128.png
      ├── icon256x256.png
      └── icon.svg
```
The following derivation would detect the icons, and install them.
```nix
{
  lib,
  stdenv,
  installIconsHook,
  emptyDir,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "example2";
  version = "1.0";

  src = emptyDir;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    installIconsHook
  ];

  # Paths are all relative to the derivations CWD
  #
  # This narrows the search in case there are other
  # potential matches in other directories
  iconSearchDir = "assets/icons";
})
```
:::

## Variables controlling `installIconsHook` {#install-icons-hook-variables}

### `installIconsHook` Exclusive Variables {#install-icons-hook-exclusive-variables}

#### `iconsToInstall` {#install-icons-hook-icons-to-install}

An attribute set of icons to install, and the path to install them from.
This path is relative to the current working directory, usually [`sourceRoot`](#var-stdenv-sourceRoot).

There are specific attributes that are looked at by the hook, any others will be ignored.

All of the attributes are optional, and do not need to all be filled in. Any combination is valid.

The following attributes interpreted as PNG images.

* 8x8
* 16x16
* 32x32
* 48x48
* 64x64
* 72x72
* 96x96
* 128x128
* 256x256
* 512x512

The following other attributes are also accepted:

* svg

Path to an [SVG](https://en.wikipedia.org/wiki/SVG) file of the icon.

* ico

Path to an [ICO](https://en.wikipedia.org/wiki/ICO_(file_format)) archive of icons, usually created for Windows installations.
This hook can unpack these archives and install the icons inside.


The following attribute set informs the hook of icons that are at `$CWD/assets`, as well as an addtional icon that is fetched.
The paths can be store paths, and do not need to be in the source directory.

```
iconsToInstall = {
  "16x16" = "asssets/icon16.png";
  "32x32" = "asssets/icon32.png";
  "256x256" = "asssets/icon256.png";
  "64x64" = fetchurl {
    url = "somewebsite.com/icon.png";
    hash = lib.fakeHash;
  };
  "svg" = "assets/icon.svg";
  "ico" = "assets/icon.ico"
};
```

#### `installIconsSearchDir` {#install-icons-hook-search-dir}

The directory to search for icons in. This directory is relative to the current working directory, but can also be an absolute path or store directory.
By default it is the current working directory.

#### `installIconName` {#install-icons-name}

The name to install the icons with. This is not usually needed, as by default it is set to the value of `meta.mainProgram.
But if installing icons for something else, or for a program that is not the main program, this will set the names.

```
installIconName = "someProgram";
```

#### `extraIconsToInstall` {#install-icons-hook-extra}

These are icons that do not fit in with the freedesktop hicolor standard.
These icons will be placed at `$prefix/share/icons/$icon.png`.
A single png and a single svg can be used as extra icons.
This is due to how freedesktop specifies icon lookup.
It is keyed by application name, and also only allows png and svg extensions.

Examples of what these could be are very large icons and icons of non-standard sizes.

```
{
  extraIconsToInstall = {
    png = "assets/weird-icon.png";
    svg = "assets/weird-icon.svg"
  };
}
```
#### `dontInstallIcons` {#install-icons-hook-dont}

Disable automatic installing of icons.
Allows usage of the Bash icon installation helpers.

```nix
{
  dontInstallIcons = true;
  postInstall = ''
    installHicolorIcon "$out" "assets/icon1.png" "cool_program_name" "16x16"
    installHicolorIcon "$out" "assets/icon2.png" "cool_program_name" "32x32"
    installHicolorIcon "$out" "assets/icon3.png" "cool_program_name" "64x64"

    installOtherIcon "$out" "assets/other.png" "cool_program_name.png"
  '';
}
```

