# `generateShellCompletions` {#generateshellcompletions}

Generate shell completion scripts by running a program from the package.

## Install completions that are printed by a program {#generateshellcompletions-usage}

:::{.example #ex-generateshellcompletions-usage}

# Install the completions printed by `gok completion <shell>`

```nix
{
  nativeBuildInputs = [ generateShellCompletions ];

  generateShellCompletionsArgs = [
    "completion"
    "{shell}"
  ];

  meta.mainProgram = "gok";
}
```

:::

After `postInstall`, this runs `gok completion bash`, `gok completion fish` and `gok completion zsh`.
It installs each output as the completion script for that shell with [`installShellCompletion`](#installshellfiles-installshellcompletion).

It is not necessary to use `stdenv.buildPlatform.canExecute stdenv.hostPlatform` to check if the program can be run.
If the build platform cannot execute programs built for the host platform, the hook only checks its arguments and installs no completions.

## Pass the shell in an environment variable {#generateshellcompletions-env}

:::{.example #ex-generateshellcompletions-env}

# Install the completions printed by `COMPLETE=<shell> tms`

```nix
{
  nativeBuildInputs = [ generateShellCompletions ];

  generateShellCompletionsEnv = [ "COMPLETE={shell}" ];

  meta.mainProgram = "tms";
}
```

:::

Programs that use clap's dynamic completions read `COMPLETE`.
For programs that use click, such as `khal`, set `generateShellCompletionsEnv = [ "_KHAL_COMPLETE={shell}_source" ];` instead.

## Install completions for several programs {#generateshellcompletions-programs}

:::{.example #ex-generateshellcompletions-programs}

# Install the completions of `easytier-cli` and `easytier-core`

```nix
{
  nativeBuildInputs = [ generateShellCompletions ];

  postInstall = ''
    generateShellCompletions --program easytier-cli -- gen-autocomplete {shell}
    generateShellCompletions --program easytier-core -- --gen-autocomplete {shell}
  '';
}
```

:::

When the attributes cannot describe the completions, leave them unset and call the [`generateShellCompletions`](#generateshellcompletions-function) function instead.

With the attributes, the hook runs the program before `fixupPhase`.
If the program only works after it is wrapped or patched during `fixupPhase`, call the function from `postFixup`.
The same applies to programs installed in `sbin`, which `fixupPhase` moves to `bin`.
Some hooks, such as [`autoPatchelfHook`](#setup-hook-autopatchelfhook), patch the programs only after `postFixup`.
For such a package, patch the programs before the hook runs them, for example with `autoPatchelf -- "$out"` in `postInstall`.

## Reference {#generateshellcompletions-reference}

Add the hook to `nativeBuildInputs`.
The build fails if it is in a dependency list for another platform, such as `buildInputs`.
The hook propagates [`installShellFiles`](#installshellfiles).

### Attributes {#generateshellcompletions-attributes}

After `postInstall`, the hook calls the [`generateShellCompletions`](#generateshellcompletions-function) function with these attributes, if `generateShellCompletionsArgs` or `generateShellCompletionsEnv` is set.
Set the attributes or call the function, not both.
For a program that takes no arguments and reads no environment variables, call the function.

`generateShellCompletionsArgs`
:   List of arguments for the program.
    See [](#ex-generateshellcompletions-usage).

`generateShellCompletionsEnv`
:   List of environment variables for the program, as `<name>=<value>`.
    See [](#ex-generateshellcompletions-env).

`generateShellCompletionsProgram`
:   Program to run, as for `--program`.
    For a path in the package, use `placeholder` with the name of the output, such as `placeholder "out"`.

`generateShellCompletionsCmd`
:   Command the completions are for, as for `--cmd`.

`generateShellCompletionsShells`
:   List of shells, as for `--shells`.

`dontGenerateShellCompletions`
:   Do not call the function after `postInstall`, do not fail the build when the function never runs, and allow calls of the function when other attributes are set.

The hook does not expand shell variables such as `$out` or `$TMPDIR` in the values of these attributes.
Without [`__structuredAttrs`](#var-stdenv-__structuredAttrs), the items of these lists cannot be empty or contain whitespace.

### `generateShellCompletions` {#generateshellcompletions-function}

```
generateShellCompletions [--program <path>] [--cmd <name>] [--shells <list>] [--env <name>=<value>]... [--] [<arg>...]
```

This hook runs the specified program once for each shell, and installs what it prints on standard output as the completion script for that shell.
The hook replaces every `{shell}` in the arguments and in the `--env` values with the name of the shell.

`--program <path>`
:   Program to run, as a path or as a name in the `bin` directory of [`$outputBin`](#outputbin).
    Defaults to [`meta.mainProgram`](#var-meta-mainProgram).

`--cmd <name>`
:   Command the completions are for.
    Bash and fish load completions by command name, so it must name an executable in the `bin` directory of `$outputBin`.
    Defaults to the name of the program.

`--shells <list>`
:   Space-separated list of shells, from `bash`, `fish`, `nushell` and `zsh`.
    Defaults to `bash fish zsh`.

`--env <name>=<value>`
:   Environment variable to set for the program.
    Repeat the option to set more than one variable.

The build fails if the program exits with a non-zero status or prints nothing, if it prints the same script for fish or nushell as for another shell, if the program or the command does not exist, if an option is unknown or malformed, if a shell is not supported or listed twice, or if more than one shell is requested and neither the arguments nor the `--env` values contain `{shell}`.
Unless `dontGenerateShellCompletions` is set, it also fails if any of the other attributes is set and the function is called as well, or if the hook is added but the function never runs.
The check that the function ran happens at the end of `fixupPhase`, so it is skipped when `fixupPhase` does not run, such as when `dontFixup` is set or the derivation uses `buildCommand`.

See [](#ex-generateshellcompletions-programs).
