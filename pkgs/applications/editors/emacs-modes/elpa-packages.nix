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
      # upstream issue: missing footer
      ebdb-i18n-chn = markBroken super.ebdb-i18n-chn;
      el-search = markBroken super.el-search; # requires emacs-25
      iterators = markBroken super.iterators; # requires emacs-25
      midi-kbd = markBroken super.midi-kbd; # requires emacs-25
      rcirc-menu = markBroken super.rcirc-menu; # Missing file header
      stream = markBroken super.stream; # requires emacs-25
      cl-lib = null; # builtin
      tle = null; # builtin
      advice = null; # builtin
    };

    elpaPackages = super // overrides;

  in elpaPackages // { inherit elpaBuild; });

in generateElpa { }
