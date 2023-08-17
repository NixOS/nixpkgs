# Trivial Builders {#chap-trivial-builders}

Nixpkgs provides a variety of functions that help with building derivations.
The most important of these, `stdenv.mkDerivation`, has already been documented above.
The following functions wrap `stdenv.mkDerivation`, making it easier to use in certain cases.

## `runCommand` {#trivial-builder-runCommand}

This takes three arguments, `name`, `env`, and `buildCommand`:

* `name` is just the name that Nix will append to the store path in the same way that `stdenv.mkDerivation` uses its
  `name` attribute.
* `env` is an attribute set, specifying environment variables that will be available in the build script for this derivation.
  These attributes are passed through in the underlying call to `stdenv.mkDerivation`.
* `buildCommand` is a `bash` script that will be run to build this derivation.
  Note that you will need to create `$out` as part of the build script for Nix to consider the command as having executed successfully.
  It is sufficient to `touch $out` or `mkdir $out`.

Some examples of using `runCommand` are provided below.

```nix
(import <nixpkgs> {}).runCommand "hello-world" {} ''
  echo 'hello world'
  touch $out
''

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

This works just like `runCommand`. The only difference is that it also provides a C compiler in `buildCommand`'s environment.
To minimize your dependencies, you should only use this if you are sure you will need a C compiler to run your command.

## `runCommandLocal` {#trivial-builder-runCommandLocal}

A variant of `runCommand` that ensures the derivation is built locally instead of substituting a remote build.
It can save time and speed up a larger collection of builds by avoiding the network round-trip to check if a remote substitution is available.
However, it is only intended for very cheap commands (<1s execution time).

::: {.note}
This sets `allowSubstitutes` to `false`.
Only use `runCommandLocal` if you are certain the user will always have a builder for the `system` of the derivation.
This should be true for most trivial use cases (e.g., just copying some files to a different location or adding symlinks)
because there the `system` is usually the same as `builtins.currentSystem`.
:::

## `writeTextFile` {#trivial-builder-writeTextFile}

There are a range of functions that let you write text files into the Nix store, starting with `writeTextFile`.

It accepts one argument as an attribute set containing the following names:

* `name` is the name that Nix will append to the store path in the same way that `stdenv.mkDerivation` uses its `name` attribute.
* `text` is the contents of the file to be written.
* `executable` is an optional boolean flag indicating if the output file should be executable. It is `false` by default.
* `destination` is an optional relative path to be appended to the store path when adding the file to the Nix store.
* `checkPhase` is an optional script that can be run to verify the output file. It is empty by default and is typically used to perform syntax checks.
* `allowSubstitutes` is an optional boolean flag indicating if the derivation can be substituted for a remote build.
  It is `false` by default.
* `preferLocalBuild` is an optional boolean flag indicating a preference for the derivation to be built locally instead of with a remote builder.
  It is `true` by default.
* `meta` is an attribute set which is passed through and corresponds to the `meta` argument for `stdenv.mkDerivation`.

Here are some examples:

```nix
# Writes my-file to /nix/store/<store path>

writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
}

# Writes executable my-file to /nix/store/<store path>/bin/my-file

writeTextFile {
  name = "my-file";
  text = ''
    Contents of File
  '';
  executable = true;
  destination = "/bin/my-file";
}
```

Building on `writeTextFile`there are a series of simplifications which tailor it to a particular use case and are listed below.

### `writeText` {#trivial-builder-writeText}

```nix
# Writes contents of file to /nix/store/<store path>

writeText "my-file"
  ''
  Contents of File
  '';
```

### `writeTextDir` {#trivial-builder-writeTextDir}

```nix
# Writes contents of file to /nix/store/<store path>/share/my-file

writeTextDir "share/my-file"
  ''
  Contents of File
  '';
```

### `writeScript` {#trivial-builder-writeScript}

```nix
# Writes my-file to /nix/store/<store path> and makes executable

writeScript "my-file"
  ''
  Contents of File
  '';
```

### `writeScriptBin` {#trivial-builder-writeScriptBin}

```nix
# Writes my-file to /nix/store/<store path>/bin/my-file and makes executable.

writeScriptBin "my-file"
  ''
  Contents of File
  '';
```

### `writeShellScriptBin` {#trivial-builder-writeShellScriptBin}

```nix
# Writes my-file to /nix/store/<store path>/bin/my-file and makes executable.

writeShellScriptBin "my-file"
  ''
  Contents of File
  '';
