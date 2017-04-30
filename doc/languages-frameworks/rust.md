---
title: Rust
author: Matthias Beyer
date: 2017-03-05
---

# User's Guide to the Rust Infrastructure

To install the rust compiler and cargo put

```
rustStable.rustc
rustStable.cargo
```

into the `environment.systemPackages` or bring them into scope with
`nix-shell -p rustStable.rustc -p rustStable.cargo`.

There are also `rustBeta` and `rustNightly` package sets available.
These are not updated very regulary. For daily builds use either rustup from
nixpkgs or use the [Rust nightlies overlay](#using-the-rust-nightlies-overlay).

## Packaging Rust applications

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

  depsSha256 = "0q68qyl2h6i0qsz82z840myxlnjay8p1w5z7hfyr8fqp7wgwa9cx";

  meta = with stdenv.lib; {
    description = "A utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = https://github.com/BurntSushi/ripgrep;
    license = with licenses; [ unlicense ];
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
```

`buildRustPackage` requires a `depsSha256` attribute which is computed over
all crate sources of this package. Currently it is obtained by inserting a
fake checksum into the expression and building the package once. The correct
checksum can be then take from the failed build.

To install crates with nix there is also an experimental project called
[nixcrates](https://github.com/fractalide/nixcrates).

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

    $ nix-env -Ai nixos.rustChannels.stable.rust

Or using the attribute with nix-shell:

    $ nix-shell -p nixos.rustChannels.stable.rust

To install the beta or nightly channel, "stable" should be substituted by
"nightly" or "beta", or
use the function provided by this overlay to pull a version based on a
build date.

The overlay automatically updates itself as it uses the same source as
[rustup](https://www.rustup.rs/).
