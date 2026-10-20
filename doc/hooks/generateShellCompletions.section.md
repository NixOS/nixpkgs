# `generateShellCompletions` {#generateshellcompletions}

Generate shell completion scripts by running a program from the package.

## Install completions that are printed by a program {#generateshellcompletions-usage}

:::{.example #ex-generateshellcompletions-usage}

# Install the completions printed by `gok completion <shell>`

```nix
{
  nativeBuildInputs = [ generateShellCompletions ];

  postInstall = ''
    generateShellCompletions -- completion {shell}
  '';

  meta.mainProgram = "gok";
}
```

:::

This runs `gok completion bash`, `gok completion fish` and `gok completion zsh`.
It installs each output as the completion script for that shell with [`installShellCompletion`](#installshellfiles-installshellcompletion).

It is not necessary to use `stdenv.buildPlatform.canExecute stdenv.hostPlatform` to check if the program can be run.
If the build platform cannot run the specified program, the hook only checks its arguments.

## Pass the shell in an environment variable {#generateshellcompletions-env}

:::{.example #ex-generateshellcompletions-env}

# Install the completions printed by `COMPLETE=<shell> tms`

```nix
{
  nativeBuildInputs = [ generateShellCompletions ];

  postInstall = ''
    generateShellCompletions --env COMPLETE={shell}
  '';

  meta.mainProgram = "tms";
}
```

:::

Programs that use clap's dynamic completions read `COMPLETE`.
For programs that use click, such as `khal`, pass `--env _KHAL_COMPLETE={shell}_source` instead.

## Reference {#generateshellcompletions-reference}

### `generateShellCompletions` {#generateshellcompletions-function}

```
generateShellCompletions [--program <path>] [--cmd <name>] [--shells <list>] [--env <name>=<value>]... [--] [<arg>...]
```

This hook runs the specified program once for each shell, and installs what it prints on standard output as the completion script for that shell.
Every `{shell}` in the arguments and in the `--env` values is replaced with the name of the shell.

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
    Can be given more than once.

Add the hook to `nativeBuildInputs`.
The build fails if it is in any other dependency list.
The hook propagates [`installShellFiles`](#installshellfiles).

The build also fails if the program exits with a non-zero status or prints nothing, if the program or the command does not exist, if an option is unknown, or if more than one shell is requested and no argument contains `{shell}`.
