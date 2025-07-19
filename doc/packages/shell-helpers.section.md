# Interactive shell helpers {#sec-shell-helpers}

Some packages contain shell integration files, but unlike other systems Nix doesn't have a standard `share` directory location.
There are several approaches for dealing with this depending on the package and the user's setup.

## Sourcing with `-share` scripts {#sec-shell-helpers-share-scripts}

Some packages ship `-share` scripts that print the location of the corresponding shared folder, including:

- `blesh` : {command}`blesh-share`
- `fzf` : {command}`fzf-share`
- `gitstatus` : {command}`gitstatus-share`
- `skim` : {command}`sk-share`
- `zsh-autoenv` : {command}`zsh-autoenv-share`

E.g. {command}`fzf` can then be used like this:

```bash
# ~/.bashrc
source "$(fzf-share)/completion.bash";
source "$(fzf-share)/key-bindings.bash";
```

## Sourcing with parameter expansion {#sec-shell-helpers-sourcing-expansion}

When a `-share` script isn't packaged, Nix can expand paramaters in the format `${pkgs.pname}` using the `pkgs` attribute:

```nix
# NixOS configuration
programs.bash.interactiveShellInit = ''
  source "${pkgs.fzf}/share/fzf/completion.bash";
  source "${pkgs.fzf}/share/fzf/key-bindings.bash";
'';
```

This will ensure the package is added to your store even if it's not installed to your environment.

## Sourcing with {command}`nix-eval` {#sec-shell-helpers-sourcing-nix-eval}

If you aren't using Nix for configuration or otherwise need to reference a share directory from outside it, you can also evaluate at runtime:

```bash
# ~/.bashrc
source "$(nix eval --raw --read-only nixpkgs#fzf.outPath)/share/fzf/completion.bash";
source "$(nix eval --raw --read-only nixpkgs#fzf.outPath)/share/fzf/key-bindings.bash";
```

::: {.warning}
{command}`nix eval` returns the path where a derivation would go under Nix's latest configuration, not necessarily where one is currently present.
If there's a mismatch between your booted system and the latest configuration (for example before you run {command}`sudo nixos-rebuild switch`) it may return a directory that doesn't exist.

Additionally, {command}`nix-eval` takes hundreds of milliseconds to complete.

[Sourcing with variables](#sec-shell-helpers-sourcing-variables) should be preferred for these reasons.
:::

## Sourcing with share path variables {#sec-shell-helpers-sourcing-variables}

Another option is to take advantage of parameter expansion to create an environment variable:

```nix
# NixOS configuration
environment.variables.FZF_SHARE_PATH = "${pkgs.fzf}/share/fzf";
```

As mentioned in [sourcing with parameter expansion](#sec-shell-helpers-sourcing-expansion), this will ensure the package is added to the store.
If you don't use Nix for configuration, you can at least limit the time spent on {command}`nix eval` by running it at login:

```bash
# ~/.bash_profile
FZF_SHARE_PATH = "$(nix eval --raw --read-only nixpkgs#fzf.outPath)/share/fzf";
export FZF_SHARE_PATH;
```

Running {command}`nix eval` at login also means the value will remain the same for the length of your session.
The environment variable can then be sourced from an unmanaged {file}`~/.bashrc`:

```bash
# ~/.bashrc
source "${FZF_SHARE_PATH}/completion.bash";
source "${FZF_SHARE_PATH}/key-bindings.bash";
```
