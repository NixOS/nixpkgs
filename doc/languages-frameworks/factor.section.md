# Factor {#sec-language-factor}

## Development Environment {#ssec-dev-env}

All Nix expressions for the Factor compiler and development environment can be
found in `pkgs/development/compilers/factor-lang/scope.nix`.

The default package `factor-lang` provides support for the built-in graphical
user interface and a selected set of C library bindings, e.g., for sound and TLS
connections. It also comes with the Fuel library for Emacs that provides an
integrated development environment for developing factor programs including
access to the factor runtime and online documentation.

For using less frequently used libraries that need additional bindings, you can
override the `factor-lang` package and add more library bindings and/or binaries
to its PATH. The package is defined in
`pkgs/development/compilers/factor-lang/wrapper.nix` and provides several
attributes for adding those:

- `runtimeLibs` adds the packages' `/lib` paths to the wrapper and adds all
  shared libraries to an ld.so cache such that they can be found dynamically by
  the factor runtime.
- `binPackages` does the same as `runtimeLibs` and additionally adds the
  packages to factor's PATH environment variable.
- `extraVocabs` adds factor vocabularies to the tree that are not part of the
  standard library. The packages must adhere to the default vocabulary root
  structure to be found.
- `guiSupport` draws in all necessary graphical libraries to enable the factor
  GUI.  This should be set to `true` when considering building and running
  graphical applications with this factor runtime (even if the factor GUI is not
  used for programming).  This argument is `true` by default.
- `enableDefaults` can be deactivated to only wrap libraries that are named in
  `runtimeLibs` or `binPackages`. This reduces the runtime dependencies
  especially when shipping factor applications.

The package also passes through several attributes listing the wrapped libraries
and binaries, namely, `runtimeLibs` and `binPackages` as well as `defaultLibs`
and `defaultBins`.

`factor-lange-scope` provides pre-configured factor packages:
- `factor-lang-scope.factor-lang` is the default package with GUI support and
  several default library bindings (e.g. openssl, openal etc.).
- `factor-lang-scope.factor-no-gui` turns off GUI support while maintaining
  default library bindings.
- `factor-lang-scope.factor-minimal` comes with practically no additional
  library bindings and binaries and no GUI support.

### Scaffolding and the `work` vocabulary root {#ssec-scaffolding}

Factor uses the concept of "scaffolding" to spin off a new vocabulary in a
personal workspace rooted at the `work` vocabulary root.  This concept does not
scale very well, because it makes many assumptions which all turn out to be
wrong at some point.  In the current implementation, the `work` vocabulary root
points to `/var/lib/factor` on the target machine.  This can be suitable for a
single-user system.  Create the location and make it writable to your user.
Then, you can use the `scaffold-work` word as instructed by many tutorials.

If you don't like this approach, you can work around it by creating a
`~/.factor-roots` file in your home directory which contains the locations you
desire to represent additional factor vocabulary roots, one directory per line.
Use `scaffold-vocab` to create your vocabularies in one of these additional
roots.  The online factor documentation is extensive on how to use the
scaffolding framework.

## Packaging Factor Vocabularies {#ssec-packaging}

