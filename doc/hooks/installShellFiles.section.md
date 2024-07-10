# `installShellFiles` {#installshellfiles}

This hook helps with installing manpages and shell completion files. It exposes 2 shell functions `installManPage` and `installShellCompletion` that can be used from your `postInstall` hook.

The `installManPage` function takes one or more paths to manpages to install. The manpages must have a section suffix, and may optionally be compressed (with `.gz` suffix). This function will place them into the correct `share/man/man<section>/` directory, in [`outputMan`](#outputman).

The `installShellCompletion` function takes one or more paths to shell completion files. By default it will autodetect the shell type from the completion file extension, but you may also specify it by passing one of `--bash`, `--fish`, or `--zsh`. These flags apply to all paths listed after them (up until another shell flag is given). Each path may also have a custom installation name provided by providing a flag `--name NAME` before the path. If this flag is not provided, zsh completions will be renamed automatically such that `foobar.zsh` becomes `_foobar`. A root name may be provided for all paths using the flag `--cmd NAME`; this synthesizes the appropriate name depending on the shell (e.g. `--cmd foo` will synthesize the name `foo.bash` for bash and `_foo` for zsh). The path may also be a fifo or named fd (such as produced by `<(cmd)`), in which case the shell and name must be provided.

```nix
{
  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installManPage doc/foobar.1 doc/barfoo.3
    # explicit behavior
    installShellCompletion --bash --name foobar.bash share/completions.bash
    installShellCompletion --fish --name foobar.fish share/completions.fish
    installShellCompletion --zsh --name _foobar share/completions.zsh
    # implicit behavior
    installShellCompletion share/completions/foobar.{bash,fish,zsh}
  '';
}
```

When generating completions requires the execution of programs,
it's necessary to disable this process during cross-compilation.
This is because the current build platform may not be able to run binaries of the host platform.

```nix
{
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Utilizing named file descriptor
    installShellCompletion --cmd foobar \
      --bash <($out/bin/foobar --bash-completion) \
      --fish <($out/bin/foobar --fish-completion) \
      --zsh <($out/bin/foobar --zsh-completion)
  '';
}
```

An alternative to disabling this postInstall step, is to use the emulator package if available:
The emulator expects a binary executable as an argument,
so you may have to prefix the script interpreter executable or
run the unwrapped version of the program in case the program is wrapped with a shell wrapper.

```
{
  preFixup = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
    installShellCompletion --cmd rg \
      --bash <(${stdenv.hostPlatform.emulator buildPackages} $out/bin/rg --generate complete-bash) \
      --fish <(${stdenv.hostPlatform.emulator buildPackages} $out/bin/rg --generate complete-fish) \
      --zsh <(${stdenv.hostPlatform.emulator buildPackages} $out/bin/rg --generate complete-zsh)
  '';
}
```
