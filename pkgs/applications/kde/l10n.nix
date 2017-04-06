{ callPackage, recurseIntoAttrs, lib }:

let

  kdeLocale4 = import ./kde-locale-4.nix;
  kdeLocale5 = import ./kde-locale-5.nix;

in

lib.mapAttrs (name: attr: recurseIntoAttrs attr) {
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
    qt4 = callPackage (kdeLocale4 "sr" {
      preConfigure = ''
        patchShebangs \
            4/sr/sr@latin/scripts/ts-pmap-compile.py \
            4/sr/scripts/ts-pmap-compile.py \
            4/sr/data/resolve-sr-hybrid \
            4/sr/sr@ijekavian/scripts/ts-pmap-compile.py \
            4/sr/sr@ijekavianlatin/scripts/ts-pmap-compile.py
        '';
    }) {};
    qt5 = callPackage (kdeLocale5 "sr" {
      preConfigure = ''
        patchShebangs 5/sr/cmake_modules/resolve-sr-hybrid
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
}
