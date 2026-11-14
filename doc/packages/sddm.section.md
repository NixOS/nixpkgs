# SDDM {#sec-sddm}

## buildSddmThemePackage {#sec-sddm-buildSddmThemePackage}

`buildSddmThemePackage` packages a theme for SDDM, for use with `services.displayManager.sddm.themePackage`.

### Inputs {#sec-sddm-buildSddmThemePackage-inputs}

`buildSddmThemePackage` accepts the arguments of `stdenvNoCC.mkDerivation`, plus:

`srcThemeDir` (String; _optional_)

: The directory in `src` that contains the theme, i.e. its `metadata.desktop`.
  Set it when the theme is not at the root of the source, such as in repositories with several themes.

: _Default:_ `"."`

`configPath` (String)

: The theme's config file, such as `theme.conf`, relative to `srcThemeDir`.
  `configOverrides` are applied on top of it.

`configOverrides` (Attribute set; _optional_)

: Settings to change in the `[General]` section of the theme's SDDM config file.
  For example, `{ background = "${./wallpaper.png}"; }` sets the background image of themes that support it.

: _Default:_ `{ }`

`sddmBuildInputs` (List of packages; _optional_)

: Qt modules the theme's QML imports, e.g. `qt6.qtsvg`.
  SDDM runs the theme in its greeter, so the NixOS module adds these to the SDDM package instead of the theme.

: _Default:_ `[ ]`

### Passthru outputs {#sec-sddm-buildSddmThemePackage-passthru}

`withConfig` (Function)

: `<pkg>.withConfig { … }` rebuilds the theme with a different set of `configOverrides`.

`testGreeter` (Package)

: To preview a theme, run `nix run -f . <pkg>.testGreeter`.
  It opens the SDDM greeter in a test window.

### Examples {#sec-sddm-buildSddmThemePackage-examples}

:::{.example #ex-buildSddmThemePackage-elegant}

# Packaging a theme

```nix
{
  buildSddmThemePackage,
  fetchFromGitHub,
  kdePackages,
}:
buildSddmThemePackage {
  pname = "elegant-sddm";
  version = "0-unstable-2024-03-30";

  src = fetchFromGitHub {
    # ...
  };

  srcThemeDir = "Elegant"; # The directory containing `metadata.desktop`
  configPath = "theme.conf"; # The `ConfigFile` in `metadata.desktop`

  sddmBuildInputs = [
    kdePackages.qt5compat
  ];
}
```

:::

:::{.example #ex-buildSddmThemePackage-withConfig}

# Changing a theme's settings

`withConfig` replaces the theme's `configOverrides`, here to use a different background in NixOS:

```nix
{
  services.displayManager.sddm.themePackage = pkgs.elegant-sddm.withConfig {
    background = "${./wallpaper.png}";
  };
}
```

:::
