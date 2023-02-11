# Lisp {#lisp}

## Overview {#lisp-overview}

The Lisp infrastructure works in the following way:

1. Package definitions are imported from Quicklisp (`ql-import.lisp`)
2. Missing native libraries etc. are fixed in `ql.nix`
2. Additional packages are defined using `build-asdf-system` in `packages.nix`
3. CL implementations are enhanced with the `pkgs` and `withPackages` attributes
4. Packages are overridden individually using `overrideLispAttrs`
5. Packages are woven into a new scope using `packageOverlays`

## Importing from Quicklisp {#lisp-importing-from-quicklisp}

### The `ql-import` script {#lisp-ql-import}

There is a Common Lisp program in the `import` directory, which downloads the
`systems.txt` and `releases.txt` files from `quicklisp.org` and creates a Nix
expression with package definitions in a file called `imported.nix`.

To run this import process, execute:

```sh
$ nix-shell
$ sbcl --script ql-import.lisp
```

It also creates a `packages.sqlite` file. It's used during the
generation of the `imported.nix` file and can be safely removed. It
contains the full information of Quicklisp packages, so you can use it
to query the dependency graphs using SQL, if you're interested.

### Choosing a Quicklisp release {#lisp-choosing-a-quicklisp-release}

Quicklisp release URL is configured in the `import/main.lisp` file.

Change the `:dist-url` keyword argument to `make-instance 'quicklisp-repository`
before running `ql-import.lisp` to upgrade to a newer release.

## Manually defining packages {#lisp-manually-defining-packages}

Packages are declared using `buildASDFSystem`. This function takes
the following arguments and returns a Lisp package derivation.

### Example {#lisp-build-asdf-system-example}

```nix
sbcl.buildASDFSystem {
  pname = "alexandria";
  version = "v1.4";
  src = pkgs.fetchFromGitLab {
    domain = "gitlab.common-lisp.net";
    owner = "alexandria";
    repo = "alexandria";
    rev = "v1.4";
    hash = "sha256-1Hzxt65dZvgOFIljjjlSGgKYkj+YBLwJCACi5DZsKmQ=";
  };
}
```


### Required arguments {#lisp-build-asdf-system-required-arguments}

- `pname`
Name of the package/library

- `version`
Version of the package/library

- `src`
Source of the package/library (`fetchTarball`, `fetchGit`, `fetchMercurial` etc.)

### Optional arguments {#lisp-build-asdf-system-optional-arguments}

- `patches ? []`

Patches to apply to the source code before compiling it. This is a
list of files.

- `nativeLibs ? []`

Native libraries, will be appended to the library
path. (`pkgs.openssl` etc.)

- `javaLibs ? []`

Java libraries for ABCL, will be appended to the class path.

- `lispLibs ? []`

Lisp dependencies These must themselves be packages built with
`buildASDFSystem`

- `systems ? [ pname ]`

Some libraries have multiple systems under one project, for example,
`cffi` has `cffi-grovel`, `cffi-toolchain` etc.  By default, only the
`pname` system is build.

`.asd's` not listed in `systems` are removed before saving the library
to the Nix store. This prevents ASDF from referring to uncompiled
systems on run time.

Also useful when the `pname` is differrent than the system name, such
as when using reverse domain naming. (see `jzon` -> `com.inuoe.jzon`)

### Return value {#lisp-build-asdf-system-return-value}

A `derivation` that, when built, contains the sources and pre-compiled
FASL files (Lisp implementation dependent) alongside any other
artifacts generated during compilation.

## Building a Lisp with packages: `withPackages` {#lisp-building-a-lisp-with-packages}

### Example {#lisp-building-a-lisp-with-packages-example}

`sbcl.withPackages (ps: [ ps.alexandria ])`

### Required Arguments {#lisp-building-a-lisp-with-packages-required-arguments}

- `pkgfn`:

A function of one argument that takes an attribute set (containing all the Lisp
packages imported from Quicklisp and declared manually) and returns a list.

### Return value {#lisp-building-a-lisp-with-return-value}

A lisp derivation that knows how to load some packages with `asdf:load-system`.

### Loading ASDF itself {#lisp-loading-asdf-itself}

Path to ASDF itself is put in the `ASDF` environment variable. Thus, to load the
ASDF version provided by the infrastructure:

```
;; SBCL Example
(load (sb-ext:posix-getenv "ASDF"))
```

## Overriding one package: `overrideLispAttrs` {#lisp-overriding-one-package}

### Example {#lisp-overriding-one-package-example}

```nix
sbcl.pkgs.alexandria.overrideLispAttrs (oa: {
  src = pkgs.fetchzip {
    url = "https://example.org";
    hash = "";
  };
})
```

### Required Arguments {#lisp-overriding-one-package-required-arguments}

#### `overridefn`:

A function of one argument that takes an attribute set and returns an attribute
set.

### Return value {#lisp-overriding-one-package-return-value}

A lisp derivation that was build using the provided, different arguments.

## Overlaying packages: `packageOverlays` {#lisp-overlaying-packages}

### Example {#lisp-overlaying-packages-example}

```nix
sbcl.override {
  packageOverlays = self: super: {
    alexandria = pkgs.hello;
  };
}
```

### Required Arguments {#lisp-overlaying-packages-required-arguments}

- `overlayfn`:

A function of two arguments, the new package set and the old one. It should
return the new package set that should we woven into the old one.

### Return value {#lisp-overlaying-packages-return-value}

New Lisp with all occurrences of overlayed packages replaced with the new value;

## Overriding lisp spec: `spec` {#lisp-overriding-lisp-spec}

### Example {#lisp-overriding-lisp-spec-example}

```nix
sbcl.override {
  spec = {
    pkg = pkgs.sbcl_2_1_0;
    flags = "--dynamic-space-size 4096";
    faslExt = "fasl";
    asdf = pkgs.asdf_3_1;
  };
}
```

### Required Arguments {#lisp-overriding-lisp-spec-required-arguments}

- `spec`:

Spec can contain the following attributes:

- pkg (required)
- faslExt (required)
- asdf (required)
- program
- flags

### Return value {#lisp-overriding-lisp-spec-return-value}

New lisp infrastructure that works with the provided lisp implementation and
uses the provided ASDF version.


## Quirks {#lisp-quirks}

- `+` in names are converted to `_plus{_,}`: `cl+ssl`->`cl_plus_ssl`, `alexandria+`->`alexandria_plus`
- `.` to `_dot_`: `iolib.base`->`iolib_dot_base`
- names starting with a number have a `_` prepended (`3d-vectors`->`_3d-vectors`)
