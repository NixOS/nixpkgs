---
title: Rust
author: Matthias Beyer
date: 2017-03-05
---

# User's Guide to the Rust Infrastructure

Rust is packaged with nixpkgs, although there are no rust crates packaged in
nixpkgs.
Therefor, one has to use `cargo` directly.

To install the rust compiler and cargo, one has to put

```
rustStable.rustc
rustStable.cargo
```

into the `environment.systemPackages` or bring them into scope with
`nix-shell -p rustStable.rustc -p rustStable.cargo`.

There are also `rustUnstable` and `rustNightly` package sets available,
though, as nixpkgs does not update the nightlies very often, one should rather
use an alternative approach for installing the nightly version of rust.

## Using Rust nightlies (with an overlay)

Mozilla provides an overlay for nixpkgs which can be used to bring a nightly
version of Rust into scope.
This overlay can _also_ be used to install recent unstable or stable versions
of Rust, if desired.

To use this overlay, clone
[nixpkgs-mozilla](https://github.com/mozilla/nixpkgs-mozilla),
and create a symbolic link to the file
[rust-overlay.nix](https://github.com/mozilla/nixpkgs-mozilla/blob/master/rust-overlay.nix)
in the `~/.config/nixpkgs/overlays` directory.

    $ git clone https://github.com/mozilla/nixpkgs-mozilla.git
    $ mkdir -p  ~/.config/nixpkgs/overlays
    $ ln -s $(pwd)/nixpkgs-mozilla/rust-overlay.nix ~/.config/nixpkgs/overlays/rust-overlay.nix

Once installed, one can install the latest versions with the following command:

    $ nix-env -Ai nixos.rustChannels.stable.rust

Or use this attribute to build a nix-shell environment which pull the
latest version of rust for you when you enter it.

To install the beta or nightly channel, "stable" should be substituted by
"nightly" and "beta", or
use the function provided by this overlay to pull a version based on a
build date.

### How does it work?

This section explains how the overlay works.

This overlay should auto-update it-self as if you were running rustup
each time you go through the rustChannels attributes.  It works by
using the fetchurl builtin function to pull the same file as rustup do
through https.

The `*.toml` manifest file is then parsed (yes,
[in Nix](https://github.com/mozilla/nixpkgs-mozilla/blob/master/lib/parseTOML.nix)
) to extract the sha256 and the location of all the packages indexed by the
manifest file.  Then,
[some logic](https://github.com/mozilla/nixpkgs-mozilla/blob/master/rust-overlay.nix)
is used to convert the `*.toml` file into proper derivations which are used to
pull the prebuilt binaries and to change the interpreter of the binaries using
patchelf.

