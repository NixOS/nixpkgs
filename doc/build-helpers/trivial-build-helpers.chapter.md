# Trivial build helpers {#chap-trivial-builders}

Nixpkgs provides a variety of wrapper functions that help build commonly useful derivations.
Like [`stdenv.mkDerivation`](#sec-using-stdenv), each of these build helpers creates a derivation, but the arguments passed are different (usually simpler) from those required by `stdenv.mkDerivation`.

## `runCommand` {#trivial-builder-runCommand}

`runCommand :: String -> AttrSet -> String -> Derivation`

`runCommand name drvAttrs buildCommand` returns a derivation that is built by running the specified shell commands.

`name :: String`
:   The name that Nix will append to the store path in the same way that `stdenv.mkDerivation` uses its `name` attribute.

`drvAttr :: AttrSet`
:   Attributes to pass to the underlying call to [`stdenv.mkDerivation`](#chap-stdenv).

`buildCommand :: String`
:   Shell commands to run in the derivation builder.

    ::: {.note}
    You have to create a file or directory `$out` for Nix to be able to run the builder successfully.
    :::

::: {.example #ex-runcommand-simple}
# Invocation of `runCommand`

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
:::

## `runCommandCC` {#trivial-builder-runCommandCC}

This works just like `runCommand`. The only difference is that it also provides a C compiler in `buildCommand`'s environment. To minimize your dependencies, you should only use this if you are sure you will need a C compiler as part of running your command.

## `runCommandLocal` {#trivial-builder-runCommandLocal}

Variant of `runCommand` that forces the derivation to be built locally, it is not substituted. This is intended for very cheap commands (<1s execution time). It saves on the network round-trip and can speed up a build.

::: {.note}
This sets [`allowSubstitutes` to `false`](https://nixos.org/nix/manual/#adv-attr-allowSubstitutes), so only use `runCommandLocal` if you are certain the user will always have a builder for the `system` of the derivation. This should be true for most trivial use cases (e.g., just copying some files to a different location or adding symlinks) because there the `system` is usually the same as `builtins.currentSystem`.
:::

## Writing text files {#trivial-builder-text-writing}

Nixpkgs provides the following functions for producing derivations which write text files or executable scripts into the Nix store.
They are useful for creating files from Nix expression, and are all implemented as convenience wrappers around `writeTextFile`.

Each of these functions will cause a derivation to be produced.
When you coerce the result of each of these functions to a string with [string interpolation](https://nixos.org/manual/nix/stable/language/string-interpolation) or [`builtins.toString`](https://nixos.org/manual/nix/stable/language/builtins#builtins-toString), it will evaluate to the [store path](https://nixos.org/manual/nix/stable/store/store-path) of this derivation.

:::: {.note}
Some of these functions will put the resulting files within a directory inside the [derivation output](https://nixos.org/manual/nix/stable/language/derivations#attr-outputs).
If you need to refer to the resulting files somewhere else in a Nix expression, append their path to the derivation's store path.

For example, if the file destination is a directory:

```nix
my-file = writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
  destination = "/share/my-file";
}
```

Remember to append "/share/my-file" to the resulting store path when using it elsewhere:

```nix
writeShellScript "evaluate-my-file.sh" ''
  cat ${my-file}/share/my-file
'';
```
::::

### `writeTextFile` {#trivial-builder-writeTextFile}

Write a text file to the Nix store.

`writeTextFile` takes an attribute set with the following possible attributes:

`name` (String)

: Corresponds to the name used in the Nix store path identifier.

`text` (String)

: The contents of the file.

`executable` (Bool, _optional_)

: Make this file have the executable bit set.

  Default: `false`

`destination` (String, _optional_)

: A subpath under the derivation's output path into which to put the file.
  Subdirectories are created automatically when the derivation is realised.

  By default, the store path itself will be a file containing the text contents.

  Default: `""`

`checkPhase` (String, _optional_)

: Commands to run after generating the file.

  Default: `""`

`meta` (Attribute set, _optional_)

: Additional metadata for the derivation.

  Default: `{}`

`allowSubstitutes` (Bool, _optional_)

: Whether to allow substituting from a binary cache.
  Passed through to [`allowSubsitutes`](https://nixos.org/manual/nix/stable/language/advanced-attributes#adv-attr-allowSubstitutes) of the underlying call to `builtins.derivation`.

  It defaults to `false`, as running the derivation's simple `builder` executable locally is assumed to be faster than network operations.
  Set it to true if the `checkPhase` step is expensive.

  Default: `false`

`preferLocalBuild` (Bool, _optional_)

: Whether to prefer building locally, even if faster [remote build machines](https://nixos.org/manual/nix/stable/command-ref/conf-file#conf-substituters) are available.

  Passed through to [`preferLocalBuild`](https://nixos.org/manual/nix/stable/language/advanced-attributes#adv-attr-preferLocalBuild) of the underlying call to `builtins.derivation`.

  It defaults to `true` for the same reason `allowSubstitutes` defaults to `false`.

  Default: `true`

The resulting store path will include some variation of the name, and it will be a file unless `destination` is used, in which case it will be a directory.

::: {.example #ex-writeTextFile}
# Usage 1 of `writeTextFile`

Write `my-file` to `/nix/store/<store path>/some/subpath/my-cool-script`, making it executable.
Also run a check on the resulting file in a `checkPhase`, and supply values for the less-used options.

```nix
writeTextFile {
  name = "my-cool-script";
  text = ''
    #!/bin/sh
    echo "This is my cool script!"
  '';
  executable = true;
  destination = "/some/subpath/my-cool-script";
  checkPhase = ''
    ${pkgs.shellcheck}/bin/shellcheck $out/some/subpath/my-cool-script
  '';
  meta = {
    license = pkgs.lib.licenses.cc0;
  };
  allowSubstitutes = true;
  preferLocalBuild = false;
};
```
:::

::: {.example #ex2-writeTextFile}
# Usage 2 of `writeTextFile`

Write the string `Contents of File` to `/nix/store/<store path>`.
See also the [](#trivial-builder-writeText) helper function.

```nix
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
}
```
:::

::: {.example #ex3-writeTextFile}
# Usage 3 of `writeTextFile`

Write an executable script `my-script` to `/nix/store/<store path>/bin/my-script`.
See also the [](#trivial-builder-writeScriptBin) helper function.

```nix
writeTextFile {
  name = "my-script";
  text = ''
    echo "hi"
  '';
  executable = true;
  destination = "/bin/my-script";
}
```
:::

### `writeText` {#trivial-builder-writeText}

Write a text file to the Nix store

`writeText` takes the following arguments:
a string.

`name` (String)

: The name used in the Nix store path.

`text` (String)

: The contents of the file.

The store path will include the name, and it will be a file.

::: {.example #ex-writeText}
# Usage of `writeText`

Write the string `Contents of File` to `/nix/store/<store path>`:

```nix
writeText "my-file"
  ''
  Contents of File
  '';
```
:::

This is equivalent to:

```nix
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
}
```

### `writeTextDir` {#trivial-builder-writeTextDir}

Write a text file within a subdirectory of the Nix store.

`writeTextDir` takes the following arguments:

`path` (String)

: The destination within the Nix store path under which to create the file.

`text` (String)

: The contents of the file.

The store path will be a directory.

::: {.example #ex-writeTextDir}
# Usage of `writeTextDir`

Write the string `Contents of File` to `/nix/store/<store path>/share/my-file`:

```nix
writeTextDir "share/my-file"
  ''
  Contents of File
  '';
```
:::

This is equivalent to:

```nix
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
  destination = "share/my-file";
}
```

### `writeScript` {#trivial-builder-writeScript}

Write an executable script file to the Nix store.

`writeScript` takes the following arguments:

`name` (String)

: The name used in the Nix store path.

`text` (String)

: The contents of the file.

The created file is marked as executable.
The store path will include the name, and it will be a file.

::: {.example #ex-writeScript}
# Usage of `writeScript`

Write the string `Contents of File` to `/nix/store/<store path>` and make the file executable.

```nix
writeScript "my-file"
  ''
  Contents of File
  '';
```
:::

This is equivalent to:

```nix
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
  executable = true;
}
```

### `writeScriptBin` {#trivial-builder-writeScriptBin}

Write a script within a `bin` subirectory of a directory in the Nix store.
This is for consistency with the convention of software packages placing executables under `bin`.

`writeScriptBin` takes the following arguments:

`name` (String)

: The name used in the Nix store path and within the file created under the store path.

`text` (String)

: The contents of the file.

The created file is marked as executable.
The file's contents will be put into `/nix/store/<store path>/bin/<name>`.
The store path will include the the name, and it will be a directory.

::: {.example #ex-writeScriptBin}
# Usage of `writeScriptBin`

```nix
writeScriptBin "my-script"
  ''
  echo "hi"
  '';
```
:::

This is equivalent to:

```nix
writeTextFile {
  name = "my-script";
  text = ''
    echo "hi"
  '';
  executable = true;
  destination = "bin/my-script"
}
```

### `writeShellScript` {#trivial-builder-writeShellScript}

Write a Bash script to the store.

`writeShellScript` takes the following arguments:

`name` (String)

: The name used in the Nix store path.

`text` (String)

: The contents of the file.

The created file is marked as executable.
The store path will include the name, and it will be a file.

This function is almost exactly like [](#trivial-builder-writeScript), except that it prepends to the file a [shebang](https://en.wikipedia.org/wiki/Shebang_%28Unix%29) line that points to the version of Bash used in Nixpkgs.
<!-- this cannot be changed in practice, so there is no point pretending it's somehow generic -->

::: {.example #ex-writeShellScript}
# Usage of `writeShellScript`

```nix
writeShellScript "my-script"
  ''
  echo "hi"
  '';
```
:::

This is equivalent to:

```nix
writeTextFile {
  name = "my-script";
  text = ''
    #! ${pkgs.runtimeShell}
    echo "hi"
  '';
  executable = true;
}
```

### `writeShellScriptBin` {#trivial-builder-writeShellScriptBin}

Write a Bash script to a "bin" subdirectory of a directory in the Nix store.

`writeShellScriptBin` takes the following arguments:

`name` (String)

: The name used in the Nix store path and within the file generated under the store path.

`text` (String)

: The contents of the file.

The file's contents will be put into `/nix/store/<store path>/bin/<name>`.
The store path will include the the name, and it will be a directory.

This function is a combination of [](#trivial-builder-writeShellScript) and [](#trivial-builder-writeScriptBin).

::: {.example #ex-writeShellScriptBin}
# Usage of `writeShellScriptBin`

```nix
writeShellScriptBin "my-script"
  ''
  echo "hi"
  '';
```
:::

This is equivalent to:

```nix
writeTextFile {
  name = "my-script";
  text = ''
    #! ${pkgs.runtimeShell}
    echo "hi"
  '';
  executable = true;
  destination = "bin/my-script"
}
```

## `concatTextFile`, `concatText`, `concatScript` {#trivial-builder-concatText}

These functions concatenate `files` to the Nix store in a single file. This is useful for configuration files structured in lines of text. `concatTextFile` takes an attribute set and expects two arguments, `name` and `files`. `name` corresponds to the name used in the Nix store path. `files` will be the files to be concatenated. You can also set `executable` to true to make this file have the executable bit set.
`concatText` and`concatScript` are simple wrappers over `concatTextFile`.

Here are a few examples:
```nix

# Writes my-file to /nix/store/<store path>
concatTextFile {
  name = "my-file";
  files = [ drv1 "${drv2}/path/to/file" ];
}
# See also the `concatText` helper function below.

# Writes executable my-file to /nix/store/<store path>/bin/my-file
concatTextFile {
  name = "my-file";
  files = [ drv1 "${drv2}/path/to/file" ];
  executable = true;
  destination = "/bin/my-file";
}
# Writes contents of files to /nix/store/<store path>
concatText "my-file" [ file1 file2 ]

# Writes contents of files to /nix/store/<store path>
concatScript "my-file" [ file1 file2 ]
```

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
Here is an example:
```nix
# adds symlinks of hello and stack to current build and prints "links added"
symlinkJoin { name = "myexample"; paths = [ pkgs.hello pkgs.stack ]; postBuild = "echo links added"; }
```
This creates a derivation with a directory structure like the following:
```
/nix/store/sglsr5g079a5235hy29da3mq3hv8sjmm-myexample
|-- bin
|   |-- hello -> /nix/store/qy93dp4a3rqyn2mz63fbxjg228hffwyw-hello-2.10/bin/hello
|   `-- stack -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/bin/stack
`-- share
    |-- bash-completion
    |   `-- completions
    |       `-- stack -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/share/bash-completion/completions/stack
    |-- fish
    |   `-- vendor_completions.d
    |       `-- stack.fish -> /nix/store/6lzdpxshx78281vy056lbk553ijsdr44-stack-2.1.3.1/share/fish/vendor_completions.d/stack.fish
...
```

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

but none of `hello`'s dependencies because those are not referenced directly
by `hi`'s output.
