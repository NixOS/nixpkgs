/*

# Updating

To update the list of packages from ELPA,

1. Clone https://github.com/ttuegel/emacs2nix
2. Run `./elpa-packages.sh` from emacs2nix
3. Copy the new elpa-packages.json file into Nixpkgs
4. `git commit -m "elpa-packages $(date -Idate)"`

*/

{ fetchurl, lib, stdenv, texinfo }:

self:

  let

    imported = import ./elpa-generated.nix {
      inherit (self) callPackage;
    };

    super = removeAttrs imported [ "dash" ];

    elpaBuild = import ../../../build-support/emacs/elpa.nix {
      inherit fetchurl lib stdenv texinfo;
      inherit (self) emacs;
    };

    markBroken = pkg: pkg.override {
      elpaBuild = args: self.elpaBuild (args // {
        meta = (args.meta or {}) // { broken = true; };
      });
    };

    overrides = {
      el-search = markBroken super.el-search; # requires emacs-25
      iterators = markBroken super.iterators; # requires emacs-25
      midi-kbd = markBroken super.midi-kbd; # requires emacs-25
      stream = markBroken super.stream; # requires emacs-25
      cl-lib = null; # builtin
    };

    elpaPackages = super // overrides;

  in elpaPackages // { inherit elpaBuild elpaPackages; }
