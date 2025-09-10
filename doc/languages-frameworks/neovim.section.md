# Neovim {#neovim}

Install `neovim-unwrapped` to get a bare-bones Neovim to configure imperatively.
This is the closest to what you encounter on other distributions.

`neovim` is a wrapper around Neovim with some extra configuration, for
instance, to set the various language providers like Python.
The wrapper can be further configured to include your favorite plugins and
configurations for a reproducible neovim across machines.
See the next section for more details.

## Custom configuration {#neovim-custom-configuration}

There are two wrappers available to provide additional configuration around the vanilla package `pkgs.neovim-unwrapped`:
1. `wrapNeovim`: the historical one you should use
2. `wrapNeovimUnstable` intended to replace the former. It has more features but
   the interface is not stable yet.

You can configure the former via:

```nix
neovim.override {
  configure = {
    customRC = ''
      # here your custom configuration goes!
    '';
    packages.myVimPackage = with pkgs.vimPlugins; {
      # See examples below on how to use custom packages.
      start = [ ];
      # If a Vim plugin has a dependency that is not explicitly listed in
      # `opt`, that dependency will always be added to `start` to avoid confusion.
      opt = [ ];
    };
  };
}
```
`myVimPackage` is an arbitrary name for the generated package. You can choose any name you like.

If you want to use `neovim-qt` as a graphical editor, you can configure it by overriding Neovim in an overlay
or passing it an overridden Neovim:

```nix
neovim-qt.override {
  neovim = neovim.override {
    configure = {
      customRC = ''
        # your custom configuration
      '';
    };
  };
}
```

