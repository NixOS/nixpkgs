# Hy {#sec-language-hy}

## Installation {#ssec-hy-installation}

### Installation without packages {#installation-without-packages}

You can install `hy` via nix-env or by adding it to `configuration.nix` by referring to it as a `hy` attribute. This kind of installation adds `hy` to your environment and it successfully works with `python3`.

::: {.caution}
Packages that are installed with your python derivation, are not accessible by `hy` this way.
:::

### Installation with packages {#installation-with-packages}

Creating `hy` derivation with custom `python` packages is really simple and similar to the way that python does it. Attribute `hy` provides function `withPackages` that creates custom `hy` derivation with specified packages.

For example if you want to create shell with `matplotlib` and `numpy`, you can do it like so:

```ShellSession
$ nix-shell -p "hy.withPackages (ps: with ps; [ numpy matplotlib ])"
```

Or if you want to extend your `configuration.nix`:
```nix
{ # ...

  environment.systemPackages = with pkgs; [
    (hy.withPackages (py-packages: with py-packages; [ numpy matplotlib ]))
  ];
}
```
