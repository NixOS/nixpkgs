
# `patchRcPath` hooks {#sec-patchRcPathHooks}

These hooks provide shell-specific utilities (with the same name as the hook) to patch shell scripts meant to be sourced by software users.

The typical usage is to patch initialisation or [rc](https://unix.stackexchange.com/questions/3467/what-does-rc-in-bashrc-stand-for) scripts inside `$out/bin` or `$out/etc`.
Such scripts, when being sourced, would insert the binary locations of certain commands into `PATH`, modify other environment variables or run a series of start-up commands.
When shipped from the upstream, they sometimes use commands that might not be available in the environment they are getting sourced in.

The compatible shells for each hook are:

 - `patchRcPathBash`: [Bash](https://www.gnu.org/software/bash/), [ksh](http://www.kornshell.org/), [zsh](https://www.zsh.org/) and other shells supporting the Bash-like parameter expansions.
 - `patchRcPathCsh`: Csh scripts, such as those targeting [tcsh](https://www.tcsh.org/).
 - `patchRcPathFish`: [Fish](https://fishshell.com/) scripts.
 - `patchRcPathPosix`: POSIX-conformant shells supporting the limited parameter expansions specified by the POSIX standard. Current implementation uses the parameter expansion `${foo-}` only.

For each supported shell, it modifies the script with a `PATH` prefix that is later removed when the script ends.
It allows nested patching, which guarantees that a patched script may source another patched script.

Syntax to apply the utility to a script:

```sh
patchRcPath<shell> <file> <PATH-prefix>
```

Example usage:

Given a package `foo` containing an init script `this-foo.fish` that depends on `coreutils`, `man` and `which`,
patch the init script for users to source without having the above dependencies in their `PATH`:

```nix
{ lib, stdenv, patchRcPathFish}:
stdenv.mkDerivation {

  # ...

  nativeBuildInputs = [
    patchRcPathFish
  ];

  postFixup = ''
    patchRcPathFish $out/bin/this-foo.fish ${lib.makeBinPath [ coreutils man which ]}
  '';
}
```

::: {.note}
`patchRcPathCsh` and `patchRcPathPosix` implementation depends on `sed` to do the string processing.
The others are in vanilla shell and have no third-party dependencies.
:::
