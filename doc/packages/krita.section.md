# Krita {#sec-krita}

## Python plugins {#krita-python-plugins}

"pykrita" plugins should be installed following
[Krita's manual](https://docs.krita.org/en/user_manual/python_scripting/install_custom_python_plugin.html).
This generally involves extracting the extension to `~/.local/share/krita/pykrita/`.

## Binary plugins {#krita-binary-plugins}

Binary plugins are Dynamically Linked Libraries to be loaded by Krita.

_Note: You most likely won't need to deal with binary plugins,
all known plugins are bundled and enabled by default._

### Installing binary plugins {#krita-install-binary-plugins}

You can choose what plugins are added to Krita by overriding the
`binaryPlugins` attribute.

If you want to add plugins instead of replacing, you can read the
list of previous plugins via `pkgs.krita.binaryPlugins`:

```nix
(pkgs.krita.override (old: {
    binaryPlugins = old.binaryPlugins ++ [ your-plugin ];
}))
```

### Example structure of a binary plugin {#krita-binary-plugin-structure}

```
/nix/store/00000000000000000000000000000000-krita-plugin-example-1.2.3
└── lib
   └── kritaplugins
      └── krita_example.so
```