All factor vocabularies that shall be added to a factor environment via the
`extraVocabs` attribute must adhere to the following directory scheme.  Its
top-level directory must be one (or multiple) of `basis`, `core` or `extra`.
`work` is routed to `/var/lib/factor` and is not shipped nor referenced in the
nix store, see the section on [scaffolding](#ssec-scaffolding).  You should
usually use `extra`, but you can use the other roots to overwrite built-in
vocabularies.  Be aware that vocabularies in `core` are part of the factor image
which the development environment is run from.  This means the code in those
vocabularies is not loaded from the sources, such that you need to call
`refresh-all` to re-compile and load the changed definitions.  In these
instances, it is advised to override the `factor-unwrapped` package directly,
which compiles and packages the core factor libraries into the default factor
image.

As per factor convention, your vocabulary `foo.factor` must be in a directory of
the same name in addition to one of the previously mentioned vocabulary roots,
e.g. `extra/foo/foo.factor`.

All extra factor vocabularies reside in
`pkgs/development/compilers/factor-lang/scope.nix`.


## Building Applications {#ssec-applications}

Factor applications are built using factor's `deploy` facility with the help of
the `buildFactorApplication` function.

### `buildFactorApplication` function {#ssec-buildFactorApplication-func}

When packaging a Factor application with
[`buildFactorApplication`](#ssec-buildFactorApplication-func), it should be
called with `callPackage` and passed the `factor-lang-scope` attribute, like this:
```nix
{ lib, fetchurl, factor-lang-scope }:

factor-lang-scope.buildFactorApplication (finalAttrs: {
  pname = "foo";
  version = "1.0";

  src = fetchurl {
    url = "https://some-forge.org/foo-${finalAttrs.version}.tar.gz"
  };
})
```

It is added to `all-packages.nix` as any other application would be.

```nix
foo = callPackage ../applications/development/foo { };
```

The `buildFactorApplication` function expects the following source structure for
a package `foo-1.0` and produces a `/bin/foo` application:
```
foo-1.0/
  foo/
    foo.factor
    deploy.factor
  <more files and directories>...
```

It provides the additional attributes `vocabName` and `binName` to cope with
naming deviations.  The `deploy.factor` file controls how the application is
deployed and is documented in the factor online documentation on the `deploy`
facility.

Use the `preInstall` or `postInstall` hooks to copy additional files and
directories to `out/`.  The function itself only builds the application in
`/lib/factor/` and a wrapper in `/bin/`.

A more complex example shows how to specify runtime dependencies for the wrapped
application:
```nix
{ lib, fetchurl, factor-lang-scope, curl }:

factor-lang-scope.buildFactorApplication (finalAttrs: {
  pname = "foo";
  version = "1.0";

  src = fetchurl {
    url = "https://some-forge.org/foo-${finalAttrs.version}.tar.gz"
  };

  extraPaths = with finalAttrs.factor-lang; binPackages ++ defaultBins ++ [ curl ];
})
```

It requires the packager to specify the full set of binaries to be made
available at runtime.  This enables the standard pattern for application
packages to specify all runtime dependencies explicitly without the factor
runtime interfering.

Additional attribute that are understood by `buildFactorApplication`:
- `vocabName` is the path to the vocabulary to be deployed relative to the
  source root. So, directory `foo/` from the example above could be
  `extra/deep/down/foo`. This allows you to maintain factor's vocabulary
  hierarchy and distribute the same source tree as a stand-alone application and
  as a library in the factor development environment via the `extraVocabs`
  attribute.
- `binName` is the name of the resulting binary in `/bin/`.  It defaults to the
  last directory component in `vocabName`.  It is also added as the
  `meta.mainProgram` attribute to facilitate `nix run`.
- `enableUI` is `false` by default.  Set this to `true` when you ship a
  graphical application.
- `extraLibs` adds additional libraries as runtime dependencies. Defaults to the
  `defaultLibs ++ runtimeLibs` passthru attributes from the used factor-lang
  package.  Setting this disables the defaults.  Thus, all necessary libraries
  must be listed.
- `extraPaths` adds additional binaries to the runtime PATH environment variable
  (without adding their libraries, as well).  Defaults to the `defaultBins ++
  binPackages` attributes from the used factor-lang package.  Setting this
  disables the defaults.  Thus, all necessary binary packages must be listed.
- `deployScriptText` is the actual deploy factor file that is executed to deploy
  the application.  You can change it if you need to perform additional
  computation during deployment.
- `factor-lang` overrides the factor package to use to deploy this application,
  which also affects the default library bindings and programs in the runtime
  PATH. It defaults to `factor-lang` when `enableUI` is turned on and
  `factor-no-gui` when it is turned off.  Applications that use only factor
  libraries without external bindings or programs may set this to
  `factor-minimal`.
