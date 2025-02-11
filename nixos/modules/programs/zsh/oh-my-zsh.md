# Oh my ZSH {#module-programs-zsh-ohmyzsh}

[`oh-my-zsh`](https://ohmyz.sh/) is a framework to manage your [ZSH](https://www.zsh.org/)
configuration including completion scripts for several CLI tools or custom
prompt themes.

## Basic usage {#module-programs-oh-my-zsh-usage}

The module uses the `oh-my-zsh` package with all available
features. The initial setup using Nix expressions is fairly similar to the
configuration format of `oh-my-zsh`.
```nix
{
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" ];
    theme = "agnoster";
  };
}
```
For a detailed explanation of these arguments please refer to the
[`oh-my-zsh` docs](https://github.com/robbyrussell/oh-my-zsh/wiki).

The expression generates the needed configuration and writes it into your
`/etc/zshrc`.

## Custom additions {#module-programs-oh-my-zsh-additions}

Sometimes third-party or custom scripts such as a modified theme may be
needed. `oh-my-zsh` provides the
[`ZSH_CUSTOM`](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-internals)
environment variable for this which points to a directory with additional
scripts.

The module can do this as well:
```nix
{
  programs.zsh.ohMyZsh.custom = "~/path/to/custom/scripts";
}
```

## Custom environments {#module-programs-oh-my-zsh-environments}

There are several extensions for `oh-my-zsh` packaged in
`nixpkgs`. One of them is
[nix-zsh-completions](https://github.com/spwhitt/nix-zsh-completions)
which bundles completion scripts and a plugin for `oh-my-zsh`.

Rather than using a single mutable path for `ZSH_CUSTOM`,
it's also possible to generate this path from a list of Nix packages:
```nix
{ pkgs, ... }:
{
  programs.zsh.ohMyZsh.customPkgs = [
    pkgs.nix-zsh-completions
    # and even more...
  ];
}
```
Internally a single store path will be created using
`buildEnv`. Please refer to the docs of
[`buildEnv`](https://nixos.org/nixpkgs/manual/#sec-building-environment)
for further reference.

*Please keep in mind that this is not compatible with
`programs.zsh.ohMyZsh.custom` as it requires an immutable
store path while `custom` shall remain mutable! An
evaluation failure will be thrown if both `custom` and
`customPkgs` are set.*

## Package your own customizations {#module-programs-oh-my-zsh-packaging-customizations}

If third-party customizations (e.g. new themes) are supposed to be added to
`oh-my-zsh` there are several pitfalls to keep in mind:

  - To comply with the default structure of `ZSH` the entire
    output needs to be written to `$out/share/zsh.`

  - Completion scripts are supposed to be stored at
    `$out/share/zsh/site-functions`. This directory is part of the
    [`fpath`](https://zsh.sourceforge.io/Doc/Release/Functions.html)
    and the package should be compatible with pure `ZSH`
    setups. The module will automatically link the contents of
    `site-functions` to completions directory in the proper
    store path.

  - The `plugins` directory needs the structure
    `pluginname/pluginname.plugin.zsh` as structured in the
    [upstream repo.](https://github.com/robbyrussell/oh-my-zsh/tree/91b771914bc7c43dd7c7a43b586c5de2c225ceb7/plugins)

A derivation for `oh-my-zsh` may look like this:
```nix
{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "exemplary-zsh-customization-${version}";
  version = "1.0.0";
  src = fetchFromGitHub {
    # path to the upstream repository
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/zsh/site-functions
    cp {themes,plugins} $out/share/zsh
    cp completions $out/share/zsh/site-functions
  '';
}
```
