# Scheme {#sec-scheme}

## Package Management {#sec-scheme-package-management}

### Akku {#sec-scheme-package-management-akku}

About two hundred R6RS & R7RS libraries from [Akku](https://akkuscm.org/)
(which also mirrors [snow-fort](https://snow-fort.org/pkg))
are available inside the `akkuPackages` attrset, and the Akku executable
itself is at the top level as `akku`. The packages could be used
in a derivation's `buildInputs`, work inside of `nix-shell`, and
are tested using [Chez](https://www.scheme.com/) &
[Chibi](https://synthcode.com/wiki/chibi-scheme)
Scheme during build time.

Including a package as a build input is done in the typical Nix fashion.
For example, to include
[a bunch of SRFIs](https://akkuscm.org/packages/chez-srfi/)
primarily for Chez Scheme in a derivation, one might write:

```nix
{
  buildInputs = [
    chez
    akkuPackages.chez-srfi
  ];
}

```

The package index is located in `pkgs/tools/package-management/akku`
as `deps.toml`, and should be updated occasionally by running `./update.sh`
in the directory. Doing so will pull the source URLs for new packages and
more recent versions, then write them to the TOML.

