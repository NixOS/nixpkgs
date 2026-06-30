# desktoToDarwinBundle {#desktop-to-darwin-bundle}

This hook takes freedesktop {file}`*.desktop` files, and converts them to equivalent Darwin {file}`*.app` bundles.

This hook runs in the {command}`fixup` phase of the stdenv build process.


There are no variables to control or disable this hook.

## Examples {#desktop-to-darwin-bundle-examples}

:::{.example #ex-desktop-to-darwin-bundle}

### Using `desktopToDarwinBundle`

```nix
{
  stdenv,
  emptyDirectory,
  copyDesktopItems,
  desktopToDarwinBundle,
  sqlite,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "some-cross-platform-project";
  version = "1.0";

  src = emptyDirectory;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    copyDesktopItems
    desktopToDarwinBundle
  ];

  buildInputs = [
    sqlite
  ];

  buildFlags = [
    "production"
  ];

  desktopItems = [
    # Copy the included desktop file from the source
    "assets/crossPlat.desktop"
  ];

  postInstall = ''
    install -Dm444 assets/crossPlat.svg "$out/share/icons/hicolor/scalable/apps/crossPlat.svg"
  '';

  meta = {
    mainProgram = "crossPlat";
    description = "runs on Darwin and Linux";
  };
})
```
:::
