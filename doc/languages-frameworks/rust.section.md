---
title: Rust
author: Matthias Beyer
date: 2017-03-05
---

# Rust

To install the rust compiler and cargo put

```
rustc
cargo
```

into the `environment.systemPackages` or bring them into
scope with `nix-shell -p rustc cargo`.

For daily builds (beta and nightly) use either rustup from
nixpkgs or use the [Rust nightlies
overlay](#using-the-rust-nightlies-overlay).

## Compiling Rust applications with Cargo

Rust applications are packaged by using the `buildRustPackage` helper from `rustPlatform`:

```
rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "11.0.2";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "1iga3320mgi7m853la55xip514a3chqsdi1a1rwv25lr9b1p7vd3";
  };

  cargoSha256 = "17ldqr3asrdcsh4l29m3b5r37r5d0b3npq1lrgjmxb6vlx6a36qh";

  meta = with stdenv.lib; {
    description = "A fast line-oriented regex search tool, similar to ag and ack";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
```

`buildRustPackage` requires a `cargoSha256` attribute which is computed over
all crate sources of this package. Currently it is obtained by inserting a
fake checksum into the expression and building the package once. The correct
checksum can be then take from the failed build.

Per the instructions in the [Cargo Book](https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html)
best practices guide, Rust applications should always commit the `Cargo.lock`
file in git to ensure a reproducible build. However, a few packages do not, and
Nix depends on this file, so if it missing you can use `cargoPatches` to apply
it in the `patchPhase`. Consider sending a PR upstream with a note to the
maintainer describing why it's important to include in the application.

The fetcher will verify that the `Cargo.lock` file is in sync with the `src`
attribute, and fail the build if not. It will also will compress the vendor
directory into a tar.gz archive.

### Building a crate for a different target

To build your crate with a different cargo `--target` simply specify the `target` attribute:

```nix
pkgs.rustPlatform.buildRustPackage {
  (...)
  target = "x86_64-fortanix-unknown-sgx";
}
```

### Running package tests

When using `buildRustPackage`, the `checkPhase` is enabled by default and runs
`cargo test` on the package to build. To make sure that we don't compile the
sources twice and to actually test the artifacts that will be used at runtime,
the tests will be ran in the `release` mode by default.

However, in some cases the test-suite of a package doesn't work properly in the
`release` mode. For these situations, the mode for `checkPhase` can be changed like
so:

```nix
rustPlatform.buildRustPackage {
  /* ... */
  checkType = "debug";
}
```

Please note that the code will be compiled twice here: once in `release` mode
for the `buildPhase`, and again in `debug` mode for the `checkPhase`.

#### Tests relying on the structure of the `target/` directory

Some tests may rely on the structure of the `target/` directory. Those tests
are likely to fail because we use `cargo --target` during the build. This means that
the artifacts
[are stored in `target/<architecture>/release/`](https://doc.rust-lang.org/cargo/guide/build-cache.html),
rather than in `target/release/`.

This can only be worked around by patching the affected tests accordingly.

#### Disabling package-tests

In some instances, it may be necessary to disable testing altogether (with `doCheck = false;`):

* If no tests exist -- the `checkPhase` should be explicitly disabled to skip
  unnecessary build steps to speed up the build.
* If tests are highly impure (e.g. due to network usage).

There will obviously be some corner-cases not listed above where it's sensible to disable tests.
The above are just guidelines, and exceptions may be granted on a case-by-case basis.

However, please check if it's possible to disable a problematic subset of the
test suite and leave a comment explaining your reasoning.

### Building a package in `debug` mode

By default, `buildRustPackage` will use `release` mode for builds. If a package
should be built in `debug` mode, it can be configured like so:

```nix
rustPlatform.buildRustPackage {
  /* ... */
  buildType = "debug";
}
```

In this scenario, the `checkPhase` will be ran in `debug` mode as well.

### Custom `build`/`install`-procedures

Some packages may use custom scripts for building/installing, e.g. with a `Makefile`.
In these cases, it's recommended to override the `buildPhase`/`installPhase`/`checkPhase`.

Otherwise, some steps may fail because of the modified directory structure of `target/`.

### Building a crate with an absent or out-of-date Cargo.lock file

`buildRustPackage` needs a `Cargo.lock` file to get all dependencies in the
source code in a reproducible way. If it is missing or out-of-date one can use
the `cargoPatches` attribute to update or add it.

```
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  (...)
  cargoPatches = [
    # a patch file to add/update Cargo.lock in the source code
    ./add-Cargo.lock.patch
  ];
}
```

## Compiling Rust crates using Nix instead of Cargo

### Simple operation

When run, `cargo build` produces a file called `Cargo.lock`,
containing pinned versions of all dependencies. Nixpkgs contains a
tool called `carnix` (`nix-env -iA nixos.carnix`), which can be used
to turn a `Cargo.lock` into a Nix expression.

That Nix expression calls `rustc` directly (hence bypassing Cargo),
and can be used to compile a crate and all its dependencies. Here is
an example for a minimal `hello` crate:


    $ cargo new hello
    $ cd hello
    $ cargo build
     Compiling hello v0.1.0 (file:///tmp/hello)
      Finished dev [unoptimized + debuginfo] target(s) in 0.20 secs
    $ carnix -o hello.nix --src ./. Cargo.lock --standalone
    $ nix-build hello.nix -A hello_0_1_0

Now, the file produced by the call to `carnix`, called `hello.nix`, looks like:

```
# Generated by carnix 0.6.5: carnix -o hello.nix --src ./. Cargo.lock --standalone
{ lib, stdenv, buildRustCrate, fetchgit }:
let kernel = stdenv.buildPlatform.parsed.kernel.name;
    # ... (content skipped)
in
rec {
  hello = f: hello_0_1_0 { features = hello_0_1_0_features { hello_0_1_0 = f; }; };
  hello_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "hello";
    version = "0.1.0";
    authors = [ "pe@pijul.org <pe@pijul.org>" ];
    src = ./.;
    inherit dependencies buildDependencies features;
  };
  hello_0_1_0 = { features?(hello_0_1_0_features {}) }: hello_0_1_0_ {};
  hello_0_1_0_features = f: updateFeatures f (rec {
        hello_0_1_0.default = (f.hello_0_1_0.default or true);
    }) [ ];
}
```

In particular, note that the argument given as `--src` is copied
verbatim to the source. If we look at a more complicated
dependencies, for instance by adding a single line `libc="*"` to our
`Cargo.toml`, we first need to run `cargo build` to update the
`Cargo.lock`. Then, `carnix` needs to be run again, and produces the
following nix file:

```
# Generated by carnix 0.6.5: carnix -o hello.nix --src ./. Cargo.lock --standalone
{ lib, stdenv, buildRustCrate, fetchgit }:
let kernel = stdenv.buildPlatform.parsed.kernel.name;
    # ... (content skipped)
in
rec {
  hello = f: hello_0_1_0 { features = hello_0_1_0_features { hello_0_1_0 = f; }; };
  hello_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "hello";
    version = "0.1.0";
    authors = [ "pe@pijul.org <pe@pijul.org>" ];
    src = ./.;
    inherit dependencies buildDependencies features;
  };
  libc_0_2_36_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
    crateName = "libc";
    version = "0.2.36";
    authors = [ "The Rust Project Developers" ];
    sha256 = "01633h4yfqm0s302fm0dlba469bx8y6cs4nqc8bqrmjqxfxn515l";
    inherit dependencies buildDependencies features;
  };
  hello_0_1_0 = { features?(hello_0_1_0_features {}) }: hello_0_1_0_ {
    dependencies = mapFeatures features ([ libc_0_2_36 ]);
  };
  hello_0_1_0_features = f: updateFeatures f (rec {
    hello_0_1_0.default = (f.hello_0_1_0.default or true);
    libc_0_2_36.default = true;
  }) [ libc_0_2_36_features ];
  libc_0_2_36 = { features?(libc_0_2_36_features {}) }: libc_0_2_36_ {
    features = mkFeatures (features.libc_0_2_36 or {});
  };
  libc_0_2_36_features = f: updateFeatures f (rec {
    libc_0_2_36.default = (f.libc_0_2_36.default or true);
    libc_0_2_36.use_std =
      (f.libc_0_2_36.use_std or false) ||
      (f.libc_0_2_36.default or false) ||
      (libc_0_2_36.default or false);
  }) [];
}
```

Here, the `libc` crate has no `src` attribute, so `buildRustCrate`
will fetch it from [crates.io](https://crates.io). A `sha256`
attribute is still needed for Nix purity.

### Handling external dependencies

Some crates require external libraries. For crates from
[crates.io](https://crates.io), such libraries can be specified in
`defaultCrateOverrides` package in nixpkgs itself.

Starting from that file, one can add more overrides, to add features
or build inputs by overriding the hello crate in a seperate file.

```
with import <nixpkgs> {};
((import ./hello.nix).hello {}).override {
  crateOverrides = defaultCrateOverrides // {
    hello = attrs: { buildInputs = [ openssl ]; };
  };
}
```

Here, `crateOverrides` is expected to be a attribute set, where the
key is the crate name without version number and the value a function.
The function gets all attributes passed to `buildRustCrate` as first
argument and returns a set that contains all attribute that should be
overwritten.

For more complicated cases, such as when parts of the crate's
derivation depend on the crate's version, the `attrs` argument of
the override above can be read, as in the following example, which
patches the derivation:

```
with import <nixpkgs> {};
((import ./hello.nix).hello {}).override {
  crateOverrides = defaultCrateOverrides // {
    hello = attrs: lib.optionalAttrs (lib.versionAtLeast attrs.version "1.0")  {
      postPatch = ''
        substituteInPlace lib/zoneinfo.rs \
          --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
      '';
    };
  };
}
```

Another situation is when we want to override a nested
dependency. This actually works in the exact same way, since the
`crateOverrides` parameter is forwarded to the crate's
dependencies. For instance, to override the build inputs for crate
`libc` in the example above, where `libc` is a dependency of the main
crate, we could do:

```
with import <nixpkgs> {};
((import hello.nix).hello {}).override {
  crateOverrides = defaultCrateOverrides // {
    libc = attrs: { buildInputs = []; };
  };
}
```

### Options and phases configuration

Actually, the overrides introduced in the previous section are more
general. A number of other parameters can be overridden:

- The version of rustc used to compile the crate:

  ```
  (hello {}).override { rust = pkgs.rust; };
  ```

- Whether to build in release mode or debug mode (release mode by
  default):

  ```
  (hello {}).override { release = false; };
  ```

- Whether to print the commands sent to rustc when building
  (equivalent to `--verbose` in cargo:

  ```
  (hello {}).override { verbose = false; };
  ```

- Extra arguments to be passed to `rustc`:

  ```
  (hello {}).override { extraRustcOpts = "-Z debuginfo=2"; };
  ```

- Phases, just like in any other derivation, can be specified using
  the following attributes: `preUnpack`, `postUnpack`, `prePatch`,
  `patches`, `postPatch`, `preConfigure` (in the case of a Rust crate,
  this is run before calling the "build" script), `postConfigure`
  (after the "build" script),`preBuild`, `postBuild`, `preInstall` and
  `postInstall`. As an example, here is how to create a new module
  before running the build script:

  ```
  (hello {}).override {
    preConfigure = ''
       echo "pub const PATH=\"${hi.out}\";" >> src/path.rs"
    '';
  };
  ```

### Features

One can also supply features switches. For example, if we want to
compile `diesel_cli` only with the `postgres` feature, and no default
features, we would write:

```
(callPackage ./diesel.nix {}).diesel {
  default = false;
  postgres = true;
}
```

Where `diesel.nix` is the file generated by Carnix, as explained above.


## Setting Up `nix-shell`
Oftentimes you want to develop code from within `nix-shell`. Unfortunately
`buildRustCrate` does not support common `nix-shell` operations directly
(see [this issue](https://github.com/NixOS/nixpkgs/issues/37945))
so we will use `stdenv.mkDerivation` instead.

Using the example `hello` project above, we want to do the following:
- Have access to `cargo` and `rustc`
- Have the `openssl` library available to a crate through it's _normal_
  compilation mechanism (`pkg-config`).

A typical `shell.nix` might look like:

```
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "rust-env";
  nativeBuildInputs = [
    rustc cargo

    # Example Build-time Additional Dependencies
    pkgconfig
  ];
  buildInputs = [
    # Example Run-time Additional Dependencies
    openssl
  ];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
}
```

You should now be able to run the following:
```
$ nix-shell --pure
$ cargo build
$ cargo test
```

### Controlling Rust Version Inside `nix-shell`
To control your rust version (i.e. use nightly) from within `shell.nix` (or
other nix expressions) you can use the following `shell.nix`

```
# Latest Nightly
with import <nixpkgs> {};
let src = fetchFromGitHub {
      owner = "mozilla";
      repo = "nixpkgs-mozilla";
      # commit from: 2019-05-15
      rev = "9f35c4b09fd44a77227e79ff0c1b4b6a69dff533";
      sha256 = "18h0nvh55b5an4gmlgfbvwbyqj91bklf1zymis6lbdh75571qaz0";
   };
in
with import "${src.out}/rust-overlay.nix" pkgs pkgs;
stdenv.mkDerivation {
  name = "rust-env";
  buildInputs = [
    # Note: to use use stable, just replace `nightly` with `stable`
    latest.rustChannels.nightly.rust

    # Add some extra dependencies from `pkgs`
    pkgconfig openssl
  ];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
}
```

Now run:
```
$ rustc --version
rustc 1.26.0-nightly (188e693b3 2018-03-26)
```

To see that you are using nightly.


## Using the Rust nightlies overlay

Mozilla provides an overlay for nixpkgs to bring a nightly version of Rust into scope.
This overlay can _also_ be used to install recent unstable or stable versions
of Rust, if desired.

To use this overlay, clone
[nixpkgs-mozilla](https://github.com/mozilla/nixpkgs-mozilla),
and create a symbolic link to the file
[rust-overlay.nix](https://github.com/mozilla/nixpkgs-mozilla/blob/master/rust-overlay.nix)
in the `~/.config/nixpkgs/overlays` directory.

    $ git clone https://github.com/mozilla/nixpkgs-mozilla.git
    $ mkdir -p ~/.config/nixpkgs/overlays
    $ ln -s $(pwd)/nixpkgs-mozilla/rust-overlay.nix ~/.config/nixpkgs/overlays/rust-overlay.nix

The latest version can be installed with the following command:

    $ nix-env -Ai nixos.latest.rustChannels.stable.rust

Or using the attribute with nix-shell:

    $ nix-shell -p nixos.latest.rustChannels.stable.rust

To install the beta or nightly channel, "stable" should be substituted by
"nightly" or "beta", or
use the function provided by this overlay to pull a version based on a
build date.

The overlay automatically updates itself as it uses the same source as
[rustup](https://www.rustup.rs/).