```

## `concatTextFile` {#trivial-builder-concatTextFile}

There are a range of functions that let you concatenate a series of files into a single file within the Nix store, starting with `concatTextFile`.

It accepts one argument as an attribute set containing the following names:

* `name` is the name that Nix will append to the store path in the same way that `stdenv.mkDerivation` uses its `name` attribute.
* `files` is a list of file paths to be concatenated.
* `executable` is an optional boolean flag indicating if the output file should be executable.
  It is `false` by default.
* `destination` is an optional relative path to be appended to the store path when adding the file to the Nix store.
* `checkPhase` is an optional script that can be run to verify the output file.
  It is empty by default and is typically used to perform syntax checks.
* `meta` is an attribute set which is passed through and corresponds to the `meta` argument for `stdenv.mkDerivation`.

Here are some examples:

```nix
# Writes my-file to /nix/store/<store path>

concatTextFile {
  name = "my-file";
  files = [ drv1 "${drv2}/path/to/file" ];
}

# Writes executable my-file to /nix/store/<store path>/bin/my-file

concatTextFile {
  name = "my-file";
  files = [ drv1 "${drv2}/path/to/file" ];
  executable = true;
  destination = "/bin/my-file";
}
```

Building on `concatTextFile` there are a series of simplifications which tailor it to a particular use case and are listed below.

### `concatText` {#trivial-builder-concatText}

```nix
# Writes contents of files to /nix/store/<store path>

concatText "my-file" [ file1 file2 ]
```

### `concatScript` {#trivial-builder-concatScript}

```nix
# Writes contents of files to /nix/store/<store path> and makes it executable

concatScript "my-file" [ file1 file2 ]
```

## `writeShellApplication` {#trivial-builder-writeShellApplication}

This function accepts one argument as an attribute set containing the following names:

* `name` is the name that Nix will append to the store path in the same way that `stdenv.mkDerivation` uses its `name` attribute.
* `text` is the contents of the script.
* `runtimeInputs` is a list of derivations.
  For each runtime input `/nix/store/<store path>/bin` will be added to the `PATH` of the script before executing the contents of `text`.
* `checkPhase` is an optional script that can be run to verify the output file.
  It is empty by default and is typically used to perform syntax checks.

In addition to setting the `PATH` based on `runtimeInputs`, `writeShellApplication` also sets some sane shellopts (`errexit`, `nounset`, `pipefail`)
and checks the resulting script with `shellcheck`.

For example:

```nix
writeShellApplication {
  name = "show-nixos-org";
  runtimeInputs = [ curl w3m ];
  text = ''

    # instead of ${curl}/bin/curl we can call it directly as it available in the PATH
    # we can do the same with w3m

    curl -s 'https://nixos.org' | w3m -dump -T text/html
  '';
}
```

## `symlinkJoin` {#trivial-builder-symlinkJoin}

This function can be used to merge the directory structure of several derivations into one.
It works by creating a new derivation and adding symbolic links to each of the paths provided.

It accepts one argument as an attribute set containing the following names:

* `name` is the name that Nix will append to the store path in the same way that `stdenv.mkDerivation` uses its `name` attribute.
* `paths` is a list of paths to merge.
  They can be paths to Nix store derivations or any other subdirectory contained within.
* `preferLocalBuild` is an optional boolean flag indicating a preference for the derivation to be built locally instead of with a remote builder.
  It is `true` by default.
* `allowSubstitutes` is an optional boolean flag indicating if the derivation can be substituted for a remote build.
  It is `false` by default.
* `postBuild` is an optional script which can be run at the end of building the combined derivation.

Here is an example:

```nix
# adds symlinks of hello and stack to current build and prints "links added"

symlinkJoin {
  name = "myexample";
  paths = [ pkgs.hello pkgs.stack ];
  postBuild = "echo links added";
}
```

This creates a derivation with a directory structure as follows:

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

Writes the closure of transitive dependencies for a given derivation to a file.
This produces the equivalent of `nix-store -q --requisites`.

For example:

```nix
writeReferencesToFile (writeScriptBin "hi" ''${hello}/bin/hello'')
```

This produces an output path `/nix/store/<hash>-runtime-deps` containing

```nix
/nix/store/<hash>-hello-2.10
/nix/store/<hash>-hi
/nix/store/<hash>-libidn2-2.3.0
/nix/store/<hash>-libunistring-0.9.10
/nix/store/<hash>-glibc-2.32-40
```

You can see that this includes the derivation `hi` (from the call to `writeScriptBin`),  `hello` which is a direct reference,
and the other paths that are indirectly required to run `hello`.

## `writeDirectReferencesToFile` {#trivial-builder-writeDirectReferencesToFile}

Writes the set of immediate references for a given derivation to a file.
This does not include any transitive dependencies and produces the equivalent of `nix-store -q --references`.

For example:

```nix
writeDirectReferencesToFile (writeScriptBin "hi" ''${hello}/bin/hello'')
```

This produces an output path `/nix/store/<hash>-runtime-references` containing

```nix
/nix/store/<hash>-hello-2.10
```

It does not include any of `hello`'s dependencies because those are not referenced directly by `hi`'s output.
