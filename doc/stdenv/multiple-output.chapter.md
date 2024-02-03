# Multiple-output packages {#chap-multiple-output}

The Nix language allows a derivation to produce multiple outputs, which is similar to what is utilized by other Linux distribution packaging systems. The outputs reside in separate Nix store paths, so they can be mostly handled independently of each other, including passing to build inputs, garbage collection or binary substitution. The exception is that building from source always produces all the outputs.

The main motivation is to save disk space by reducing runtime closure sizes; consequently also sizes of substituted binaries get reduced. Splitting can be used to have more granular runtime dependencies, for example the typical reduction is to split away development-only files, as those are typically not needed during runtime. As a result, closure sizes of many packages can get reduced to a half or even much less.

::: {.note}
The reduction effects could be instead achieved by building the parts in completely separate derivations. That would often additionally reduce build-time closures, but it tends to be much harder to write such derivations, as build systems typically assume all parts are being built at once. This compromise approach of single source package producing multiple binary packages is also utilized often by rpm and deb.
:::

A number of attributes can be used to work with a derivation with multiple outputs.
The attribute `outputs` is a list of strings, which are the names of the outputs.
For each of these names, an identically named attribute is created, corresponding to that output.

The attribute `meta.outputsToInstall` is used to determine the [default set of outputs to install](https://github.com/NixOS/nixpkgs/blob/08c3198f1c6fd89a09f8f0ea09b425028a34de3e/pkgs/stdenv/generic/check-meta.nix#L411-L426) when using the derivation name unqualified:
`bin`, or `out`, or the first specified output; as well as `man` if that is specified.

## Using a split package {#sec-multiple-outputs-using-split-packages}

In the Nix language the individual outputs can be reached explicitly as attributes, e.g. `coreutils.info`, but the typical case is just using packages as build inputs.

When a multiple-output derivation gets into a build input of another derivation, the `dev` output is added if it exists, otherwise the first output is added. In addition to that, `propagatedBuildOutputs` of that package which by default contain `$outputBin` and `$outputLib` are also added. (See [](#multiple-output-file-type-groups).)

In some cases it may be desirable to combine different outputs under a single store path. A function `symlinkJoin` can be used to do this. (Note that it may negate some closure size benefits of using a multiple-output package.)

## Writing a split derivation {#sec-multiple-outputs-}

Here you find how to write a derivation that produces multiple outputs.

In nixpkgs there is a framework supporting multiple-output derivations. It tries to cover most cases by default behavior. You can find the source separated in `<nixpkgs/pkgs/build-support/setup-hooks/multiple-outputs.sh>`; it’s relatively well-readable. The whole machinery is triggered by defining the `outputs` attribute to contain the list of desired output names (strings).

```nix
outputs = [ "bin" "dev" "out" "doc" ];
```

Often such a single line is enough. For each output an equally named environment variable is passed to the builder and contains the path in nix store for that output. Typically you also want to have the main `out` output, as it catches any files that didn’t get elsewhere.

::: {.note}
There is a special handling of the `debug` output, described at [](#stdenv-separateDebugInfo).
:::

### “Binaries first” {#multiple-output-file-binaries-first-convention}

A commonly adopted convention in `nixpkgs` is that executables provided by the package are contained within its first output. This convention allows the dependent packages to reference the executables provided by packages in a uniform manner. For instance, provided with the knowledge that the `perl` package contains a `perl` executable it can be referenced as `${pkgs.perl}/bin/perl` within a Nix derivation that needs to execute a Perl script.

The `glibc` package is a deliberate single exception to the “binaries first” convention. The `glibc` has `libs` as its first output allowing the libraries provided by `glibc` to be referenced directly (e.g. `${glibc}/lib/ld-linux-x86-64.so.2`). The executables provided by `glibc` can be accessed via its `bin` attribute (e.g. `${lib.getBin stdenv.cc.libc}/bin/ldd`).

The reason for why `glibc` deviates from the convention is because referencing a library provided by `glibc` is a very common operation among Nix packages. For instance, third-party executables packaged by Nix are typically patched and relinked with the relevant version of `glibc` libraries from Nix packages (please see the documentation on [patchelf](https://github.com/NixOS/patchelf) for more details).

### File type groups {#multiple-output-file-type-groups}

The support code currently recognizes some particular kinds of outputs and either instructs the build system of the package to put files into their desired outputs or it moves the files during the fixup phase. Each group of file types has an `outputFoo` variable specifying the output name where they should go. If that variable isn’t defined by the derivation writer, it is guessed – a default output name is defined, falling back to other possibilities if the output isn’t defined.

#### `$outputDev` {#outputdev}

is for development-only files. These include C(++) headers (`include/`), pkg-config (`lib/pkgconfig/`), cmake (`lib/cmake/`) and aclocal files (`share/aclocal/`). They go to `dev` or `out` by default.

#### `$outputBin` {#outputbin}

is meant for user-facing binaries, typically residing in `bin/`. They go to `bin` or `out` by default.

#### `$outputLib` {#outputlib}

is meant for libraries, typically residing in `lib/` and `libexec/`. They go to `lib` or `out` by default.

#### `$outputDoc` {#outputdoc}

is for user documentation, typically residing in `share/doc/`. It goes to `doc` or `out` by default.

#### `$outputDevdoc` {#outputdevdoc}

is for _developer_ documentation. Currently we count gtk-doc and devhelp books, typically residing in `share/gtk-doc/` and `share/devhelp/`, in there. It goes to `devdoc` or is removed (!) by default. This is because e.g. gtk-doc tends to be rather large and completely unused by nixpkgs users.

#### `$outputMan` {#outputman}

is for man pages (except for section 3), typically residing in `share/man/man[0-9]/`. They go to `man` or `$outputBin` by default.

#### `$outputDevman` {#outputdevman}

is for section 3 man pages, typically residing in `share/man/man[0-9]/`. They go to `devman` or `$outputMan` by default.

#### `$outputInfo` {#outputinfo}

is for info pages, typically residing in `share/info/`. They go to `info` or `$outputBin` by default.

### Common caveats {#sec-multiple-outputs-caveats}

- Some configure scripts don’t like some of the parameters passed by default by the framework, e.g. `--docdir=/foo/bar`. You can disable this by setting `setOutputFlags = false;`.

- The outputs of a single derivation can retain references to each other, but note that circular references are not allowed. (And each strongly-connected component would act as a single output anyway.)

- Most of split packages contain their core functionality in libraries. These libraries tend to refer to various kind of data that typically gets into `out`, e.g. locale strings, so there is often no advantage in separating the libraries into `lib`, as keeping them in `out` is easier.

- Some packages have hidden assumptions on install paths, which complicates splitting.
