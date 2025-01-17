# Neovim {#neovim}

Install `neovim-unwrapped` to get a barebone neovim to configure imperatively.
Neovim can be configured to include your favorite plugins and additional libraries by installing `neovim` instead.
See the next section for more details.

## Custom configuration {#neovim-custom-configuration}

For Neovim the `configure` argument can be overridden to achieve the same:

```nix
neovim.override {
  configure = {
    customRC = ''
      # here your custom configuration goes!
    '';
  };
}
```

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

### Specificities for some plugins {#neovim-plugin-specificities}
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
`neovimRequireCheck` is a simple test which checks if Neovim can requires lua modules without errors. This is often enough to catch missing dependencies.

It accepts a single string for a module, or a list of module strings to test.
- `nvimRequireCheck = MODULE;`
- `nvimRequireCheck = [ MODULE1 MODULE2 ];`

When `nvimRequireCheck` is not specified, we will search the plugin's directory for lua modules to attempt loading. This quick smoke test can catch obvious dependency errors that might be missed.
The check hook will fail the build if any modules cannot be loaded. This encourages inspecting the logs to identify potential issues.

To only check a specific module, add it manually to the plugin definition [overrides](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/overrides.nix).

```nix
  gitsigns-nvim = super.gitsigns-nvim.overrideAttrs {
    dependencies = [ self.plenary-nvim ];
    nvimRequireCheck = "gitsigns";
  };
```
Some plugins will have lua modules that require a user configuration to function properly or can contain optional lua modules that we dont want to test requiring.
We can skip specific modules using `nvimSkipModule`. Similar to `nvimRequireCheck`, it accepts a single string or a list of strings.
- `nvimSkipModule = MODULE;`
- `nvimSkipModule = [ MODULE1 MODULE2 ];`

```nix
  asyncrun-vim = super.asyncrun-vim.overrideAttrs {
    nvimSkipModule = [
      # vim plugin with optional toggleterm integration
      "asyncrun.toggleterm"
      "asyncrun.toggleterm2"
    ];
  };
```

In rare cases, we might not want to actually test loading lua modules for a plugin. In those cases, we can disable `neovimRequireCheck` with `doCheck = false;`.

This can be manually added through plugin definition overrides in the [overrides.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/overrides.nix).
```nix
  vim-test = super.vim-test.overrideAttrs {
    # Vim plugin with a test lua file
    doCheck = false;
  };
```
