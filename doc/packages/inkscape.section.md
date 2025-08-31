# Inkscape {#sec-inkscape}

[Inkscape](https://inkscape.org) is a powerful vector graphics editor.

## Plugins {#inkscape-plugins}
Inkscape plugins are collected in the [`inkscape-extensions`](https://search.nixos.org/packages?channel=unstable&type=packages&query=cudaPackages) package set.
To enable them, use an override on `inkscape-with-extensions`:

```nix
inkscape-with-extensions.override {
  inkscapeExtensions = with inkscape-extensions; [ inkstitch ];
}
```

Similarly, this works in the shell:

```bash
$ nix-shell -p 'inkscape-with-extensions.override { inkscapeExtensions = with inkscape-extensions; [inkstitch]; }'
[nix-shell:~]$ # Ink/Stitch is now available via the extension menu
[nix-shell:~]$ inkscape
```

All available extensions can be enabled by passing `inkscapeExtensions = null;`.

::: {.note}
Loading the Inkscape extensions stand-alone (without using `override`) does not affect Inkscape at all.
:::
