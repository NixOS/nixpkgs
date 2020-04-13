/*

# Updating

To update the list of packages from MELPA,

1. Run `./update-elpa`.
2. Check for evaluation errors: `nix-instantiate ../../../.. -A emacsPackagesNg.elpaPackages`.
3. `git commit -m "elpa-packages $(date -Idate)" -- elpa-generated.nix`

*/

{ lib, stdenv, texinfo }:

self: let

  markBroken = pkg: pkg.override {
    elpaBuild = args: self.elpaBuild (args // {
      meta = (args.meta or {}) // { broken = true; };
    });
  };

  elpaBuild = import ../../../build-support/emacs/elpa.nix {
    inherit lib stdenv texinfo;
    inherit (self) emacs;
  };

  generateElpa = lib.makeOverridable ({
    generated ? ./elpa-generated.nix
  }: let

    imported = import generated {
      inherit (self) callPackage;
    };

    super = removeAttrs imported [ "dash" ];

    overrides = {
      rcirc-menu = markBroken super.rcirc-menu; # Missing file header
      cl-lib = null; # builtin
      tle = null; # builtin
      advice = null; # builtin
      seq = if lib.versionAtLeast self.emacs.version "27"
            then null
            else super.seq;
    };

    elpaPackages = super // overrides;

  in elpaPackages // { inherit elpaBuild; });

in generateElpa { }
