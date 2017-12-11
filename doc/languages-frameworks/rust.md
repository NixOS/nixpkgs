---
title: Rust
author: Matthias Beyer
date: 2017-03-05
---

# User's Guide to the Rust Infrastructure

To install the rust compiler and cargo put

```
rust
```

into the `environment.systemPackages` or bring them into
scope with `nix-shell -p rust`.

For daily builds (beta and nightly) use either rustup from
nixpkgs or use the [Rust nightlies
overlay](#using-the-rust-nightlies-overlay).

## Compiling Rust applications with Cargo

Rust applications are packaged by using the `buildRustPackage` helper from `rustPlatform`:

```
with rustPlatform;

buildRustPackage rec {
  name = "ripgrep-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = "${version}";
    sha256 = "0y5d1n6hkw85jb3rblcxqas2fp82h3nghssa4xqrhqnz25l799pj";
  };

  cargoSha256 = "0q68qyl2h6i0qsz82z840myxlnjay8p1w5z7hfyr8fqp7wgwa9cx";

  meta = with stdenv.lib; {
    description = "A utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = https://github.com/BurntSushi/ripgrep;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
```

`buildRustPackage` requires a `cargoSha256` attribute which is computed over
all crate sources of this package. Currently it is obtained by inserting a
fake checksum into the expression and building the package once. The correct
checksum can be then take from the failed build.

To install crates with nix there is also an experimental project called
[nixcrates](https://github.com/fractalide/nixcrates).

## Compiling Rust crates using Nix instead of Cargo

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
    $ nix-build hello.nix

Now, the file produced by the call to `carnix`, called `hello.nix`, looks like:

```
with import <nixpkgs> {};
let release = true;
    verbose = true;
    hello_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "hello";
      version = "0.1.0";
      src = ./.;
      inherit dependencies buildDependencies features release verbose;
    };

in
rec {
  hello_0_1_0 = hello_0_1_0_ {};
}
```

In particular, note that the argument given as `--src` is copied
verbatim to the source.  If we look at a more complicated
dependencies, for instance by adding a single line `libc="*"` to our
`Cargo.toml`, we first need to run `cargo build` to update the
`Cargo.lock`. Then, `carnix` needs to be run again, and produces the
following nix file:

```
with import <nixpkgs> {};
let release = true;
    verbose = true;
    hello_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "hello";
      version = "0.1.0";
      src = ./.;
      inherit dependencies buildDependencies features release verbose;
    };
    libc_0_2_33_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "libc";
      version = "0.2.33";
      sha256 = "1l7synziccnvarsq2kk22vps720ih6chmn016bhr2bq54hblbnl1";
      inherit dependencies buildDependencies features release verbose;
    };

in
rec {
  hello_0_1_0 = hello_0_1_0_ {
    dependencies = [ libc_0_2_33 ];
  };
  libc_0_2_33 = libc_0_2_33_ {
    features = [ "use_std" ];
  };
}
```

Here, the `libc` crate has no `src` attribute, so `buildRustCrate`
will fetch it from [crates.io](https://crates.io). A `sha256`
attribute is still needed for Nix purity.

Some crates require external libraries. For crates from
[crates.io](https://crates.io), such libraries can be specified in
`<nixpkgs/pkgs/build-support/rust/defaultCrateOverrides.nix>`.

Starting from that file, one can add more overrides, to add features
or build inputs, as follows:

```
with import <nixpkgs> {};
let kernel = buildPlatform.parsed.kernel.name;
    abi = buildPlatform.parsed.abi.name;
    helo_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "helo";
      version = "0.1.0";
      authors = [ "pe@pijul.org <pe@pijul.org>" ];
      src = ./.;
      inherit dependencies buildDependencies features;
    };
in
rec {
  helo_0_1_0 = (helo_0_1_0_ {}).override {
    crateOverrides = defaultCrateOverrides // {
      helo = attrs: { buildInputs = [ openssl ]; };
    };
  };
}
```

Here, `crateOverrides` is expected to be a attribute set, where the
key is the crate name without version number and the value a function.
The function gets all attributes passed to `buildRustCrate` as first
argument and returns a set that contains all attribute that should be
overwritten.

For more complicated cases, such as when parts of the crate's
derivation depend on the the crate's version, the `attrs` argument of
the override above can be read, as in the following example, which
patches the derivation:

```
with import <nixpkgs> {};
let kernel = buildPlatform.parsed.kernel.name;
    abi = buildPlatform.parsed.abi.name;
    helo_0_1_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "helo";
      version = "0.1.0";
      authors = [ "pe@pijul.org <pe@pijul.org>" ];
      src = ./.;
      inherit dependencies buildDependencies features;
    };
in
rec {
  helo_0_1_0 = (helo_0_1_0_ {}).override {
    crateOverrides = defaultCrateOverrides // {
      helo = attrs: lib.optionalAttrs (lib.versionAtLeast attrs.version "1.0")  {
        postPatch = ''
          substituteInPlace lib/zoneinfo.rs \
            --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
        '';
      };
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
(import helo.nix).helo_0_1_0.override {
    crateOverrides = defaultCrateOverrides // {
      libc = attrs: { buildInputs = []; };
    };
  };
}
```

Three more parameters can be overridden:

- The version of rustc used to compile the crate:

  ```
  hello_0_1_0.override { rust = pkgs.rust; };
  ```

- Whether to build in release mode or debug mode (release mode by
  default):

  ```
  hello_0_1_0.override { release = false; };
  ```

- Whether to print the commands sent to rustc when building
  (equivalent to `--verbose` in cargo:

  ```
  hello_0_1_0.override { verbose = false; };
  ```


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
