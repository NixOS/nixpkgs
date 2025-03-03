# Vim {#vim}

Vim can be configured to include your favorite plugins and additional
libraries.

Loading can be deferred; see examples.

At the moment we support two different methods for managing plugins:

- Vim packages (*recommended*)
- vim-plug (vim only)

Right now two Vim packages are available: `vim` which has most features that
require extra dependencies disabled and `vim-full` which has them configurable
and enabled by default.

::: {.note}
`vim_configurable` is a deprecated alias for `vim-full` and refers to the fact
that its build-time features are configurable. It has nothing to do with user
configuration, and both the `vim` and `vim-full` packages can be customized as
explained in the next section.
:::

## Custom configuration {#vim-custom-configuration}

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

This configuration is used when Vim is invoked with the command specified as
name, in this case `vim-with-plugins`. You can also omit `name` to customize
Vim itself. See the [definition of
`vimUtils.makeCustomizable`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/vim-utils.nix#L408)
for all supported options.


## Managing plugins with Vim packages {#managing-plugins-with-vim-packages}

To store your plugins in Vim packages (the native Vim plugin manager, see
`:help packages`) the following example can be used:

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


The resulting package can be added to `packageOverrides` in
`~/.nixpkgs/config.nix` to make it installable:

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

If your package requires building specific parts, use instead
`pkgs.vimUtils.buildVimPlugin`.

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

Nix expressions for Vim plugins are stored in
[pkgs/applications/editors/vim/plugins](https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/editors/vim/plugins).
For the vast majority of plugins, Nix expressions are automatically generated
by running [`nix-shell -p vimPluginsUpdater --run
vim-plugins-updater`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/update.py).
This creates
an [`generated.json`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/generated.json)
file based on the plugins listed in
[`vim-plugin-names.csv`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/vim-plugin-names.csv).

If you update nvim-treesitter, don't forget to run
[`nvim-treesitter/update.py $(nix-build -A
vimPlugins.nvim-treesitter)`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/update.py)
to update the grammars for `nvim-treesitter`.

Some plugins require overrides in order to function properly. Overrides are
placed in
[overrides.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/overrides.nix).
Overrides are most often required when a plugin requires some dependencies, or
extra steps are required during the build process. For example `deoplete-fish`
requires both `deoplete-nvim` and `vim-fish`, and so the following override was
added:

```nix
{
  deoplete-fish = super.deoplete-fish.overrideAttrs(old: {
    dependencies = with super; [ deoplete-nvim vim-fish ];
  });
}
```

Sometimes plugins require an override that must be changed when the plugin is
updated. This can cause issues when Vim plugins are auto-updated but the
associated override isn't updated. You should package such plugins manually in
[`non-generated`](https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/editors/vim/plugins/non-generated)
folder.

To add a new plugin, run `nix-shell -p vimPluginsUpdater --run
'vim-plugins-updater add "https://github.com/[owner]/[name]"'`. **NOTE**: The
script only supports plugins from GitHub. If plugin that you want to add is
hosted on another site, you have to package it manually in the
[`non-generated`](https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/editors/vim/plugins/non-generated)
folder. The reason is that we have less than dozen non-GH plugins, and adding
support for them into auto-updater seemed like a lot of effort for nothing.

There are also plugins, that are already packaged in `luaPackages`, you should
instead add them to the bottom of
[`overrides.nix`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/vim/plugins/overrides.nix).
If plugin is packaged on luarocks, packaging it through `luaPackages` should be
preferred.

Finally, there are some plugins that are also packaged in nodePackages because
they have Javascript-related build steps, such as running webpack. Those
plugins are not listed in `vim-plugin-names` or managed by `vimPluginsUpdater`
at all, and are included separately in `overrides.nix`. Currently, all these
plugins are related to the `coc.nvim` ecosystem of the Language Server Protocol
integration with Vim/Neovim.

## Updating plugins in nixpkgs {#updating-plugins-in-nixpkgs}

Run the update script with a GitHub API token that has at least `public_repo`
access. Running the script without the token is likely to result in
rate-limiting (429 errors). For steps on creating an API token, please refer to
[GitHub's token
documentation](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token).

```sh
GITHUB_TOKEN=mytoken nix-shell -p vimPluginsUpdater --run 'vim-plugins-updater'
```

Alternatively, set the number of processes to a lower count to avoid
rate-limiting.

```sh
nix-shell -p vimPluginsUpdater --run 'vim-plugins-updater --jobs 1'
```

If you want to update only certain plugins, you can specify them after the
`update` command. Note that you must use the same plugin names as the
`pkgs/applications/editors/vim/plugins/vim-plugin-names.csv` file.

```sh
nix-shell -p vimPluginsUpdater --run 'vim-plugins-updater update "https://github.com/folke/lazy.nvim"'
```

You can also specify `@` and `as` for controlling branch and alias (the same
syntax works with `add` command too):

```sh
nix-shell -p vimPluginsUpdater --run 'vim-plugins-updater update "https://github.com/folke/lazy.nvim@next as myalias"'
```