You can use the new unstable wrapper but the interface may change:
- `autoconfigure`: certain plugins need a custom configuration to work with Nix.
For instance, `sqlite-lua` needs `g:sqlite_clib_path` to be set to work. Nixpkgs historically patched these in the plugins with several drawbacks: harder maintenance and making upstream work harder. Per convention, these mandatory bits of configuration are bookmarked in nixpkgs in `passthru.initLua`. Enabling `autoconfigure` automatically adds the snippets required for the plugins to work.
- `autowrapRuntimeDeps`: Appends plugin's runtime dependencies to `PATH`. For instance, `rest.nvim` requires `curl` to work. Enabling `autowrapRuntimeDeps` adds it to the `PATH` visible by your Neovim wrapper (but not your global `PATH`).
- `luaRcContent`: Extra lua code to add to the generated `init.lua`.
- `neovimRcContent`: Extra vimL code sourced by the generated `init.lua`.
- `wrapperArgs`: Extra arguments forwarded to the `makeWrapper` call.
- `wrapRc`: Nix, not being able to write in your `$HOME`, loads the
  generated Neovim configuration via the `$VIMINIT` environment variable, i.e. : `export VIMINIT='lua dofile("/nix/store/…-init.lua")'`. This has side effects like preventing Neovim from sourcing your `init.lua` in `$XDG_CONFIG_HOME/nvim` (see bullet 7 of [`:help startup`](https://neovim.io/doc/user/starting.html#startup) in Neovim). Disable it if you want to generate your own wrapper. You can still reuse the generated vimscript init code via `neovim.passthru.initRc`.
- `plugins`: A list of plugins to add to the wrapper.

```
wrapNeovimUnstable neovim-unwrapped {
  autoconfigure = true;
  autowrapRuntimeDeps = true;
  luaRcContent = ''
    vim.o.sessionoptions = 'buffers,curdir,help,tabpages,winsize,winpos,localoptions'
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '
    vim.opt.smoothscroll = true
    vim.opt.colorcolumn = { 100 }
    vim.opt.termguicolors = true
  '';
  # plugins accepts a list of either plugins or { plugin = ...; config = ..vimscript.. };
  plugins = with vimPlugins; [
    {
      plugin = vim-obsession;
      config = ''
        map <Leader>$ <Cmd>Obsession<CR>
      '';
    }
    (nvim-treesitter.withPlugins (p: [ p.nix p.python ]))
    hex-nvim
  ];
}
```

You can explore the configuration with`nix repl` to discover these options and
override them. For instance:
```nix
neovim.overrideAttrs (oldAttrs: {
  autowrapRuntimeDeps = false;
})
```

### Specificities for some plugins {#neovim-plugin-specificities}

### Plugin optional configuration {#neovim-plugin-required-snippet}

Some plugins require specific configuration to work. We choose not to
patch those plugins but expose the necessary configuration under
`PLUGIN.passthru.initLua` for neovim plugins. For instance, the `unicode-vim` plugin
needs the path towards a unicode database so we expose the following snippet `vim.g.Unicode_data_directory="${self.unicode-vim}/autoload/unicode"` under `vimPlugins.unicode-vim.passthru.initLua`.

#### LuaRocks based plugins {#neovim-luarocks-based-plugins}

In order to automatically handle plugin dependencies, several Neovim plugins
upload their package to [LuaRocks](https://www.luarocks.org). This means less work for nixpkgs maintainers in the long term as dependencies get updated automatically.
This means several Neovim plugins are first packaged as nixpkgs [lua
packages](#packaging-a-library-on-luarocks), and converted via `buildNeovimPlugin` in
a vim plugin. This conversion is necessary because Neovim expects lua folders to be
top-level while LuaRocks installs them in various subfolders by default.

For instance:
```nix
{
  rtp-nvim = neovimUtils.buildNeovimPlugin { luaAttr = luaPackages.rtp-nvim; };
}
```
To update these packages, you should use the lua updater rather than vim's.

#### Treesitter {#neovim-plugin-treesitter}

By default `nvim-treesitter` encourages you to download, compile and install
the required Treesitter grammars at run time with `:TSInstall`. This works
poorly on NixOS.  Instead, to install the `nvim-treesitter` plugins with a set
of precompiled grammars, you can use the `nvim-treesitter.withPlugins` function:

```nix
(pkgs.neovim.override {
  configure = {
    packages.myPlugins = with pkgs.vimPlugins; {
      start = [
        (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            nix
            python
          ]
        ))
      ];
    };
  };
})
```

To enable all grammars packaged in nixpkgs, use `pkgs.vimPlugins.nvim-treesitter.withAllGrammars`.


### Testing Neovim plugins {#testing-neovim-plugins}

#### neovimRequireCheck {#testing-neovim-plugins-neovim-require-check}
`neovimRequireCheck` is a simple test which checks if Neovim can require lua modules without errors. This is often enough to catch missing dependencies.

It accepts a single string for a module, or a list of module strings to test.
- `nvimRequireCheck = MODULE;`
- `nvimRequireCheck = [ MODULE1 MODULE2 ];`

When `nvimRequireCheck` is not specified, we will search the plugin's directory for lua modules to attempt loading. This quick smoke test can catch obvious dependency errors that might be missed.
The check hook will fail the build if any modules cannot be loaded. This encourages inspecting the logs to identify potential issues.

To only check a specific module, add it manually to the plugin definition [overrides](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/overrides.nix).

```nix
{
  gitsigns-nvim = super.gitsigns-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimRequireCheck = "gitsigns";
  };
}
```
Some plugins will have lua modules that require a user configuration to function properly or can contain optional lua modules that we don't want to test by requiring.
We can skip specific modules using `nvimSkipModules`. Similar to `nvimRequireCheck`, it accepts a list of strings.
- `nvimSkipModules = [ MODULE1 MODULE2 ];`

```nix
{
  asyncrun-vim = super.asyncrun-vim.overrideAttrs {
    nvimSkipModules = [
      # vim plugin with optional toggleterm integration
      "asyncrun.toggleterm"
      "asyncrun.toggleterm2"
    ];
  };
}
```

In rare cases, we might not want to actually test loading lua modules for a plugin. In those cases, we can disable `neovimRequireCheck` with `doCheck = false;`.

This can be manually added through plugin definition overrides in the [overrides.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/overrides.nix).
```nix
{
  vim-test = super.vim-test.overrideAttrs {
    # Vim plugin with a test lua file
    doCheck = false;
  };
}
```
