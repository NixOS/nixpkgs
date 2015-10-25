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

  kdeLocale4 = name: args:
    { kdeApp, automoc4, cmake, gettext, kdelibs, perl }:

    kdeApp (args // {
      sname = "kde-l10n-${name}";
      name = "kde-l10n-${name}-qt4";

      nativeBuildInputs =
        [ automoc4 cmake gettext perl ]
        ++ (args.nativeBuildInputs or []);
      buildInputs =
        [ kdelibs ]
        ++ (args.buildInputs or []);

      preConfigure = ''
        sed -e 's/add_subdirectory(5)//' -i CMakeLists.txt
        ${args.preConfigure or ""}
      '';
    });

  kdeLocale5 = name: args:
    { kdeApp, cmake, extra-cmake-modules, gettext, kdoctools }:

    kdeApp (args // {
      sname = "kde-l10n-${name}";
      name = "kde-l10n-${name}-qt5";

      nativeBuildInputs =
        [ cmake extra-cmake-modules gettext kdoctools ]
        ++ (args.nativeBuildInputs or []);

      preConfigure = ''
        sed -e 's/add_subdirectory(4)//' -i CMakeLists.txt
        ${args.preConfigure or ""}
      '';
    });

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

    l10n = lib.mapAttrs (name: attr: pkgs.recurseIntoAttrs attr) {
      ar = {
        qt4 = callPackage (kdeLocale4 "ar" {}) {};
        qt5 = callPackage (kdeLocale5 "ar" {}) {};
      };
      bg = {
        qt4 = callPackage (kdeLocale4 "bg" {}) {};
        qt5 = callPackage (kdeLocale5 "bg" {}) {};
      };
      bs = {
        qt4 = callPackage (kdeLocale4 "bs" {}) {};
        qt5 = callPackage (kdeLocale5 "bs" {}) {};
      };
      ca = {
        qt4 = callPackage (kdeLocale4 "ca" {}) {};
        qt5 = callPackage (kdeLocale5 "ca" {}) {};
      };
      ca_valencia = {
        qt4 = callPackage (kdeLocale4 "ca_valencia" {}) {};
        qt5 = callPackage (kdeLocale5 "ca_valencia" {}) {};
      };
      cs = {
        qt4 = callPackage (kdeLocale4 "cs" {}) {};
        qt5 = callPackage (kdeLocale5 "cs" {}) {};
      };
      da = {
        qt4 = callPackage (kdeLocale4 "da" {}) {};
        qt5 = callPackage (kdeLocale5 "da" {}) {};
      };
      de = {
        qt4 = callPackage (kdeLocale4 "de" {}) {};
        qt5 = callPackage (kdeLocale5 "de" {}) {};
      };
      el = {
        qt4 = callPackage (kdeLocale4 "el" {}) {};
        qt5 = callPackage (kdeLocale5 "el" {}) {};
      };
      en_GB = {
        qt4 = callPackage (kdeLocale4 "en_GB" {}) {};
        qt5 = callPackage (kdeLocale5 "en_GB" {}) {};
      };
      eo = {
        qt4 = callPackage (kdeLocale4 "eo" {}) {};
        qt5 = callPackage (kdeLocale5 "eo" {}) {};
      };
      es = {
        qt4 = callPackage (kdeLocale4 "es" {}) {};
        qt5 = callPackage (kdeLocale5 "es" {}) {};
      };
      et = {
        qt4 = callPackage (kdeLocale4 "et" {}) {};
        qt5 = callPackage (kdeLocale5 "et" {}) {};
      };
      eu = {
        qt4 = callPackage (kdeLocale4 "eu" {}) {};
        qt5 = callPackage (kdeLocale5 "eu" {}) {};
      };
      fa = {
        qt4 = callPackage (kdeLocale4 "fa" {}) {};
        qt5 = callPackage (kdeLocale5 "fa" {}) {};
      };
      fi = {
        qt4 = callPackage (kdeLocale4 "fi" {}) {};
        qt5 = callPackage (kdeLocale5 "fi" {}) {};
      };
      fr = {
        qt4 = callPackage (kdeLocale4 "fr" {}) {};
        qt5 = callPackage (kdeLocale5 "fr" {}) {};
      };
      ga = {
        qt4 = callPackage (kdeLocale4 "ga" {}) {};
        qt5 = callPackage (kdeLocale5 "ga" {}) {};
      };
      gl = {
        qt4 = callPackage (kdeLocale4 "gl" {}) {};
        qt5 = callPackage (kdeLocale5 "gl" {}) {};
      };
      he = {
        qt4 = callPackage (kdeLocale4 "he" {}) {};
        qt5 = callPackage (kdeLocale5 "he" {}) {};
      };
      hi = {
        qt4 = callPackage (kdeLocale4 "hi" {}) {};
        qt5 = callPackage (kdeLocale5 "hi" {}) {};
      };
      hr = {
        qt4 = callPackage (kdeLocale4 "hr" {}) {};
        qt5 = callPackage (kdeLocale5 "hr" {}) {};
      };
      hu = {
        qt4 = callPackage (kdeLocale4 "hu" {}) {};
        qt5 = callPackage (kdeLocale5 "hu" {}) {};
      };
      ia = {
        qt4 = callPackage (kdeLocale4 "ia" {}) {};
        qt5 = callPackage (kdeLocale5 "ia" {}) {};
      };
      id = {
        qt4 = callPackage (kdeLocale4 "id" {}) {};
        qt5 = callPackage (kdeLocale5 "id" {}) {};
      };
      is = {
        qt4 = callPackage (kdeLocale4 "is" {}) {};
        qt5 = callPackage (kdeLocale5 "is" {}) {};
      };
      it = {
        qt4 = callPackage (kdeLocale4 "it" {}) {};
        qt5 = callPackage (kdeLocale5 "it" {}) {};
      };
      ja = {
        qt4 = callPackage (kdeLocale4 "ja" {}) {};
        qt5 = callPackage (kdeLocale5 "ja" {}) {};
      };
      kk = {
        qt4 = callPackage (kdeLocale4 "kk" {}) {};
        qt5 = callPackage (kdeLocale5 "kk" {}) {};
      };
      km = {
        qt4 = callPackage (kdeLocale4 "km" {}) {};
        qt5 = callPackage (kdeLocale5 "km" {}) {};
      };
      ko = {
        qt4 = callPackage (kdeLocale4 "ko" {}) {};
        qt5 = callPackage (kdeLocale5 "ko" {}) {};
      };
      lt = {
        qt4 = callPackage (kdeLocale4 "lt" {}) {};
        qt5 = callPackage (kdeLocale5 "lt" {}) {};
      };
      lv = {
        qt4 = callPackage (kdeLocale4 "lv" {}) {};
        qt5 = callPackage (kdeLocale5 "lv" {}) {};
      };
      mr = {
        qt4 = callPackage (kdeLocale4 "mr" {}) {};
        qt5 = callPackage (kdeLocale5 "mr" {}) {};
      };
      nb = {
        qt4 = callPackage (kdeLocale4 "nb" {}) {};
        qt5 = callPackage (kdeLocale5 "nb" {}) {};
      };
      nds = {
        qt4 = callPackage (kdeLocale4 "nds" {}) {};
        qt5 = callPackage (kdeLocale5 "nds" {}) {};
      };
      nl = {
        qt4 = callPackage (kdeLocale4 "nl" {}) {};
        qt5 = callPackage (kdeLocale5 "nl" {}) {};
      };
      nn = {
        qt4 = callPackage (kdeLocale4 "nn" {}) {};
        qt5 = callPackage (kdeLocale5 "nn" {}) {};
      };
      pa = {
        qt4 = callPackage (kdeLocale4 "pa" {}) {};
        qt5 = callPackage (kdeLocale5 "pa" {}) {};
      };
      pl = {
        qt4 = callPackage (kdeLocale4 "pl" {}) {};
        qt5 = callPackage (kdeLocale5 "pl" {}) {};
      };
      pt = {
        qt4 = callPackage (kdeLocale4 "pt" {}) {};
        qt5 = callPackage (kdeLocale5 "pt" {}) {};
      };
      pt_BR = {
        qt4 = callPackage (kdeLocale4 "pt_BR" {}) {};
        qt5 = callPackage (kdeLocale5 "pt_BR" {}) {};
      };
      ro = {
        qt4 = callPackage (kdeLocale4 "ro" {}) {};
        qt5 = callPackage (kdeLocale5 "ro" {}) {};
      };
      ru = {
        qt4 = callPackage (kdeLocale4 "ru" {}) {};
        qt5 = callPackage (kdeLocale5 "ru" {}) {};
      };
      sk = {
        qt4 = callPackage (kdeLocale4 "sk" {}) {};
        qt5 = callPackage (kdeLocale5 "sk" {}) {};
      };
      sl = {
        qt4 = callPackage (kdeLocale4 "sl" {}) {};
        qt5 = callPackage (kdeLocale5 "sl" {}) {};
      };
      sr = {
        qt4 = callPackage (kdeLocale4 "sr" {}) {};
        qt5 = callPackage (kdeLocale5 "sr" {
          preConfigure = ''
            sed -e 's/add_subdirectory(kdesdk)//' -i 5/sr/data/CMakeLists.txt
          '';
        }) {};
      };
      sv = {
        qt4 = callPackage (kdeLocale4 "sv" {}) {};
        qt5 = callPackage (kdeLocale5 "sv" {}) {};
      };
      tr = {
        qt4 = callPackage (kdeLocale4 "tr" {}) {};
        qt5 = callPackage (kdeLocale5 "tr" {}) {};
      };
      ug = {
        qt4 = callPackage (kdeLocale4 "ug" {}) {};
        qt5 = callPackage (kdeLocale5 "ug" {}) {};
      };
      uk = {
        qt4 = callPackage (kdeLocale4 "uk" {}) {};
        qt5 = callPackage (kdeLocale5 "uk" {}) {};
      };
      wa = {
        qt4 = callPackage (kdeLocale4 "wa" {}) {};
        qt5 = callPackage (kdeLocale5 "wa" {}) {};
      };
      zh_CN = {
        qt4 = callPackage (kdeLocale4 "zh_CN" {}) {};
        qt5 = callPackage (kdeLocale5 "zh_CN" {}) {};
      };
      zh_TW = {
        qt4 = callPackage (kdeLocale4 "zh_TW" {}) {};
        qt5 = callPackage (kdeLocale5 "zh_TW" {}) {};
      };
    };
  };

  newScope = scope: pkgs.kf515.newScope ({ inherit kdeApp; } // scope);

in lib.makeScope newScope packages
