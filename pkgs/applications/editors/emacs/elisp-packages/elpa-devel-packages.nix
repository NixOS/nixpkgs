/*

# Updating

To update the list of packages from ELPA,

1. Run `./update-elpa-devel`.
2. Check for evaluation errors:
     # "../../../../../" points to the default.nix from root of Nixpkgs tree
     env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate ../../../../../ -A emacs.pkgs.elpaDevelPackages
3. Run `git commit -m "elpa-devel-packages $(date -Idate)" -- elpa-devel-generated.nix`

## Update from overlay

Alternatively, run the following command:

./update-from-overlay

It will update both melpa and elpa packages using
https://github.com/nix-community/emacs-overlay. It's almost instantenous and
formats commits for you.

*/

{ lib, stdenv, texinfo, writeText, gcc, pkgs, buildPackages }:

self: let

  markBroken = pkg: pkg.override {
    elpaBuild = args: self.elpaBuild (args // {
      meta = (args.meta or {}) // { broken = true; };
    });
  };

  elpaBuild = import ../../../../build-support/emacs/elpa.nix {
    inherit lib stdenv texinfo writeText gcc;
    inherit (self) emacs;
  };

  # Use custom elpa url fetcher with fallback/uncompress
  fetchurl = buildPackages.callPackage ./fetchelpa.nix { };

  generateElpa = lib.makeOverridable ({
    generated ? ./elpa-devel-generated.nix
  }: let

    imported = import generated {
      callPackage = pkgs: args: self.callPackage pkgs (args // {
        inherit fetchurl;
      });
    };

    super = removeAttrs imported [ "dash" ];

    overrides = {
      eglot = super.eglot.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          local info_file=eglot.info
          pushd $out/share/emacs/site-lisp/elpa/eglot-*
          # specify output info file to override the one defined in eglot.texi
          makeinfo --output=$info_file eglot.texi
          install-info $info_file dir
          popd
        '';
      });

      pq = super.pq.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.postgresql ];
      });

      xeft = super.xeft.overrideAttrs (old: let
        libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
      in {
        dontUnpack = false;

        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.xapian ];
        buildPhase = (old.buildPhase or "") + ''
          $CXX -shared -o xapian-lite${libExt} xapian-lite.cc $NIX_CFLAGS_COMPILE -lxapian
        '';
        postInstall = (old.postInstall or "") + "\n" + ''
          outd=$out/share/emacs/site-lisp/elpa/xeft-*
          install -m444 -t $outd xapian-lite${libExt}
          rm $outd/xapian-lite.cc $outd/emacs-module.h $outd/emacs-module-prelude.h $outd/demo.gif $outd/Makefile
        '';
      });

      # native compilation for tests/seq-tests.el never ends
      # delete tests/seq-tests.el to workaround this
      seq = super.seq.overrideAttrs (old: {
        dontUnpack = false;
        postUnpack = (old.postUnpack or "") + "\n" + ''
          local content_directory=$(echo seq-*)
          rm --verbose $content_directory/tests/seq-tests.el
          src=$PWD/$content_directory.tar
          tar --create --verbose --file=$src $content_directory
        '';
      });
    };

    elpaDevelPackages = super // overrides;

  in elpaDevelPackages // { inherit elpaBuild; });

in (generateElpa { }) // { __attrsFailEvaluation = true; }
