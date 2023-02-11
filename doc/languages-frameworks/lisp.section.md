# Lisp {#lisp}

## Overview {#overview}

The Lisp infrastructure works in the following way:

1. Importing package definitions from Quicklisp
2. Manually defining additional packages and fixing QL ones that don't build
3. Wrapping a CL implementation package with `pkgs` and `withPackages` attributes
4. Overriding packages using `overrideLispAttrs` and `override`

## Importing from Quicklisp {#importing-from-quicklisp}

### The `ql-import` script {#ql-import}

There is a Common Lisp program in the `import` directory, which downloads the
`systems.txt` and `releases.txt` files from `quicklisp.org` and creates a Nix
expression with package definitions in a file called `imported.nix`.

To run this import process, execute:

```sh
$ nix develop
$ sbcl --script ql-import.lisp
```

It also creates a `packages.sqlite` file. It's used during the
generation of the `imported.nix` file and can be safely removed. It
contains the full information of Quicklisp packages, so you can use it
to query the dependency graphs using SQL, if you're interested.

### Choosing a Quicklisp release {#choosing-a-quicklisp-release}

Quicklisp release URL is configured in the `import/main.lisp` file.

Change the `:dist-url` keyword argument to `make-instance 'quicklisp-repository`
before running `ql-import.lisp` to upgrade to a newer release.

## Manually defining packages {#manually-defining-packages}

Packages are declared using `buildASDFSystem`. This function takes
the following arguments and returns a Lisp package derivation.

### Example {#build-asdf-system-example}

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


### Required arguments {#build-asdf-system-required-arguments}

- `pname`
Name of the package/library

- `version`
Version of the package/library

- `src`
Source of the package/library (`fetchTarball`, `fetchGit`, `fetchMercurial` etc.)

### Optional arguments {#build-asdf-system-optional-arguments}

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

### Return value {#build-asdf-system-return-value}

A `derivation` that, when built, contains the sources and pre-compiled
FASL files (Lisp implementation dependent) alongside any other
artifacts generated during compilation.

## Building a Lisp with packages: `withPackages` {#building-a-lisp-with-packages}

### Example {#building-a-lisp-with-packages-example}

`sbcl.withPackages (ps: [ ps.alexandria ])`

### Required Arguments {#building-a-lisp-with-packages-required-arguments}

- `pkgfn`:

A function of one argument that takes an attribute set (containing all the Lisp
packages imported from Quicklisp and declared manually) and returns a list.
    
### Return value {#building-a-lisp-with-return-value}

A lisp derivation that knows how to load some packages with `asdf:load-system`.

### Loading ASDF itself {#loading-asdf-itself}

Path to ASDF itself is put in the `ASDF` environment variable. Thus, to load the
ASDF version provided by the infrastructure:

```
;; SBCL Example
(load (sb-ext:posix-getenv "ASDF"))
```

## Overriding one package: `overrideLispAttrs` {#overriding-one-package}

### Example {#overriding-one-package-example}

```nix
sbcl.pkgs.alexandria.overrideLispAttrs (oa: {
  src = pkgs.fetchzip {
    url = "https://example.org";
    hash = "";
  };
})
```

### Required Arguments {#overriding-one-package-required-arguments}

#### `overridefn`:

A function of one argument that takes an attribute set and returns an attribute
set.
    
### Return value {#overriding-one-package-return-value}

A lisp derivation that was build using the provided, different arguments.

## Overlaying packages: `packageOverlays` {#overlaying-packages}

### Example {#overlaying-packages-example}

```nix
sbcl.override { 
  packageOverlays = self: super: { 
    alexandria = pkgs.hello; 
  }; 
} 
```

### Required Arguments {#overlaying-packages-required-arguments}

- `overlayfn`:

A function of two arguments, the new package set and the old one. It should
return the new package set that should we woven into the old one.
    
### Return value {#overlaying-packages-return-value}

New Lisp with all occurrences of overlayed packages replaced with the new value;

## Overriding lisp spec: `spec` {#overriding-lisp-spec}

### Example {#overriding-lisp-spec-example}

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

### Required Arguments {#overriding-lisp-spec-required-arguments}

- `spec`:

Spec can contain the following attributes:

- pkg (required)
- faslExt (required)
- asdf (required)
- program
- flags
    
### Return value {#overriding-lisp-spec-return-value}

New lisp infrastructure that works with the provided lisp implementation and
uses the provided ASDF version.


## Quirks {#quirks}

- `+` in names are converted to `_plus{_,}`: `cl+ssl`->`cl_plus_ssl`, `alexandria+`->`alexandria_plus`
- `.` to `_dot_`: `iolib.base`->`iolib_dot_base`
- names starting with a number have a `_` prepended (`3d-vectors`->`_3d-vectors`)
