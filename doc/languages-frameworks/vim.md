---
title: User's Guide for Vim in Nixpkgs
author: Marc Weber
date: 2016-06-25
---
# User's Guide to Vim Plugins/Addons/Bundles/Scripts in Nixpkgs

You'll get a vim(-your-suffix) in PATH also loading the plugins you want.
Loading can be deferred; see examples.

Vim packages, VAM (=vim-addon-manager) and Pathogen are supported to load
packages.

## Custom configuration

Adding custom .vimrc lines can be done using the following code:

```
vim_configurable.customize {
  name = "vim-with-plugins";

  vimrcConfig.customRC = ''
    set hidden
  '';
}
```

## Vim packages

To store you plugins in Vim packages the following example can be used:

```
vim_configurable.customize {
  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    # loaded on launch
    start = [ youcompleteme fugitive ];
    # manually loadable by calling `:packadd $plugin-name`
    opt = [ phpCompletion elm-vim ];
    # To automatically load a plugin when opening a filetype, add vimrc lines like:
    # autocmd FileType php :packadd phpCompletion
  }
};
```

## VAM

### dependencies by Vim plugins

VAM introduced .json files supporting dependencies without versioning
assuming that "using latest version" is ok most of the time.

### Example

First create a vim-scripts file having one plugin name per line. Example:

    "tlib"
    {'name': 'vim-addon-sql'}
    {'filetype_regex': '\%(vim)$', 'names': ['reload', 'vim-dev-plugin']}

Such vim-scripts file can be read by VAM as well like this:

    call vam#Scripts(expand('~/.vim-scripts'), {})

Create a default.nix file:

    { nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7102" }:
    nixpkgs.vim_configurable.customize { name = "vim"; vimrcConfig.vam.pluginDictionaries = [ "vim-addon-vim2nix" ]; }

Create a generate.vim file:

    ActivateAddons vim-addon-vim2nix
    let vim_scripts = "vim-scripts"
    call nix#ExportPluginsForNix({
    \  'path_to_nixpkgs': eval('{"'.substitute(substitute(substitute($NIX_PATH, ':', ',', 'g'), '=',':', 'g'), '\([:,]\)', '"\1"',"g").'"}')["nixpkgs"],
    \  'cache_file': '/tmp/vim2nix-cache',
    \  'try_catch': 0,
    \  'plugin_dictionaries': ["vim-addon-manager"]+map(readfile(vim_scripts), 'eval(v:val)')
    \ })

Then run

    nix-shell -p vimUtils.vim_with_vim2nix --command "vim -c 'source generate.vim'"

You should get a Vim buffer with the nix derivations (output1) and vam.pluginDictionaries (output2).
You can add your vim to your system's configuration file like this and start it by "vim-my":

    my-vim =
     let plugins = let inherit (vimUtils) buildVimPluginFrom2Nix; in {
          copy paste output1 here
     }; in vim_configurable.customize {
       name = "vim-my";

       vimrcConfig.vam.knownPlugins = plugins; # optional
       vimrcConfig.vam.pluginDictionaries = [
          copy paste output2 here
       ];

       # Pathogen would be
       # vimrcConfig.pathogen.knownPlugins = plugins; # plugins
       # vimrcConfig.pathogen.pluginNames = ["tlib"];
     };


Sample output1:

    "reload" = buildVimPluginFrom2Nix { # created by nix#NixDerivation
      name = "reload";
      src = fetchgit {
        url = "git://github.com/xolox/vim-reload";
        rev = "0a601a668727f5b675cb1ddc19f6861f3f7ab9e1";
        sha256 = "0vb832l9yxj919f5hfg6qj6bn9ni57gnjd3bj7zpq7d4iv2s4wdh";
      };
      dependencies = ["nim-misc"];

    };
    [...]

Sample output2:

    [
      ''vim-addon-manager''
      ''tlib''
      { "name" = ''vim-addon-sql''; }
      { "filetype_regex" = ''\%(vim)$$''; "names" = [ ''reload'' ''vim-dev-plugin'' ]; }
    ]


## Important repositories

- [vim-pi](https://bitbucket.org/vimcommunity/vim-pi) is a plugin repository
  from VAM plugin manager meant to be used by others as well used by

- [vim2nix](http://github.com/MarcWeber/vim-addon-vim2nix) which generates the
  .nix code

