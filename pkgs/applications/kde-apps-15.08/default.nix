# Maintainer's Notes:
#
# Minor updates:
#  1. Edit ./manifest.sh to point to the updated URL. Upstream sometimes
#     releases updates that include only the changed packages; in this case,
#     multiple URLs can be provided and the results will be merged.
#  2. Run ./manifest.sh and ./dependencies.sh.
#  3. Build and enjoy.
#
# Major updates:
#  We prefer not to immediately overwrite older versions with major updates, so
#  make a copy of this directory first. After copying, be sure to delete ./tmp
#  if it exists. Then follow the minor update instructions.

{ pkgs, debug ? false }:

let

  inherit (pkgs) lib stdenv;

  srcs = import ./srcs.nix { inherit (pkgs) fetchurl; inherit mirror; };
  mirror = "mirror://kde";

  kdeApp = import ./kde-app.nix {
    inherit stdenv lib;
    inherit debug srcs;
  };

  packages = self: with self; {
    kdelibs = callPackage ./kdelibs { inherit (pkgs) attica phonon; };

    ark = callPackage ./ark.nix {};
    baloo-widgets = callPackage ./baloo-widgets.nix {};
    dolphin = callPackage ./dolphin.nix {};
    dolphin-plugins = callPackage ./dolphin-plugins.nix {};
    ffmpegthumbs = callPackage ./ffmpegthumbs.nix {};
    gpgmepp = callPackage ./gpgmepp.nix {};
    gwenview = callPackage ./gwenview.nix {};
    kate = callPackage ./kate.nix {};
    kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers.nix {};
    kgpg = callPackage ./kgpg.nix { inherit (pkgs.kde4) kdepimlibs; };
    konsole = callPackage ./konsole.nix {};
    ksnapshot = callPackage ./ksnapshot.nix {};
    libkdcraw = callPackage ./libkdcraw.nix {};
    libkexiv2 = callPackage ./libkexiv2.nix {};
    libkipi = callPackage ./libkipi.nix {};
    okular = callPackage ./okular.nix {};
    oxygen-icons = callPackage ./oxygen-icons.nix {};
    print-manager = callPackage ./print-manager.nix {};

    l10n = pkgs.recurseIntoAttrs (import ./l10n.nix { inherit callPackage lib pkgs; });
  };

  newScope = scope: pkgs.kf515.newScope ({ inherit kdeApp; } // scope);

in lib.makeScope newScope packages
