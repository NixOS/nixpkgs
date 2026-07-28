# `installFonts` {#installfonts}

This hook installs common font formats to the proper location. In its default state, the hook automatically handles ttf, ttc, otf, bdf, and psf. Given a `webfont` output, woff and woff2 formats will be installed under this output.

The automatic behavior of the hook can be disabled by setting the `dontInstallFonts` variable to true.

Additionally, it exposes the `installFont` function that can be used from your `postInstall`
hook, to install additional formats:

## `installFont` {#installfonts-installfont}

The `installFont` function takes two arguments, a file extension to move (*without* a preceding dot), and the install location.

### Example Usage {#installfonts-installfont-exampleusage}

```nix
{
  nativeBuildInputs = [ installFonts ];

  postInstall = ''
    installFont svg $out/share/fonts/svg
  '';
}
```
