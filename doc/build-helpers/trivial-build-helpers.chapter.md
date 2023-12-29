# Trivial build helpers {#chap-trivial-builders}

`nixpkgs` provides a variety of wrapper functions that help build very simple derivations. Like [`stdenv.mkDerivation`](#sec-using-stdenv), each of these builders creates and returns a derivation, but the composition of the arguments passed to each are different (usually simpler) than the arguments that must be passed to `stdenv.mkDerivation`.

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

## `writeTextFile`, `writeText`, `writeTextDir`, `writeScript`, `writeScriptBin`, `writeShellScript`, `writeShellScriptBin` {#trivial-builder-textwriting}

`nixpkgs` provides a number of functions that produce derivations which write text into the Nix store.  These include `writeTextFile`, `writeText`, `writeTextDir`, `writeScript`, `writeScriptBin`, `writeShellScript`, and `writeShellScriptBin`, each of which is documented below.

These are useful for creating files from Nix expressions, which may be scripts or non-executable text files, depending on which of the functions is used and the arguments it takes.

The result of each of these functions will be a derivation.  When you coerce the resulting derivation to text, it will evaluate to the *store path*. Importantly, it will not include the destination subpath produced by the particular function.  So, for example, given the following expression:

```nix

my-file = writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
  destination = "/share/my-file";
}
```

If `my-file` is coerced to text, it will resolve to `/nix/store/<store path>`, like any other derivation.  It will *not* evaluate to `/nix/store/<store path>/share/my-file`.  So to use it elsewhere, as an example (in this case, within a shell script you're writing in a Nix expression via `writeShellScript`), you might do:

```nix
writeShellScript "evaluate-my-file.sh" ''
  cat ${my-file}/share/my-file
'';
```

This will produce the desired result.  However, the following will not, it will fail because the store path is a directory, and is not the `my-file` file.

```nix
writeShellScript "evaluate-my-file.sh" ''
  cat ${my-file}
'';
```

### `writeTextFile` {#trivial-builder-writeTextFile}

`writeTextFile` takes an attribute set and expects it to contain at least two attributes: `name` and `text`.

`name` corresponds to the name used in the Nix store path identifier.

`text` will be the contents of the file.

The resulting store path will include some variation of the name, and it will be a file unless `destination` (see below) is used, in which case it will be a directory.

Common optional attributes in the attribute set are:

`executable`: make this file have the executable bit set.  Defaults to `false`

`destination`: supplies a subpath under the derivation's Nix store ouput path into which to create the file.  It may contain directory path elements, these are created automatically when the derivation is realized.  Defaults to `""`, which indicates that the store path itself will be a file containing the text contents.

Other less-frequently used optional attributes are:

`checkPhase`: commands to run after generating the file, e.g. lints. It defaults to `""` (no checking).

`meta`: Additional metadata for the derivation.  It defaults to `{}`.

`allowSubstitutes`: whether to allow substituting from a binary cache.  It fefaults to `false`, as the operation is assumed to be faster performed locally.  You may want to set this to true if the `checkPhase` step is expensive.

`preferLocalBuild`: whether to prefer building locally, even if faster remote builders are available. It defaults to `true` for the same reason `allowSubstitutes` defaults to `false`.

::: {.example #ex-writeTextFile}
# Usages of `writeTextFile`
```nix
# Writes my-file to /nix/store/<store path>/some/subpath/my-cool-script,
# making it executable and also supplies values for the less-used options
writeTextFile rec {
  name = "my-cool-script";
  text = ''
    #!/bin/sh
    echo "This is my cool script!"
  '';
  executable = true;
  destination = "some/subpath/my-cool-script";
  checkPhase = ''
    ${pkgs.shellcheck}/bin/shellcheck $out/${destination}
  '';
  meta = {
    license = pkgs.lib.licenses.cc0;
  };
  allowSubstitutes = true;
  preferLocalBuild = false;
}

# Writes my-file to /nix/store/<store path>
# See also the `writeText` helper function below.
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
}

# Writes executable my-file to /nix/store/<store path>/bin/my-file
# see also the `writeScriptBin` helper function below.
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
  executable = true;
  destination = "/bin/my-file";
}
```
:::

::: {.note}
The commands `writeText`, `writeTextDir`, `writeScript`, `writeScriptBin`, `writeShellScript`, and `writeShellScriptBin` documented below are convenience functions that wrap `writeTextFile`.
:::

### `writeText` {#trivial-builder-writeText}

`writeText` takes two arguments: `name` and `text`.

`name` is the name used in the Nix store path.   `text` will be the contents of the file.

The store path will include the the name, and it will be a file. Any path separators and shell-reserved elements in the name are escaped to create the store path identifier.

Here is an example.

::: {.example #ex-writeText}
# Usage of `writeText`
```nix
# Writes my-file to /nix/store/<store path>
writeText "my-file"
  ''
  Contents of File
  '';
```
:::

This example is a simpler way to spell:

```nix
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
}
```

### `writeTextDir` {#trivial-builder-writeTextDir}

`writeTextDir` takes two arguments: `path` and `text`.

`path` is the destination within the Nix store path under which to create the file.   `text` will be the contents of the file.

The store path will be a directory. The Nix store identifier will be generated based on various elements of the path.

::: {.example #ex-writeTextDir}
# Usage of `writeTextDir`
```nix
# Writes contents of file to /nix/store/<store path>/share/my-file
writeTextDir "share/my-file"
  ''
  Contents of File
  '';
```
:::

The example is a simpler way to spell:

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

`writeScript` takes two arguments: `name` and `text`.

`name` is the name used in the Nix store path.   `text` will be the contents of the file.   The created file is marked as executable.

The store path will include the the name, and it will be a file. Any path separators and shell-reserved elements in the name are escaped to create the store path identifier.

Here is an example.

::: {.example #ex-writeScript}
# Usage of `writeScript`
```nix
# Writes my-file to /nix/store/<store path> and makes executable
writeScript "my-file"
  ''
  Contents of File
  '';
```
:::

The example is a simpler way to spell:

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

`writeScriptBin` takes two arguments: `name` and `text`.

`name` is the name used in the Nix store path and within the file generated under the store path.  `text` will be the contents of the file.  The created file is marked as executable.

The file's contents will be put into `/nix/store/<store path>/bin/<name>`.

The store path will include the the name, and it will be a directory. Any path separators and shell-reserved elements in the name are escaped to create the store path identifier.

::: {.example #ex-writeScriptBin}
# Usage of `writeScriptBin`
```nix
writeScriptBin "my-script"
  ''
  echo "hi"
  '';
```
:::

The example is a simpler way to spell:

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

`writeShellScript` takes two arguments: `name` and `text`.

`name` is the name used in the Nix store path.   `text` will be the contents of the file.   The created file is marked as executable.  This function is almost exactly like `writeScript`, but it prepends a shebang line that points to the runtime shell (usually bash) at the top of the file contents.

The store path will include the the name, and it will be a file. Any path separators and shell-reserved elements in the name are escaped to create the store path identifier.

Here is an example.

::: {.example #ex-writeShellScript}
# Usage of `writeShellScript`
```nix
writeShellScript "my-script"
  ''
  echo "hi"
  '';
```
:::

The example is a simpler way to spell:

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

`writeShellScriptBin` takes two arguments: `name` and `text`.

`name` is the name used in the Nix store path and within the file generated under the store path.  `text` will be the contents of the file.  This function is almost exactly like `writeScriptBin`, but it prepends a shebang line that points to the runtime shell (usually bash) at the top of the file contents.

The file's contents will be put into `/nix/store/<store path>/bin/<name>`.

The store path will include the the name, and it will be a directory. Any path separators and shell-reserved elements in the name are escaped to create the store path identifier.

::: {.example #ex-writeShellScriptBin}
# Usage of `writeShellScriptBin`
```nix
writeShellScriptBin "my-script"
  ''
  echo "hi"
  '';
```
:::

The example is a simpler way to spell:

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
