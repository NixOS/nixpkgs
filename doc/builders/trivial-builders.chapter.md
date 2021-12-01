# Trivial builders {#chap-trivial-builders}

Nixpkgs provides a couple of functions that help with building derivations. The most important one, `stdenv.mkDerivation`, has already been documented above. The following functions wrap `stdenv.mkDerivation`, making it easier to use in certain cases.

## `runCommand` {#trivial-builder-runCommand}

This takes three arguments, `name`, `env`, and `buildCommand`. `name` is just the name that Nix will append to the store path in the same way that `stdenv.mkDerivation` uses its `name` attribute. `env` is an attribute set specifying environment variables that will be set for this derivation. These attributes are then passed to the wrapped `stdenv.mkDerivation`. `buildCommand` specifies the commands that will be run to create this derivation. Note that you will need to create `$out` for Nix to register the command as successful.

An example of using `runCommand` is provided below.

```nix
(import <nixpkgs> {}).runCommand "my-example" {} ''
  echo My example command is running

  mkdir $out

  echo I can write data to the Nix store > $out/message

  echo I can also run basic commands like:

  echo ls
  ls

  echo whoami
  whoami

  echo date
  date
''
```

## `runCommandCC` {#trivial-builder-runCommandCC}

This works just like `runCommand`. The only difference is that it also provides a C compiler in `buildCommand`'s environment. To minimize your dependencies, you should only use this if you are sure you will need a C compiler as part of running your command.

## `runCommandLocal` {#trivial-builder-runCommandLocal}

Variant of `runCommand` that forces the derivation to be built locally, it is not substituted. This is intended for very cheap commands (<1s execution time). It saves on the network roundrip and can speed up a build.

::: {.note}
This sets [`allowSubstitutes` to `false`](https://nixos.org/nix/manual/#adv-attr-allowSubstitutes), so only use `runCommandLocal` if you are certain the user will always have a builder for the `system` of the derivation. This should be true for most trivial use cases (e.g. just copying some files to a different location or adding symlinks), because there the `system` is usually the same as `builtins.currentSystem`.
:::

## `writeTextFile`, `writeText`, `writeTextDir`, `writeScript`, `writeScriptBin` {#trivial-builder-writeText}

These functions write `text` to the Nix store. This is useful for creating scripts from Nix expressions. `writeTextFile` takes an attribute set and expects two arguments, `name` and `text`. `name` corresponds to the name used in the Nix store path. `text` will be the contents of the file. You can also set `executable` to true to make this file have the executable bit set.

Many more commands wrap `writeTextFile` including `writeText`, `writeTextDir`, `writeScript`, and `writeScriptBin`. These are convenience functions over `writeTextFile`.

## `writeShellApplication` {#trivial-builder-writeShellApplication}

This can be used to easily produce a shell script that has some dependencies (`runtimeInputs`). It automatically sets the `PATH` of the script to contain all of the listed inputs, sets some sanity shellopts (`errexit`, `nounset`, `pipefail`), and checks the resulting script with [`shellcheck`](https://github.com/koalaman/shellcheck).

For example, look at the following code:

```nix
writeShellApplication {
  name = "show-nixos-org";

  runtimeInputs = [ curl w3m ];

  text = ''
    curl -s 'https://nixos.org' | w3m -dump -T text/html
  '';
}
```

Unlike with normal `writeShellScriptBin`, there is no need to manually write out `${curl}/bin/curl`, setting the PATH
was handled by `writeShellApplication`. Moreover, the script is being checked with `shellcheck` for more strict
validation.

## `symlinkJoin` {#trivial-builder-symlinkJoin}

This can be used to put many derivations into the same directory structure. It works by creating a new derivation and adding symlinks to each of the paths listed. It expects two arguments, `name`, and `paths`. `name` is the name used in the Nix store path for the created derivation. `paths` is a list of paths that will be symlinked. These paths can be to Nix store derivations or any other subdirectory contained within.

## `writeReferencesToFile` {#trivial-builder-writeReferencesToFile}

Writes the closure of transitive dependencies to a file.

This produces the equivalent of `nix-store -q --requisites`.

For example,

```nix
writeReferencesToFile (writeScriptBin "hi" ''${hello}/bin/hello'')
```

produces an output path `/nix/store/<hash>-runtime-deps` containing

```nix
/nix/store/<hash>-hello-2.10
/nix/store/<hash>-hi
/nix/store/<hash>-libidn2-2.3.0
/nix/store/<hash>-libunistring-0.9.10
/nix/store/<hash>-glibc-2.32-40
```

You can see that this includes `hi`, the original input path,
`hello`, which is a direct reference, but also
the other paths that are indirectly required to run `hello`.

## `writeDirectReferencesToFile` {#trivial-builder-writeDirectReferencesToFile}

Writes the set of references to the output file, that is, their immediate dependencies.

This produces the equivalent of `nix-store -q --references`.

For example,

```nix
writeDirectReferencesToFile (writeScriptBin "hi" ''${hello}/bin/hello'')
```

produces an output path `/nix/store/<hash>-runtime-references` containing

```nix
/nix/store/<hash>-hello-2.10
```

but none of `hello`'s dependencies, because those are not referenced directly
by `hi`'s output.
