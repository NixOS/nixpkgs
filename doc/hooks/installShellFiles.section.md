# `installShellFiles` {#installshellfiles}

This hook adds helpers that install artifacts like executable files, manpages
and shell completions.

It exposes the following functions that can be used from your `postInstall`
hook:

## `installBin` {#installshellfiles-installbin}

The `installBin` function takes one or more paths to files to install as
executable files.

This function will place them into [`outputBin`](#outputbin).

### Example Usage {#installshellfiles-installbin-exampleusage}

```nix
{
  nativeBuildInputs = [ installShellFiles ];

  # Sometimes the file has an undersirable name. It should be renamed before
  # being installed via installBin
  postInstall = ''
    mv a.out delmar
    installBin foobar delmar
  '';
}
```

## `installManPage` {#installshellfiles-installmanpage}

The `installManPage` function takes one or more paths to manpages to install.

The manpages must have a section suffix, and may optionally be compressed (with
`.gz` suffix). This function will place them into the correct
`share/man/man<section>/` directory in [`outputMan`](#outputman).

### Example Usage {#installshellfiles-installmanpage-exampleusage}

```nix
{
  nativeBuildInputs = [ installShellFiles ];

  # Sometimes the manpage file has an undersirable name; e.g. it conflicts with
  # another software with an equal name. It should be renamed before being
  # installed via installManPage
  postInstall = ''
    mv fromsea.3 delmar.3
    installManPage foobar.1 delmar.3
  '';
}
```

## `installShellCompletion` {#installshellfiles-installshellcompletion}

The `installShellCompletion` function takes one or more paths to shell
completion files.

By default it will autodetect the shell type from the completion file extension,
but you may also specify it by passing one of `--bash`, `--fish`, or
`--zsh`. These flags apply to all paths listed after them (up until another
shell flag is given). Each path may also have a custom installation name
provided by providing a flag `--name NAME` before the path. If this flag is not
provided, zsh completions will be renamed automatically such that `foobar.zsh`
becomes `_foobar`. A root name may be provided for all paths using the flag
`--cmd NAME`; this synthesizes the appropriate name depending on the shell
(e.g. `--cmd foo` will synthesize the name `foo.bash` for bash and `_foo` for
zsh).

### Example Usage {#installshellfiles-installshellcompletion-exampleusage}

```nix
{
  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    # explicit behavior
    installShellCompletion --bash --name foobar.bash share/completions.bash
    installShellCompletion --fish --name foobar.fish share/completions.fish
    installShellCompletion --zsh --name _foobar share/completions.zsh
    # implicit behavior
    installShellCompletion share/completions/foobar.{bash,fish,zsh}
  '';
}
```

The path may also be a fifo or named fd (such as produced by `<(cmd)`), in which
case the shell and name must be provided (see below).

If the destination shell completion file is not actually present or consists of
zero bytes after calling `installShellCompletion` this is treated as a build
failure. In particular, if completion files are not vendored but are generated
by running an executable, this is likely to fail in cross compilation
scenarios. The result will be a zero byte completion file and hence a build
failure. To prevent this, guard the completion generation commands.

### Example Usage {#installshellfiles-installshellcompletion-exampleusage-guarded}

```nix
{
  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # using named fd
    installShellCompletion --cmd foobar \
      --bash <($out/bin/foobar --bash-completion) \
      --fish <($out/bin/foobar --fish-completion) \
      --zsh <($out/bin/foobar --zsh-completion)
  '';
}
```
