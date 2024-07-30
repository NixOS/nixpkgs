# Vim {#vim}

Both Neovim and Vim can be configured to include your favorite plugins
and additional libraries.

Loading can be deferred; see examples.

At the moment we support two different methods for managing plugins:

- Vim packages (*recommended*)
- vim-plug (vim only)

Right now two Vim packages are available: `vim` which has most features that require extra
dependencies disabled and `vim-full` which has them configurable and enabled by default.

::: {.note}
`vim_configurable` is a deprecated alias for `vim-full` and refers to the fact that its
build-time features are configurable. It has nothing to do with user configuration,
and both the `vim` and `vim-full` packages can be customized as explained in the next section.
:::

## Custom configuration {#custom-configuration}

Adding custom .vimrc lines can be done using the following code:

```nix
vim-full.customize {
  # `name` optionally specifies the name of the executable and package
  name = "vim-with-plugins";

  vimrcConfig.customRC = ''
    set hidden
  '';
}
```

This configuration is used when Vim is invoked with the command specified as name, in this case `vim-with-plugins`.
You can also omit `name` to customize Vim itself. See the
[definition of `vimUtils.makeCustomizable`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/vim-utils.nix#L408)
for all supported options.

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

## Managing plugins with Vim packages {#managing-plugins-with-vim-packages}

To store your plugins in Vim packages (the native Vim plugin manager, see `:help packages`) the following example can be used:

```nix
vim-full.customize {
  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    # loaded on launch
    start = [ youcompleteme fugitive ];
    # manually loadable by calling `:packadd $plugin-name`
    # however, if a Vim plugin has a dependency that is not explicitly listed in
    # opt that dependency will always be added to start to avoid confusion.
    opt = [ phpCompletion elm-vim ];
    # To automatically load a plugin when opening a filetype, add vimrc lines like:
    # autocmd FileType php :packadd phpCompletion
  };
}
```

`myVimPackage` is an arbitrary name for the generated package. You can choose any name you like.
For Neovim the syntax is:

```nix
neovim.override {
  configure = {
    customRC = ''
      # here your custom configuration goes!
    '';
    packages.myVimPackage = with pkgs.vimPlugins; {
      # see examples below how to use custom packages
      start = [ ];
      # If a Vim plugin has a dependency that is not explicitly listed in
      # opt that dependency will always be added to start to avoid confusion.
      opt = [ ];
    };
  };
}
```

The resulting package can be added to `packageOverrides` in `~/.nixpkgs/config.nix` to make it installable:

```nix
{
  packageOverrides = pkgs: with pkgs; {
    myVim = vim-full.customize {
      # `name` specifies the name of the executable and package
      name = "vim-with-plugins";
      # add here code from the example section
    };
    myNeovim = neovim.override {
      configure = {
      # add code from the example section here
      };
    };
  };
}
```

After that you can install your special grafted `myVim` or `myNeovim` packages.

### What if your favourite Vim plugin isn’t already packaged? {#what-if-your-favourite-vim-plugin-isnt-already-packaged}

If one of your favourite plugins isn't packaged, you can package it yourself:

```nix
{ config, pkgs, ... }:

let
  easygrep = pkgs.vimUtils.buildVimPlugin {
    name = "vim-easygrep";
    src = pkgs.fetchFromGitHub {
      owner = "dkprice";
      repo = "vim-easygrep";
      rev = "d0c36a77cc63c22648e792796b1815b44164653a";
      hash = "sha256-bL33/S+caNmEYGcMLNCanFZyEYUOUmSsedCVBn4tV3g=";
    };
  };
in
{
  environment.systemPackages = [
    (
      pkgs.neovim.override {
        configure = {
          packages.myPlugins = with pkgs.vimPlugins; {
          start = [
            vim-go # already packaged plugin
            easygrep # custom package
          ];
          opt = [];
        };
        # ...
      };
     }
    )
  ];
}
```

If your package requires building specific parts, use instead `pkgs.vimUtils.buildVimPlugin`.

### Specificities for some plugins {#vim-plugin-specificities}
#### Treesitter {#vim-plugin-treesitter}

By default `nvim-treesitter` encourages you to download, compile and install
the required Treesitter grammars at run time with `:TSInstall`. This works
poorly on NixOS.  Instead, to install the `nvim-treesitter` plugins with a set
of precompiled grammars, you can use `nvim-treesitter.withPlugins` function:

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

## Managing plugins with vim-plug {#managing-plugins-with-vim-plug}

To use [vim-plug](https://github.com/junegunn/vim-plug) to manage your Vim
plugins the following example can be used:

```nix
vim-full.customize {
  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    # loaded on launch
    plug.plugins = [ youcompleteme fugitive phpCompletion elm-vim ];
  };
}
```

Note: this is not possible anymore for Neovim.


## Adding new plugins to nixpkgs {#adding-new-plugins-to-nixpkgs}

Nix expressions for Vim plugins are stored in [pkgs/applications/editors/vim/plugins](https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/editors/vim/plugins). For the vast majority of plugins, Nix expressions are automatically generated by running [`nix-shell -p vimPluginsUpdater --run vim-plugins-updater`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/updater.nix). This creates a [generated.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/generated.nix) file based on the plugins listed in [vim-plugin-names](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/vim-plugin-names).

When the vim updater detects an nvim-treesitter update, it also runs [`nvim-treesitter/update.py $(nix-build -A vimPlugins.nvim-treesitter)`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/update.py) to update the tree sitter grammars for `nvim-treesitter`.

Some plugins require overrides in order to function properly. Overrides are placed in [overrides.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/overrides.nix). Overrides are most often required when a plugin requires some dependencies, or extra steps are required during the build process. For example `deoplete-fish` requires both `deoplete-nvim` and `vim-fish`, and so the following override was added:

```nix
{
  deoplete-fish = super.deoplete-fish.overrideAttrs(old: {
    dependencies = with super; [ deoplete-nvim vim-fish ];
  });
}
```

Sometimes plugins require an override that must be changed when the plugin is updated. This can cause issues when Vim plugins are auto-updated but the associated override isn't updated. For these plugins, the override should be written so that it specifies all information required to install the plugin, and running `nix-shell -p vimPluginsUpdater --run vim-plugins-updater` doesn't change the derivation for the plugin. Manually updating the override is required to update these types of plugins. An example of such a plugin is `LanguageClient-neovim`.

To add a new plugin, run `nix-shell -p vimPluginsUpdater --run 'vim-plugins-updater add "[owner]/[name]"'`. **NOTE**: This script automatically commits to your git repository. Be sure to check out a fresh branch before running.

Finally, there are some plugins that are also packaged in nodePackages because they have Javascript-related build steps, such as running webpack. Those plugins are not listed in `vim-plugin-names` or managed by `vimPluginsUpdater` at all, and are included separately in `overrides.nix`. Currently, all these plugins are related to the `coc.nvim` ecosystem of the Language Server Protocol integration with Vim/Neovim.

## Updating plugins in nixpkgs {#updating-plugins-in-nixpkgs}

Run the update script with a GitHub API token that has at least `public_repo` access. Running the script without the token is likely to result in rate-limiting (429 errors). For steps on creating an API token, please refer to [GitHub's token documentation](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token).

```sh
nix-shell -p vimPluginsUpdater --run 'vim-plugins-updater --github-token=mytoken' # or set GITHUB_API_TOKEN environment variable
```

Alternatively, set the number of processes to a lower count to avoid rate-limiting.

```sh

nix-shell -p vimPluginsUpdater --run 'vim-plugins-updater --proc 1'
```

## How to maintain an out-of-tree overlay of vim plugins ? {#vim-out-of-tree-overlays}

You can use the updater script to generate basic packages out of a custom vim
plugin list:

```
nix-shell -p vimPluginsUpdater --run vim-plugins-updater -i vim-plugin-names -o generated.nix --no-commit
```

with the contents of `vim-plugin-names` being for example:

```
repo,branch,alias
pwntester/octo.nvim,,
```

You can then reference the generated vim plugins via:

```nix
{
  myVimPlugins = pkgs.vimPlugins.extend (
    (pkgs.callPackage ./generated.nix {})
  );
}
```

