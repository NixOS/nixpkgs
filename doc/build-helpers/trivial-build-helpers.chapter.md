# Trivial build helpers {#chap-trivial-builders}

Nixpkgs provides a variety of wrapper functions that help build commonly useful derivations.
Like [`stdenv.mkDerivation`](#sec-using-stdenv), each of these build helpers creates a derivation, but the arguments passed are different (usually simpler) from those required by `stdenv.mkDerivation`.


## `runCommandWith` {#trivial-builder-runCommandWith}

The function `runCommandWith` returns a derivation built using the specified command(s), in a specified environment.

It is the underlying base function of  all [`runCommand*` variants].
The general behavior is controlled via a single attribute set passed
as the first argument, and allows specifying `stdenv` freely.

The following [`runCommand*` variants] exist: `runCommand`, `runCommandCC`, and `runCommandLocal`.

[`runCommand*` variants]: #trivial-builder-runCommand

### Type {#trivial-builder-runCommandWith-Type}

```
runCommandWith :: {
  name :: name;
  stdenv? :: Derivation;
  runLocal? :: Bool;
  derivationArgs? :: { ... };
} -> String -> Derivation
```

### Inputs {#trivial-builder-runCommandWith-Inputs}

`name` (String)
:   The derivation's name, which Nix will append to the store path; see [`mkDerivation`](#sec-using-stdenv).

`runLocal` (Boolean)
:   If set to `true` this forces the derivation to be built locally, not using [substitutes] nor remote builds.
    This is intended for very cheap commands (<1s execution time) which can be sped up by avoiding the network round-trip(s).
    Its effect is to set [`preferLocalBuild = true`][preferLocalBuild] and [`allowSubstitutes = false`][allowSubstitutes].

   ::: {.note}
   This prevents the use of [substituters][substituter], so only set `runLocal` (or use `runCommandLocal`) when certain the user will
   always have a builder for the `system` of the derivation. This should be true for most trivial use cases
   (e.g., just copying some files to a different location or adding symlinks) because there the `system`
   is usually the same as `builtins.currentSystem`.
   :::

`stdenv` (Derivation)
:   The [standard environment](#chap-stdenv) to use, defaulting to `pkgs.stdenv`

`derivationArgs` (Attribute set)
:   Additional arguments for [`mkDerivation`](#sec-using-stdenv).

`buildCommand` (String)
:   Shell commands to run in the derivation builder.

    ::: {.note}
    You have to create a file or directory `$out` for Nix to be able to run the builder successfully.
    :::

[allowSubstitutes]: https://nixos.org/nix/manual/#adv-attr-allowSubstitutes
[preferLocalBuild]: https://nixos.org/nix/manual/#adv-attr-preferLocalBuild
[substituter]: https://nix.dev/manual/nix/latest/glossary#gloss-substituter
[substitutes]: https://nix.dev/manual/nix/2.23/glossary#gloss-substitute

::: {.example #ex-runcommandwith}
# Invocation of `runCommandWith`

```nix
runCommandWith {
  name = "example";
  derivationArgs.nativeBuildInputs = [ cowsay ];
} ''
  cowsay > $out <<EOMOO
  'runCommandWith' is a bit cumbersome,
  so we have more ergonomic wrappers.
  EOMOO
''
```

:::


## `runCommand` and `runCommandCC` {#trivial-builder-runCommand}

The function `runCommand` returns a derivation built using the specified command(s), in the `stdenvNoCC` environment.

`runCommandCC` is similar but uses the default compiler environment. To minimize dependencies, `runCommandCC`
should only be used when the build command needs a C compiler.

`runCommandLocal` is also similar to `runCommand`, but forces the derivation to be built locally.
See the note on [`runCommandWith`] about `runLocal`.

[`runCommandWith`]: #trivial-builder-runCommandWith

### Type {#trivial-builder-runCommand-Type}

```
runCommand      :: String -> AttrSet -> String -> Derivation
runCommandCC    :: String -> AttrSet -> String -> Derivation
runCommandLocal :: String -> AttrSet -> String -> Derivation
```

### Input {#trivial-builder-runCommand-Input}

While the type signature(s) differ from [`runCommandWith`], individual arguments with the same name will have the same type and meaning:

`name` (String)
:   The derivation's name

`derivationArgs` (Attribute set)
:   Additional parameters passed to [`mkDerivation`]

`buildCommand` (String)
:   The command(s) run to build the derivation.


::: {.example #ex-runcommand-simple}
# Invocation of `runCommand`

```nix
runCommand "my-example" {} ''
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

::: {.note}
`runCommand name derivationArgs buildCommand` is equivalent to
```nix
runCommandWith {
  inherit name derivationArgs;
  stdenv = stdenvNoCC;
} buildCommand
```

Likewise, `runCommandCC name derivationArgs buildCommand` is equivalent to
```nix
runCommandWith {
  inherit name derivationArgs;
} buildCommand
```
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
{
  my-file = writeTextFile {
    name = "my-file";
    text = ''
      Contents of File
    '';
    destination = "/share/my-file";
  };
}
```

Remember to append "/share/my-file" to the resulting store path when using it elsewhere:

```nix
writeShellScript "evaluate-my-file.sh" ''
  cat ${my-file}/share/my-file
''
```
::::

### `makeDesktopItem` {#trivial-builder-makeDesktopItem}

Write an [XDG desktop file](https://specifications.freedesktop.org/desktop-entry-spec/1.4/) to the Nix store.

This function is usually used to add desktop items to a package through the `copyDesktopItems` hook.

`makeDesktopItem` adheres to version 1.4 of the specification.

#### Inputs {#trivial-builder-makeDesktopItem-inputs}

`makeDesktopItem` takes an attribute set that accepts most values from the [XDG specification](https://specifications.freedesktop.org/desktop-entry-spec/1.4/ar01s06.html).

All recognised keys from the specification are supported with the exception of the "Hidden" field. The keys are converted into camelCase format, but correspond 1:1 to their equivalent in the specification: `genericName`, `noDisplay`, `comment`, `icon`, `onlyShowIn`, `notShowIn`, `dbusActivatable`, `tryExec`, `exec`, `path`, `terminal`, `mimeTypes`, `categories`, `implements`, `keywords`, `startupNotify`, `startupWMClass`, `url`, `prefersNonDefaultGPU`.

The "Version" field is hardcoded to the version `makeDesktopItem` currently adheres to.

The following fields are either required, are of a different type than in the specification, carry specific default values, or are additional fields supported by `makeDesktopItem`:

`name` (String)

: The name of the desktop file in the Nix store.

`type` (String; _optional_)

: Default value: `"Application"`

`desktopName` (String)

: Corresponds to the "Name" field of the specification.

`actions` (List of Attribute set; _optional_)

: A list of attribute sets {name, exec?, icon?}

`extraConfig` (Attribute set; _optional_)

: Additional key/value pairs to be added verbatim to the desktop file. Attributes need to be prefixed with 'X-'.

#### Examples {#trivial-builder-makeDesktopItem-examples}

::: {.example #ex-makeDesktopItem}
# Usage 1 of `makeDesktopItem`

Write a desktop file `/nix/store/<store path>/my-program.desktop` to the Nix store.

```nix
{makeDesktopItem}:
makeDesktopItem {
  name = "my-program";
  desktopName = "My Program";
  genericName = "Video Player";
  noDisplay = false;
  comment = "Cool video player";
  icon = "/path/to/icon";
  onlyShowIn = [ "KDE" ];
  dbusActivatable = true;
  tryExec = "my-program";
  exec = "my-program --someflag";
  path = "/some/working/path";
  terminal = false;
  actions.example = {
    name = "New Window";
    exec = "my-program --new-window";
    icon = "/some/icon";
  };
  mimeTypes = [ "video/mp4" ];
  categories = [ "Utility" ];
  implements = [ "org.my-program" ];
  keywords = [ "Video" "Player" ];
  startupNotify = false;
  startupWMClass = "MyProgram";
  prefersNonDefaultGPU = false;
  extraConfig.X-SomeExtension = "somevalue";
}
```

:::

::: {.example #ex2-makeDesktopItem}
# Usage 2 of `makeDesktopItem`

Override the `hello` package to add a desktop item.

```nix
{ copyDesktopItems
, hello
, makeDesktopItem }:

hello.overrideAttrs {
  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [(makeDesktopItem {
    name = "hello";
    desktopName = "Hello";
    exec = "hello";
  })];
}
```

:::

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
  Passed through to [`allowSubstitutes`](https://nixos.org/manual/nix/stable/language/advanced-attributes#adv-attr-allowSubstitutes) of the underlying call to `builtins.derivation`.

  It defaults to `false`, as running the derivation's simple `builder` executable locally is assumed to be faster than network operations.
  Set it to true if the `checkPhase` step is expensive.

  Default: `false`

`preferLocalBuild` (Bool, _optional_)

: Whether to prefer building locally, even if faster [remote build machines](https://nixos.org/manual/nix/stable/command-ref/conf-file#conf-substituters) are available.

  Passed through to [`preferLocalBuild`](https://nixos.org/manual/nix/stable/language/advanced-attributes#adv-attr-preferLocalBuild) of the underlying call to `builtins.derivation`.

  It defaults to `true` for the same reason `allowSubstitutes` defaults to `false`.

  Default: `true`

`derivationArgs` (Attribute set, _optional_)

: Extra arguments to pass to the underlying call to `stdenv.mkDerivation`.

  Default: `{}`

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
}
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
  ''
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
  ''
```
:::

This is equivalent to:

```nix
writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
  destination = "/share/my-file";
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
  ''
```

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
:::

### `writeScriptBin` {#trivial-builder-writeScriptBin}

Write a script within a `bin` subdirectory of a directory in the Nix store.
This is for consistency with the convention of software packages placing executables under `bin`.

`writeScriptBin` takes the following arguments:

`name` (String)

: The name used in the Nix store path and within the file created under the store path.

`text` (String)

: The contents of the file.

The created file is marked as executable.
The file's contents will be put into `/nix/store/<store path>/bin/<name>`.
The store path will include the name, and it will be a directory.

::: {.example #ex-writeScriptBin}
# Usage of `writeScriptBin`

```nix
writeScriptBin "my-script"
  ''
  echo "hi"
  ''
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
  destination = "/bin/my-script";
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
  ''
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
  ''
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
  destination = "/bin/my-script";
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

`writeShellApplication` is similar to `writeShellScriptBin` and `writeScriptBin` but supports runtime dependencies with `runtimeInputs`.
Writes an executable shell script to `/nix/store/<store path>/bin/<name>` and checks its syntax with [`shellcheck`](https://github.com/koalaman/shellcheck) and the `bash`'s `-n` option.
Some basic Bash options are set by default (`errexit`, `nounset`, and `pipefail`), but can be overridden with `bashOptions`.

Extra arguments may be passed to `stdenv.mkDerivation` by setting `derivationArgs`; note that variables set in this manner will be set when the shell script is _built,_ not when it's run.
Runtime environment variables can be set with the `runtimeEnv` argument.

For example, the following shell application can refer to `curl` directly, rather than needing to write `${curl}/bin/curl`:

```nix
writeShellApplication {
  name = "show-nixos-org";

  runtimeInputs = [ curl w3m ];

  text = ''
    curl -s 'https://nixos.org' | w3m -dump -T text/html
  '';
}
```

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

Deprecated. Use [`writeClosure`](#trivial-builder-writeClosure) instead.

## `writeClosure` {#trivial-builder-writeClosure}

Given a list of [store paths](https://nixos.org/manual/nix/stable/glossary#gloss-store-path) (or string-like expressions coercible to store paths), write their collective [closure](https://nixos.org/manual/nix/stable/glossary#gloss-closure) to a text file.

The result is equivalent to the output of `nix-store -q --requisites`.

For example,

```nix
writeClosure [ (writeScriptBin "hi" ''${hello}/bin/hello'') ]
```

produces an output path `/nix/store/<hash>-runtime-deps` containing

```
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

```
/nix/store/<hash>-hello-2.10
```

but none of `hello`'s dependencies because those are not referenced directly
by `hi`'s output.
