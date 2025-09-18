# Factor {#sec-language-factor}

## Development Environment {#ssec-factor-dev-env}

All Nix expressions for the Factor compiler and development environment can be found in `pkgs/top-level/factor-packages.nix`.

The default package `factor-lang` provides support for the built-in graphical user interface and a selected set of C library bindings, e.g., for sound and TLS connections.
It also comes with the Fuel library for Emacs that provides an integrated development environment for developing Factor programs including access to the Factor runtime and online documentation.

For using less frequently used libraries that need additional bindings, you can override the `factor-lang` package and add more library bindings and/or binaries to its PATH.
The package is defined in `pkgs/development/compilers/factor-lang/wrapper.nix` and provides several attributes for adding those:

- `extraLibs` adds the packages' `/lib` paths to the wrapper and adds all shared libraries to an ld.so cache such that they can be found dynamically by the Factor runtime.
- `binPackages` does the same as `extraLibs` and additionally adds the packages to Factor's PATH environment variable.
- `extraVocabs` adds Factor vocabularies to the tree that are not part of the standard library.
  The packages must adhere to the default vocabulary root structure to be found.
- `guiSupport` draws in all necessary graphical libraries to enable the Factor GUI.
  This should be set to `true` when considering building and running graphical applications with this Factor runtime (even if the Factor GUI is not used for programming).
  This argument is `true` by default.
- `enableDefaults` can be deactivated to only wrap libraries that are named in `extraLibs` or `binPackages`.
  This reduces the runtime dependencies especially when shipping Factor applications.

The package also passes through several attributes listing the wrapped libraries and binaries, namely, `extraLibs` and `binPackages` as well as `defaultLibs` and `defaultBins`.
Additionally, all `runtimeLibs` is the concatenation of all the above for the purpose of providing all necessary dynamic libraries as "`propagatedBuildInputs`".

`factorPackages` provides pre-configured Factor packages:
- `factorPackages.factor-lang` is the default package with GUI support and several default library bindings (e.g. openssl, openal etc.).
- `factorPackages.factor-no-gui` turns off GUI support while maintaining default library bindings.
- `factorPackages.factor-minimal` comes with practically no additional library bindings and binaries and no GUI support.
- `factorPackages.factor-minimal-gui` comes with no additional library bindings but includes GUI support.

### Scaffolding and the `work` vocabulary root {#ssec-factor-scaffolding}

Factor uses the concept of "scaffolding" to spin off a new vocabulary in a personal workspace rooted at the `work` vocabulary root.
This concept does not scale very well, because it makes many assumptions which all turn out to be wrong at some point.
In the current implementation, the `work` vocabulary root points to `/var/lib/factor` on the target machine.
This can be suitable for a single-user system.
Create the location and make it writable to your user.
Then, you can use the `scaffold-work` word as instructed by many tutorials.

If you don't like this approach, you can work around it by creating a `~/.factor-roots` file in your home directory which contains the locations you desire to represent additional Factor vocabulary roots, one directory per line.
Use `scaffold-vocab` to create your vocabularies in one of these additional roots.
The online Factor documentation is extensive on how to use the scaffolding framework.

## Packaging Factor Vocabularies {#ssec-factor-packaging}

