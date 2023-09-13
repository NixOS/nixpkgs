# lisp-modules {#lisp}

This document describes the Nixpkgs infrastructure for building Common Lisp
<<<<<<< HEAD
systems that use [ASDF](https://asdf.common-lisp.dev/) (Another System
Definition Facility). It lives in `pkgs/development/lisp-modules`.
=======
libraries that use ASDF (Another System Definition Facility). It lives in
`pkgs/development/lisp-modules`.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

## Overview {#lisp-overview}

The main entry point of the API are the Common Lisp implementation packages
<<<<<<< HEAD
themselves (e.g. `abcl`, `ccl`, `clasp-common-lisp`, `clisp`, `ecl`,
`sbcl`). They have the `pkgs` and `withPackages` attributes, which can be used
to discover available packages and to build wrappers, respectively.

The `pkgs` attribute set contains packages that were automatically
[imported](#lisp-importing-packages-from-quicklisp) from Quicklisp, and any
other [manually defined](#lisp-defining-packages-inside) ones. Not every package
works for all the CL implementations (e.g. `nyxt` only makes sense for `sbcl`).

The `withPackages` function is of primary utility. It is used to build
[runnable wrappers](#lisp-building-wrappers), with a pinned and pre-built
[ASDF FASL](#lisp-loading-asdf) available in the `ASDF` environment variable,
and `CL_SOURCE_REGISTRY`/`ASDF_OUTPUT_TRANSLATIONS` configured to
[find the desired systems on runtime](#lisp-loading-systems).

In addition, Lisps have the `withOverrides` function, which can be used to
[substitute](#lisp-including-external-pkg-in-scope) any package in the scope of
their `pkgs`. This will also be useful together with `overrideLispAttrs` when
[dealing with slashy systems](#lisp-dealing-with-slashy-systems), because they
should stay in the main package and be built by specifying the `systems`
=======
(e.g. `abcl`, `ccl`, `clasp-common-lisp`, `clisp` `ecl`, `sbcl`)
themselves. They have the `pkgs` and `withPackages` attributes, which can be
used to discover available packages and to build wrappers, respectively.

The `pkgs` attribute set contains packages that were automatically imported from
Quicklisp, and any other manually defined ones. Not every package works for all
the CL implementations (e.g. `nyxt` only makes sense for `sbcl`).

The `withPackages` function is of primary utility. It is used to build runnable
wrappers, with a pinned and pre-built ASDF FASL available in the `ASDF`
environment variable, and `CL_SOURCE_REGISTRY`/`ASDF_OUTPUT_TRANSLATIONS`
configured to find the desired systems on runtime.

With a few exceptions, the primary thing that the infrastructure does is to run
`asdf:load-system` for each system specified in the `systems` argument to
`build-asdf-system`, and save the FASLs to the Nix store. Then, it makes these
FASLs available to wrappers. Any other use-cases, such as producing SBCL
executables with `sb-ext:save-lisp-and-die`, are achieved via overriding the
`buildPhase` etc.

In addition, Lisps have the `withOverrides` function, which can be used to
substitute any package in the scope of their `pkgs`. This will be useful
together with `overrideLispAttrs` when dealing with slashy ASDF systems, because
they should stay in the main package and be build by specifying the `systems`
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
argument to `build-asdf-system`.

## The 90% use case example {#lisp-use-case-example}

The most common way to use the library is to run ad-hoc wrappers like this:

`nix-shell -p 'sbcl.withPackages (ps: with ps; [ alexandria ])'`

Then, in a shell:

```
<<<<<<< HEAD
$ sbcl
=======
$ result/bin/sbcl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
* (load (sb-ext:posix-getenv "ASDF"))
* (asdf:load-system 'alexandria)
```

Also one can create a `pkgs.mkShell` environment in `shell.nix`/`flake.nix`:

```
let
  sbcl' = sbcl.withPackages (ps: [ ps.alexandria ]);
in mkShell {
<<<<<<< HEAD
  packages = [ sbcl' ];
=======
  buildInputs = [ sbcl' ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
```

Such a Lisp can be now used e.g. to compile your sources:

```
buildPhase = ''
  ${sbcl'}/bin/sbcl --load my-build-file.lisp
''
```

## Importing packages from Quicklisp {#lisp-importing-packages-from-quicklisp}

<<<<<<< HEAD
To save some work of writing Nix expressions, there is a script that imports all
the packages distributed by Quicklisp into `imported.nix`. This works by parsing
its `releases.txt` and `systems.txt` files, which are published every couple of
months on [quicklisp.org](http://beta.quicklisp.org/dist/quicklisp.txt).

The import process is implemented in the `import` directory as Common Lisp
code in the `org.lispbuilds.nix` ASDF system. To run the script, one can
execute `ql-import.lisp`:

```
cd pkgs/development/lisp-modules
=======
The library is able to very quickly import all the packages distributed by
Quicklisp by parsing its `releases.txt` and `systems.txt` files. These files are
available from [http://beta.quicklisp.org/dist/quicklisp.txt].

The import process is implemented in the `import` directory as Common Lisp
functions in the `org.lispbuilds.nix` ASDF system. To run the script, one can
execute `ql-import.lisp`:

```
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
nix-shell --run 'sbcl --script ql-import.lisp'
```

The script will:

1. Download the latest Quicklisp `systems.txt` and `releases.txt` files
<<<<<<< HEAD
2. Generate a temporary SQLite database of all QL systems in `packages.sqlite`
3. Generate an `imported.nix` file from the database

(The `packages.sqlite` file can be deleted at will, because it is regenerated
each time the script runs.)

The maintainer's job is to:

1. Re-run the `ql-import.lisp` script when there is a new Quicklisp release
2. [Add any missing native dependencies](#lisp-quicklisp-adding-native-dependencies) in `ql.nix`
3. For packages that still don't build, [package them manually](#lisp-defining-packages-inside) in `packages.nix`

Also, the `imported.nix` file **must not be edited manually**! It should only be
generated as described in this section (by running `ql-import.lisp`).
=======
2. Generate an SQLite database of all QL systems in `packages.sqlite`
3. Generate an `imported.nix` file from the database

The maintainer's job there is to:

1. Re-run the `ql-import.lisp` script
2. Add missing native dependencies in `ql.nix`
3. For packages that still don't build, package them manually in `packages.nix`

Also, the `imported.nix` file **must not be edited manually**! It should only be
generated as described in this section.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

### Adding native dependencies {#lisp-quicklisp-adding-native-dependencies}

The Quicklisp files contain ASDF dependency data, but don't include native
library (CFFI) dependencies, and, in the case of ABCL, Java dependencies.

The `ql.nix` file contains a long list of overrides, where these dependencies
can be added.

Packages defined in `packages.nix` contain these dependencies naturally.

### Trusting `systems.txt` and `releases.txt` {#lisp-quicklisp-trusting}

The previous implementation of `lisp-modules` didn't fully trust the Quicklisp
data, because there were times where the dependencies specified were not
<<<<<<< HEAD
complete and caused broken builds. It instead used a `nix-shell` environment to
=======
complete, and caused broken builds. It instead used a `nix-shell` environment to
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
discover real dependencies by using the ASDF APIs.

The current implementation has chosen to trust this data, because it's faster to
parse a text file than to build each system to generate its Nix file, and
because that way packages can be mass-imported. Because of that, there may come
a day where some packages will break, due to bugs in Quicklisp. In that case,
the fix could be a manual override in `packages.nix` and `ql.nix`.

A known fact is that Quicklisp doesn't include dependencies on slashy systems in
its data. This is an example of a situation where such fixes were used, e.g. to
replace the `systems` attribute of the affected packages. (See the definition of
`iolib`).

### Quirks {#lisp-quicklisp-quirks}

During Quicklisp import:

<<<<<<< HEAD
- `+` in names is converted to `_plus{_,}`: `cl+ssl`->`cl_plus_ssl`, `alexandria+`->`alexandria_plus`
- `.` in names is converted to `_dot_`: `iolib.base`->`iolib_dot_base`
=======
- `+` in names are converted to `_plus{_,}`: `cl+ssl`->`cl_plus_ssl`, `alexandria+`->`alexandria_plus`
- `.` to `_dot_`: `iolib.base`->`iolib_dot_base`
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
- names starting with a number have a `_` prepended (`3d-vectors`->`_3d-vectors`)
- `_` in names is converted to `__` for reversibility


## Defining packages manually inside Nixpkgs {#lisp-defining-packages-inside}

<<<<<<< HEAD
Packages that for some reason are not in Quicklisp, and so cannot be
auto-imported, or don't work straight from the import, are defined in the
`packages.nix` file.
=======
New packages, that for some reason are not in Quicklisp, and so cannot be
auto-imported, can be written in the `packages.nix` file.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

In that file, use the `build-asdf-system` function, which is a wrapper around
`mkDerivation` for building ASDF systems. Various other hacks are present, such
as `build-with-compile-into-pwd` for systems which create files during
<<<<<<< HEAD
compilation (such as cl-unicode).

The `build-asdf-system` function is documented
[here](#lisp-defining-packages-outside). Also, `packages.nix` is full of
examples of how to use it.
=======
compilation.

The `build-asdf-system` function is documented with comments in
`nix-cl.nix`. Also, `packages.nix` is full of examples of how to use it.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

## Defining packages manually outside Nixpkgs {#lisp-defining-packages-outside}

Lisp derivations (`abcl`, `sbcl` etc.) also export the `buildASDFSystem`
<<<<<<< HEAD
function, which is similar to `build-asdf-system` from `packages.nix`, but is
part of the public API.

It takes the following arguments:

- `pname`: the package name
- `version`: the package version
- `src`: the package source
- `patches`: patches to apply to the source before build
- `nativeLibs`: native libraries used by CFFI and grovelling
- `javaLibs`: Java libraries for ABCL
- `lispLibs`: dependencies on other packages build with `buildASDFSystem`
- `systems`: list of systems to build

It can be used to define packages outside Nixpkgs, and, for example, add them
into the package scope with `withOverrides`.
=======
function, which is the same as `build-asdf-system`, except for the `lisp`
argument which is set to the given CL implementation.

It can be used to define packages outside Nixpkgs, and, for example, add them
into the package scope with `withOverrides` which will be discussed later on.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

### Including an external package in scope {#lisp-including-external-pkg-in-scope}

A package defined outside Nixpkgs using `buildASDFSystem` can be woven into the
Nixpkgs-provided scope like this:

```
let
  alexandria = sbcl.buildASDFSystem rec {
    pname = "alexandria";
    version = "1.4";
    src = fetchFromGitLab {
      domain = "gitlab.common-lisp.net";
      owner = "alexandria";
      repo = "alexandria";
      rev = "v${version}";
      hash = "sha256-1Hzxt65dZvgOFIljjjlSGgKYkj+YBLwJCACi5DZsKmQ=";
    };
  };
  sbcl' = sbcl.withOverrides (self: super: {
    inherit alexandria;
  });
in sbcl'.pkgs.alexandria
```

## Overriding package attributes {#lisp-overriding-package-attributes}

Packages export the `overrideLispAttrs` function, which can be used to build a
new package with different parameters.

Example of overriding `alexandria`:

```
sbcl.pkgs.alexandria.overrideLispAttrs (oldAttrs: rec {
  version = "1.4";
  src = fetchFromGitLab {
    domain = "gitlab.common-lisp.net";
    owner = "alexandria";
    repo = "alexandria";
    rev = "v${version}";
    hash = "sha256-1Hzxt65dZvgOFIljjjlSGgKYkj+YBLwJCACi5DZsKmQ=";
  };
})
```

<<<<<<< HEAD
=======
## Overriding packages in scope {#lisp-overriding-packages-in-scope}

Packages can be woven into a new scope by using `withOverrides`:

```
let
  sbcl' = sbcl.withOverrides (self: super: {
    alexandria = super.alexandria.overrideLispAttrs (oldAttrs: rec {
      pname = "alexandria";
      version = "1.4";
      src = fetchFromGitLab {
        domain = "gitlab.common-lisp.net";
        owner = "alexandria";
        repo = "alexandria";
        rev = "v${version}";
        hash = "sha256-1Hzxt65dZvgOFIljjjlSGgKYkj+YBLwJCACi5DZsKmQ=";
      };
    });
  });
in builtins.elemAt sbcl'.pkgs.bordeaux-threads.lispLibs 0
```

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
### Dealing with slashy systems {#lisp-dealing-with-slashy-systems}

Slashy (secondary) systems should not exist in their own packages! Instead, they
should be included in the parent package as an extra entry in the `systems`
argument to the `build-asdf-system`/`buildASDFSystem` functions.

The reason is that ASDF searches for a secondary system in the `.asd` of the
parent package. Thus, having them separate would cause either one of them not to
load cleanly, because one will contains FASLs of itself but not the other, and
vice versa.

To package slashy systems, use `overrideLispAttrs`, like so:

```
ecl.pkgs.alexandria.overrideLispAttrs (oldAttrs: {
  systems = oldAttrs.systems ++ [ "alexandria/tests" ];
  lispLibs = oldAttrs.lispLibs ++ [ ecl.pkgs.rt ];
})
```

<<<<<<< HEAD
See the [respective section](#lisp-including-external-pkg-in-scope) on using
`withOverrides` for how to weave it back into `ecl.pkgs`.
=======
See the respective section on using `withOverrides` for how to weave it back
into `ecl.pkgs`.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

Note that sometimes the slashy systems might not only have more dependencies
than the main one, but create a circular dependency between `.asd`
files. Unfortunately, in this case an adhoc solution becomes necessary.

## Building Wrappers {#lisp-building-wrappers}

Wrappers can be built using the `withPackages` function of Common Lisp
implementations (`abcl`, `ecl`, `sbcl` etc.):

```
<<<<<<< HEAD
nix-shell -p 'sbcl.withPackages (ps: [ ps.alexandria ps.bordeaux-threads ])'
```

Such a wrapper can then be used like this:

```
$ sbcl
* (load (sb-ext:posix-getenv "ASDF"))
* (asdf:load-system 'alexandria)
* (asdf:load-system 'bordeaux-threads)
=======
sbcl.withPackages (ps: [ ps.alexandria ps.bordeaux-threads ])
```

Such a wrapper can then be executed like this:

```
result/bin/sbcl
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
```

### Loading ASDF {#lisp-loading-asdf}

For best results, avoid calling `(require 'asdf)` When using the
library-generated wrappers.

Use `(load (ext:getenv "ASDF"))` instead, supplying your implementation's way of
getting an environment variable for `ext:getenv`. This will load the
(pre-compiled to FASL) Nixpkgs-provided version of ASDF.

### Loading systems {#lisp-loading-systems}

There, you can simply use `asdf:load-system`. This works by setting the right
values for the `CL_SOURCE_REGISTRY`/`ASDF_OUTPUT_TRANSLATIONS` environment
variables, so that systems are found in the Nix store and pre-compiled FASLs are
loaded.

## Adding a new Lisp {#lisp-adding-a-new-lisp}

The function `wrapLisp` is used to wrap Common Lisp implementations. It adds the
`pkgs`, `withPackages`, `withOverrides` and `buildASDFSystem` attributes to the
derivation.

`wrapLisp` takes these arguments:

- `pkg`: the Lisp package
- `faslExt`: Implementation-specific extension for FASL files
- `program`: The name of executable file in `${pkg}/bin/` (Default: `pkg.pname`)
- `flags`: A list of flags to always pass to `program` (Default: `[]`)
- `asdf`: The ASDF version to use (Default: `pkgs.asdf_3_3`)
- `packageOverrides`: Package overrides config (Default: `(self: super: {})`)

This example wraps CLISP:

```
wrapLisp {
  pkg = clisp;
  faslExt = "fas";
  flags = ["-E" "UTF8"];
}
```
