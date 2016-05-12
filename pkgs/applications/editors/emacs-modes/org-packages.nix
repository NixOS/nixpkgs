/*

# Updating

To update the list of packages from ELPA,

1. Clone https://github.com/ttuegel/emacs2nix
2. Run `./org-packages.sh` from emacs2nix
3. Copy the new org-packages.json file into Nixpkgs
4. `git commit -m "org-packages $(date -Idate)"`

*/

{ fetchurl, lib, stdenv, texinfo }:

self:

  let

    imported = import ./org-generated.nix {
      inherit (self) callPackage;
    };

    super = imported;

    markBroken = pkg: pkg.override {
      elpaBuild = args: self.elpaBuild (args // {
        meta = (args.meta or {}) // { broken = true; };
      });
    };

    overrides = {
    };

    orgPackages = super // overrides;

  in orgPackages // { inherit orgPackages; }