All Factor vocabularies that shall be added to a Factor environment via the `extraVocabs` attribute must adhere to the following directory scheme.
Its top-level directory must be one (or multiple) of `basis`, `core` or `extra`.
`work` is routed to `/var/lib/factor` and is not shipped nor referenced in the nix store, see the section on [scaffolding](#ssec-factor-scaffolding).
You should usually use `extra`, but you can use the other roots to overwrite built-in vocabularies.
Be aware that vocabularies in `core` are part of the Factor image which the development environment is run from.
This means the code in those vocabularies is not loaded from the sources, such that you need to call `refresh-all` to recompile and load the changed definitions.
In these instances, it is advised to override the `factor-unwrapped` package directly, which compiles and packages the core Factor libraries into the default Factor
image.

As per Factor convention, your vocabulary `foo.factor` must be in a directory of the same name in addition to one of the previously mentioned vocabulary roots, e.g. `extra/foo/foo.factor`.

All extra Factor vocabularies are registered in `pkgs/top-level/factor-packages.nix` and their package definitions usually live in `development/compilers/factor-lang/vocabs/`.

Package a vocabulary using the `buildFactorVocab` function.
Its default `installPhase` takes care of installing it under `out/lib/factor`.
It also understands the following special attributes:
- `vocabName` is the path to the vocabulary to be installed.
  Defaults to `pname`.
- `vocabRoot` is the vocabulary root to install the vocabulary under.
  Defaults to `extra`.
  Unless you know what you are doing, do not change it.
  Other readily understood vocabulary roots are `core` and `basis`, which allow you to modify the default Factor runtime environment with an external package.
- `extraLibs`, `extraVocabs`, `extraPaths` have the same meaning as for [applications](#ssec-factor-applications).
  They have no immediate effect and are just passed through.
  When building factor-lang packages and Factor applications that use this respective vocabulary, these variables are evaluated and their paths added to the runtime environment.

The function understands several forms of source directory trees:
1. Simple single-vocab projects with their Factor and supplementary files directly in the project root.
   All `.factor` and `.txt` files are copied to `out/lib/factor/<vocabRoot>/<vocabName>`.
2. More complex projects with several vocabularies next to each other, e.g. `./<vocabName>` and `./<otherVocab>`.
   All directories except `bin`, `doc` and `lib` are copied to `out/lib/factor/<vocabRoot>`.
3. Even more complex projects that touch multiple vocabulary roots.
   Vocabularies must reside under `lib/factor/<root>/<vocab>` with the name-giving vocabulary being in `lib/factor/<vocabRoot>/<vocabName>`.
   All directories in `lib/factor` are copied to `out/`.

For instance, packaging the Bresenham algorithm for line interpolation looks like this, see `pkgs/development/compilers/factor-lang/vocabs/bresenham` for the complete file:
```nix
{ factorPackages, fetchFromGitHub }:

factorPackages.buildFactorVocab {
  pname = "bresenham";
  version = "dev";

  src = fetchFromGitHub {
    owner = "Capital-EX";
    repo = "bresenham";
    rev = "58d76b31a17f547e19597a09d02d46a742bf6808";
    hash = "sha256-cfQOlB877sofxo29ahlRHVpN3wYTUc/rFr9CJ89dsME=";
  };
}
```

The vocabulary goes to `lib/factor/extra`, extra files, like licenses etc. would go to `share/` as usual and could be added to the output via a `postInstall` phase.
In case the vocabulary binds to a shared library or calls a binary that needs to be present in the runtime environment of its users, add `extraPaths` and `extraLibs` attributes, respectively.
They are then picked up by the `buildFactorApplication` function and added as runtime dependencies.

## Building Applications {#ssec-factor-applications}

Factor applications are built using Factor's `deploy` facility with the help of the `buildFactorApplication` function.

### `buildFactorApplication` function {#ssec-factor-buildFactorApplication-func}

`factorPackages.buildFactorApplication` *`buildDesc`*

When packaging a Factor application with [`buildFactorApplication`](#ssec-factor-buildFactorApplication-func), its [`override`](#sec-pkg-override) interface should contain the `factorPackages` argument.
For example:
```nix
{
  lib,
  fetchurl,
  factorPackages,
}:

factorPackages.buildFactorApplication (finalAttrs: {
  pname = "foo";
  version = "1.0";

  src = fetchurl {
    url = "https://some-forge.org/foo-${finalAttrs.version}.tar.gz";
  };
})
```

The `buildFactorApplication` function expects the following source structure for a package `foo-1.0` and produces a `/bin/foo` application:
```
foo-1.0/
  foo/
    foo.factor
    deploy.factor
  <more files and directories>...
```

It provides the additional attributes `vocabName` and `binName` to cope with naming deviations.
The `deploy.factor` file controls how the application is deployed and is documented in the Factor online documentation on the `deploy` facility.

Use the `preInstall` or `postInstall` hooks to copy additional files and directories to `out/`.
The function itself only builds the application in `/lib/factor/` and a wrapper in `/bin/`.

A more complex example shows how to specify runtime dependencies and additional Factor vocabularies at the example of the `painter` Factor application:
```nix
{
  lib,
  fetchFromGitHub,
  factorPackages,
  curl,
}:

factorPackages.buildFactorApplication (finalAttrs: {
  pname = "painter";
  version = "1";

  factor-lang = factorPackages.factor-minimal-gui;

  src = fetchFromGitHub {
    name = finalAttrs.vocabName;
    owner = "Capital-EX";
    repo = "painter";
    rev = "365797be8c4f82440bec0ad0a50f5a858a06c1b6";
    hash = "sha256-VdvnvKNGcFAtjWVDoxyYgRSyyyy0BEZ2MZGQ71O8nUI=";
  };

  sourceRoot = ".";

  enableUI = true;
  extraVocabs = [ factorPackages.bresenham ];

  extraPaths = with finalAttrs.factor-lang; binPackages ++ defaultBins ++ [ curl ];

})
```

The use of the `src.name` and `sourceRoot` attributes conveniently establish the necessary `painter` vocabulary directory that is needed for the deployment to work.

It requires the packager to specify the full set of binaries to be made available at runtime.
This enables the standard pattern for application packages to specify all runtime dependencies explicitly without the Factor runtime interfering.

`buildFactorApplication` is a wrapper around `stdenv.mkDerivation` and takes all of its attributes.
Additional attributes that are understood by `buildFactorApplication`:

*`buildDesc`* (Function or attribute set)

: A build description similar to `stdenv.mkDerivation` with the following attributes:

  `vocabName` (String; _optional_)

  : is the path to the vocabulary to be deployed relative to the source root.
    So, directory `foo/` from the example above could be `extra/deep/down/foo`.
    This allows you to maintain Factor's vocabulary hierarchy and distribute the same source tree as a stand-alone application and as a library in the Factor development environment via the `extraVocabs` attribute.

  `binName` (String; _optional_)

  : is the name of the resulting binary in `/bin/`.
    It defaults to the last directory component in `vocabName`.
    It is also added as the `meta.mainProgram` attribute to facilitate `nix run`.

  `enableUI` (Boolean; _optional_)

  : is `false` by default.
    Set this to `true` when you ship a graphical application.

  `extraLibs` (List; _optional_)

  : adds additional libraries as runtime dependencies.
    Defaults to `[]` and is concatenated with `runtimeLibs` from the used factor-lang package.
    Use `factor-minimal` to minimize the closure of runtime libraries.

  `extraPaths` (List; _optional_)

  : adds additional binaries to the runtime PATH environment variable (without adding their libraries, as well).
    Defaults to `[]` and is concatenated with `defaultBins` and `binPackages` from the used factor-lang package.
    Use `factor-minimal` to minimize the closure of runtime libraries.

  `deployScriptText` (String; _optional_)

  : is the actual deploy Factor file that is executed to deploy the application.
    You can change it if you need to perform additional computation during deployment.

  `factor-lang` (Package; _optional_)

  : overrides the Factor package to use to deploy this application, which also affects the default library bindings and programs in the runtime PATH.
    It defaults to `factor-lang` when `enableUI` is turned on and `factor-no-gui` when it is turned off.
    Applications that use only Factor libraries without external bindings or programs may set this to `factor-minimal` or `factor-minimal-gui`.
