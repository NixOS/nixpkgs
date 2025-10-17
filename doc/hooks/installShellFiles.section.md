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

  # Sometimes the file has an undesirable name. It should be renamed before
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

  # Sometimes the manpage file has an undersirable name; e.g., it conflicts with
  # another software with an equal name. To install it with a different name,
  # the installed name must be provided before the path to the file.
  #
  # Below install a manpage "foobar.1" from the source file "./foobar.1", and
  # also installs the manpage "fromsea.3" from the source file "./delmar.3".
  postInstall = ''
    installManPage \
        foobar.1 \
        --name fromsea.3 delmar.3
  '';
}
```

The manpage may be the result of a piped input (e.g. `<(cmd)`), in which
case the name must be provided before the pipe with the `--name` flag.

```nix
{
  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage --name foobar.1 <($out/bin/foobar --manpage)
  '';
}
```

If no parsing of arguments is desired, pass `--` to opt-out of all subsequent
arguments.

```nix
{
  nativeBuildInputs = [ installShellFiles ];

  # Installs a manpage from a file called "--name"
  postInstall = ''
    installManPage -- --name
  '';
}
```

## `installShellCompletion` {#installshellfiles-installshellcompletion}

The `installShellCompletion` function takes one or more paths to shell
completion files.

By default it will autodetect the shell type from the completion file extension,
but you may also specify it by passing one of `--bash`, `--fish`, `--zsh`, or
`--nushell`. These flags apply to all paths listed after them (up until another
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
    installShellCompletion --nushell --name foobar share/completions.nu
    installShellCompletion --zsh --name _foobar share/completions.zsh
    # implicit behavior
    installShellCompletion share/completions/foobar.{bash,fish,zsh,nu}
  '';
}
```

The path may also be the result of process substitution (e.g. `<(cmd)`), in which
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
    # using process substitution
    installShellCompletion --cmd foobar \
      --bash <($out/bin/foobar --bash-completion) \
      --fish <($out/bin/foobar --fish-completion) \
      --nushell <($out/bin/foobar --nushell-completion) \
      --zsh <($out/bin/foobar --zsh-completion)
  '';
}
```
