/*

# Updating

To update the list of packages from MELPA,

1. Run `./update-elpa`.
2. Check for evaluation errors:
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

  generateElpa = lib.makeOverridable ({
    generated ? ./elpa-generated.nix
  }: let

    imported = import generated {
      callPackage = pkgs: args: self.callPackage pkgs (args // {
        # Use custom elpa url fetcher with fallback/uncompress
        fetchurl = buildPackages.callPackage ./fetchelpa.nix { };
      });
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
      project = if lib.versionAtLeast self.emacs.version "28"
                then null
                else super.project;
      # Compilation instructions for the Ada executables:
      # https://www.nongnu.org/ada-mode/ada-mode.html#Ada-executables
      ada-mode = super.ada-mode.overrideAttrs (old: {
        # actually unpack source of ada-mode and wisi
        # which are both needed to compile the tools
        # we need at runtime
        dontUnpack = false;
        srcs = [
          super.ada-mode.src
          # ada-mode needs a specific version of wisi, check NEWS or ada-mode's
          # package-requires to find the version to use.
          (pkgs.fetchurl {
            url = "https://elpa.gnu.org/packages/wisi-3.1.3.tar.lz";
            sha256 = "18dwcc0crds7aw466vslqicidlzamf8avn59gqi2g7y2x9k5q0as";
          })
        ];

        sourceRoot = "ada-mode-${self.ada-mode.version}";

        nativeBuildInputs = [
          buildPackages.gnat
          buildPackages.gprbuild
          buildPackages.lzip
        ];

        buildInputs = [
          pkgs.gnatcoll-xref
        ];

        preInstall = ''
          ./build.sh -j$NIX_BUILD_CORES
        '';

        postInstall = ''
          ./install.sh --prefix=$out
        '';

        meta = old.meta // {
          maintainers = [ lib.maintainers.sternenseemann ];
        };
      });
    };

    elpaPackages = super // overrides;

  in elpaPackages // { inherit elpaBuild; });

in generateElpa { }
