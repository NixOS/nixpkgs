# OpenFOAM (com) {#sec-openfoam-com}

Unfortunately, OpenFOAM binaries assume you execute them via `bash`, after sourcing `$OPENFOAM_DIR/etc/bashrc`.
To avoid this, binaries from the derivation are wrapped so that they are executed with these requirements.

Additionally, most of its binaries are also able to run in parallel via `mpi`.
To make invocations easier, each binary is also wrapped to run via `mpi`, such as `simpleFoam-mpi`.

## How to compile and use OpenFOAM extensions {#how-to-compile-and-use-openfoam-com-extensions}

The derivation exposes a function to compile extensions:

```nix
fooExt = openfoam.mkExtension {
  name = "foo";
  src = ./test-ext;
};
```

If your extension is an executable, it can be added to `$PATH` as any other executable.

If, instead, it's a shared object (`.so`) meant to be loaded by other OpenFOAM binaries, it should be added to `LD_LIBRARY_PATH`:

```nix
LD_LIBRARY_PATH = lib.makeLibraryPath [fooExt];
```
