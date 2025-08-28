# Urxvt {#sec-urxvt}

Urxvt, also known as rxvt-unicode, is a highly customizable terminal emulator.

## Configuring urxvt {#sec-urxvt-conf}

In `nixpkgs`, urxvt is provided by the package `rxvt-unicode`. It can be configured to include your choice of plugins, reducing its closure size from the default configuration which includes all available plugins. To make use of this functionality, use an overlay or directly install an expression that overrides its configuration, such as:

```nix
rxvt-unicode.override {
  configure =
    { availablePlugins, ... }:
    {
      plugins = with availablePlugins; [
        perls
        resize-font
        vtwheel
      ];
    };
}
```

If the `configure` function returns an attrset without the `plugins` attribute, `availablePlugins` will be used automatically.

In order to add plugins but also keep all default plugins installed, it is possible to use the following method:

```nix
rxvt-unicode.override {
  configure =
    { availablePlugins, ... }:
    {
      plugins = (builtins.attrValues availablePlugins) ++ [ custom-plugin ];
    };
}
```

To get a list of all the plugins available, open the Nix REPL and run

```ShellSession
$ nix repl
:l <nixpkgs>
map (p: p.name) pkgs.rxvt-unicode.plugins
```

Alternatively, if your shell is bash or zsh and have completion enabled, type `nixpkgs.rxvt-unicode.plugins.<tab>`.

In addition to `plugins` the options `extraDeps` and `perlDeps` can be used to install extra packages. `extraDeps` can be used, for example, to provide `xsel` (a clipboard manager) to the clipboard plugin, without installing it globally:

```nix
rxvt-unicode.override {
  configure =
    { availablePlugins, ... }:
    {
      pluginsDeps = [ xsel ];
    };
}
```

`perlDeps` is a handy way to provide Perl packages to your custom plugins (in `$HOME/.urxvt/ext`). For example, if you need `AnyEvent` you can do:

```nix
rxvt-unicode.override {
  configure =
    { availablePlugins, ... }:
    {
      perlDeps = with perlPackages; [ AnyEvent ];
    };
}
```

## Packaging urxvt plugins {#sec-urxvt-pkg}

Urxvt plugins reside in `pkgs/applications/misc/rxvt-unicode-plugins`. To add a new plugin, create an expression in a subdirectory and add the package to the set in `pkgs/applications/misc/rxvt-unicode-plugins/default.nix`.

A plugin can be any kind of derivation; the only requirement is that it should always install perl scripts in `$out/lib/urxvt/perl`. Look for existing plugins for examples.

If the plugin is itself a Perl package that needs to be imported from other plugins or scripts, add the following passthrough:

```nix
{ passthru.perlPackages = [ "self" ]; }
```

This will make the urxvt wrapper pick up the dependency and set up the Perl path accordingly.
