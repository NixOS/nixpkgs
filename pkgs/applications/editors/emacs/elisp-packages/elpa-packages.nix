/*

# Updating

To update the list of packages from ELPA,

1. Run `./update-elpa`.
2. Check for evaluation errors:
     # "../../../../../" points to the default.nix from root of Nixpkgs tree
     env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate ../../../../../ -A emacs.pkgs.elpaPackages
3. Run `git commit -m "elpa-packages $(date -Idate)" -- elpa-generated.nix`

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
    generated ? ./elpa-generated.nix
  }: let

    imported = import generated {
      callPackage = pkgs: args: self.callPackage pkgs (args // {
        inherit fetchurl;
      });
    };

    super = removeAttrs imported [ "dash" ];

    overrides = {
      # upstream issue: Wrong type argument: arrayp, nil
      org-transclusion =
        if super.org-transclusion.version == "1.2.0"
        then markBroken super.org-transclusion
        else super.org-transclusion;
      rcirc-menu = markBroken super.rcirc-menu; # Missing file header
      cl-lib = null; # builtin
      cl-print = null; # builtin
      tle = null; # builtin
      advice = null; # builtin
      # Compilation instructions for the Ada executables:
      # https://www.nongnu.org/ada-mode/
      ada-mode = super.ada-mode.overrideAttrs (old: {
        # actually unpack source of ada-mode and wisi
        # which are both needed to compile the tools
        # we need at runtime
        dontUnpack = false;
        srcs = [
          super.ada-mode.src
          self.wisi.src
        ];

        sourceRoot = "ada-mode-${self.ada-mode.version}";

        nativeBuildInputs = [
          buildPackages.gnat
          buildPackages.gprbuild
          buildPackages.dos2unix
          buildPackages.re2c
        ];

        buildInputs = [
          pkgs.gnatPackages.gnatcoll-xref
        ];

        buildPhase = ''
          runHook preBuild
          ./build.sh -j$NIX_BUILD_CORES
          runHook postBuild
        '';

        postInstall = (old.postInstall or "") + "\n" + ''
          ./install.sh "$out"
        '';

        meta = old.meta // {
          maintainers = [ lib.maintainers.sternenseemann ];
        };
      });

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

      jinx = super.jinx.overrideAttrs (old: let
        libExt = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
      in {
        dontUnpack = false;

        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
            pkgs.pkg-config
        ];

        buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.enchant2 ];

        postBuild = ''
          NIX_CFLAGS_COMPILE="$($PKG_CONFIG --cflags enchant-2) $NIX_CFLAGS_COMPILE"
          $CC -shared -o jinx-mod${libExt} jinx-mod.c -lenchant-2
        '';

        postInstall = (old.postInstall or "") + "\n" + ''
          outd=$out/share/emacs/site-lisp/elpa/jinx-*
          install -m444 -t $outd jinx-mod${libExt}
          rm $outd/jinx-mod.c $outd/emacs-module.h
        '';

        meta = old.meta // {
          maintainers = [ lib.maintainers.DamienCassou ];
        };
      });

      plz = super.plz.overrideAttrs (
        old: {
          dontUnpack = false;
          postPatch = old.postPatch or "" + ''
            substituteInPlace ./plz.el \
              --replace 'plz-curl-program "curl"' 'plz-curl-program "${pkgs.curl}/bin/curl"'
          '';
          preInstall = ''
            tar -cf "$pname-$version.tar" --transform "s,^,$pname-$version/," * .[!.]*
            src="$pname-$version.tar"
          '';
        }
      );

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

    elpaPackages = super // overrides;

  in elpaPackages // { inherit elpaBuild; });

in (generateElpa { }) // { __attrsFailEvaluation = true; }
