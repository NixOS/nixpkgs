# pkgs.appimageTools {#sec-pkgs-appimageTools}

`pkgs.appimageTools` is a set of functions for extracting and wrapping [AppImage](https://appimage.org/) files.
They are meant to be used if traditional packaging from source is infeasible, or if it would take too long.
To quickly run an AppImage file, `pkgs.appimage-run` can be used as well.

::: {.warning}
The `appimageTools` API is unstable and may be subject to backwards-incompatible changes in the future.
:::

## Wrapping {#ssec-pkgs-appimageTools-wrapping}

Use `wrapType2` to wrap any AppImage.
This will create a FHS environment with many packages [expected to exist](https://github.com/AppImage/pkg2appimage/blob/master/excludelist) for the AppImage to work.
`wrapType2` expects an argument with the `src` attribute, and either a `name` attribute or `pname` and `version` attributes.

It will eventually call into [`buildFHSEnv`](#sec-fhs-environments), and any extra attributes in the argument to `wrapType2` will be passed through to it.
This means that you can pass the `extraInstallCommands` attribute, for example, and it will have the same effect as described in [`buildFHSEnv`](#sec-fhs-environments).

::: {.note}
In the past, `appimageTools` provided both `wrapType1` and `wrapType2`, to be used depending on the type of AppImage that was being wrapped.
However, [those were unified early 2020](https://github.com/NixOS/nixpkgs/pull/81833), meaning that both `wrapType1` and `wrapType2` have the same behaviour now.
:::

:::{.example #ex-wrapping-appimage-from-github}

# Wrapping an AppImage from GitHub

```nix
{ appimageTools, fetchurl }:
let
  pname = "nuclear";
  version = "0.6.30";

  src = fetchurl {
    url = "https://github.com/nukeop/nuclear/releases/download/v${version}/${pname}-v${version}.AppImage";
    hash = "sha256-he1uGC1M/nFcKpMM9JKY4oeexJcnzV0ZRxhTjtJz6xw=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
}
```

:::

The argument passed to `wrapType2` can also contain an `extraPkgs` attribute, which allows you to include additional packages inside the FHS environment your AppImage is going to run in.
`extraPkgs` must be a function that returns a list of packages.
There are a few ways to learn which dependencies an application needs:

  - Looking through the extracted AppImage files, reading its scripts and running `patchelf` and `ldd` on its executables.
    This can also be done in `appimage-run`, by setting `APPIMAGE_DEBUG_EXEC=bash`.
  - Running `strace -vfefile` on the wrapped executable, looking for libraries that can't be found.

:::{.example #ex-wrapping-appimage-with-extrapkgs}

# Wrapping an AppImage with extra packages

```nix
{ appimageTools, fetchurl }:
let
  pname = "irccloud";
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/irccloud/irccloud-desktop/releases/download/v${version}/IRCCloud-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-/hMPvYdnVB1XjKgU2v47HnVvW4+uC3rhRjbucqin4iI=";
  };
in appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: [ pkgs.at-spi2-core ];
}
```

:::

## Extracting {#ssec-pkgs-appimageTools-extracting}

Use `extract` if you need to extract the contents of an AppImage.
This is usually used in Nixpkgs to install extra files in addition to [wrapping](#ssec-pkgs-appimageTools-wrapping) the AppImage.
`extract` expects an argument with the `src` attribute, and either a `name` attribute or `pname` and `version` attributes.

::: {.note}
In the past, `appimageTools` provided both `extractType1` and `extractType2`, to be used depending on the type of AppImage that was being extracted.
However, [those were unified early 2020](https://github.com/NixOS/nixpkgs/pull/81572), meaning that both `extractType1` and `extractType2` have the same behaviour as `extract` now.
:::

:::{.example #ex-extracting-appimage}

# Extracting an AppImage to install extra files

This example was adapted from a real package in Nixpkgs to show how `extract` is usually used in combination with `wrapType2`.
Note how `appimageContents` is used in `extraInstallCommands` to install additional files that were extracted from the AppImage.

```nix
{ appimageTools, fetchurl }:
let
  pname = "irccloud";
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/irccloud/irccloud-desktop/releases/download/v${version}/IRCCloud-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-/hMPvYdnVB1XjKgU2v47HnVvW4+uC3rhRjbucqin4iI=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.at-spi2-core ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/irccloud.desktop $out/share/applications/irccloud.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/irccloud.png \
      $out/share/icons/hicolor/512x512/apps/irccloud.png
    substituteInPlace $out/share/applications/irccloud.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';
}
```

:::

The argument passed to `extract` can also contain a `postExtract` attribute, which allows you to execute additional commands after the files are extracted from the AppImage.
`postExtract` must be a string with commands to run.

:::{.example #ex-extracting-appimage-with-postextract}

# Extracting an AppImage to install extra files, using `postExtract`

This is a rewrite of [](#ex-extracting-appimage) to use `postExtract`.

```nix
{ appimageTools, fetchurl }:
let
  pname = "irccloud";
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/irccloud/irccloud-desktop/releases/download/v${version}/IRCCloud-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-/hMPvYdnVB1XjKgU2v47HnVvW4+uC3rhRjbucqin4iI=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/irccloud.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
    '';
  };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.at-spi2-core ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/irccloud.desktop $out/share/applications/irccloud.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/irccloud.png \
      $out/share/icons/hicolor/512x512/apps/irccloud.png
  '';
}
```

:::
