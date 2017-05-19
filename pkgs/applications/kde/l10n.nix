{ callPackage, recurseIntoAttrs, lib }:

let

  kdeLocale4 = import ./kde-locale-4.nix;
  kdeLocale5 = import ./kde-locale-5.nix;

in

lib.mapAttrs (name: attr: recurseIntoAttrs attr) {
  ar = {
    qt4 = callPackage (kdeLocale4 "ar" {}) {};
  };
  bg = {
    qt4 = callPackage (kdeLocale4 "bg" {}) {};
  };
  bs = {
    qt4 = callPackage (kdeLocale4 "bs" {}) {};
  };
  ca = {
    qt4 = callPackage (kdeLocale4 "ca" {}) {};
  };
  ca_valencia = {
    qt4 = callPackage (kdeLocale4 "ca_valencia" {}) {};
  };
  cs = {
    qt4 = callPackage (kdeLocale4 "cs" {}) {};
  };
  da = {
    qt4 = callPackage (kdeLocale4 "da" {}) {};
  };
  de = {
    qt4 = callPackage (kdeLocale4 "de" {}) {};
  };
  el = {
    qt4 = callPackage (kdeLocale4 "el" {}) {};
  };
  en_GB = {
    qt4 = callPackage (kdeLocale4 "en_GB" {}) {};
  };
  eo = {
    qt4 = callPackage (kdeLocale4 "eo" {}) {};
  };
  es = {
    qt4 = callPackage (kdeLocale4 "es" {}) {};
  };
  et = {
    qt4 = callPackage (kdeLocale4 "et" {}) {};
  };
  eu = {
    qt4 = callPackage (kdeLocale4 "eu" {}) {};
  };
  fa = {
    qt4 = callPackage (kdeLocale4 "fa" {}) {};
  };
  fi = {
    qt4 = callPackage (kdeLocale4 "fi" {}) {};
  };
  fr = {
    qt4 = callPackage (kdeLocale4 "fr" {}) {};
  };
  ga = {
    qt4 = callPackage (kdeLocale4 "ga" {}) {};
  };
  gl = {
    qt4 = callPackage (kdeLocale4 "gl" {}) {};
  };
  he = {
    qt4 = callPackage (kdeLocale4 "he" {}) {};
  };
  hi = {
    qt4 = callPackage (kdeLocale4 "hi" {}) {};
  };
  hr = {
    qt4 = callPackage (kdeLocale4 "hr" {}) {};
  };
  hu = {
    qt4 = callPackage (kdeLocale4 "hu" {}) {};
  };
  ia = {
    qt4 = callPackage (kdeLocale4 "ia" {}) {};
  };
  id = {
    qt4 = callPackage (kdeLocale4 "id" {}) {};
  };
  is = {
    qt4 = callPackage (kdeLocale4 "is" {}) {};
  };
  it = {
    qt4 = callPackage (kdeLocale4 "it" {}) {};
  };
  ja = {
    qt4 = callPackage (kdeLocale4 "ja" {}) {};
  };
  kk = {
    qt4 = callPackage (kdeLocale4 "kk" {}) {};
  };
  km = {
    qt4 = callPackage (kdeLocale4 "km" {}) {};
  };
  ko = {
    qt4 = callPackage (kdeLocale4 "ko" {}) {};
  };
  lt = {
    qt4 = callPackage (kdeLocale4 "lt" {}) {};
  };
  lv = {
    qt4 = callPackage (kdeLocale4 "lv" {}) {};
  };
  mr = {
    qt4 = callPackage (kdeLocale4 "mr" {}) {};
  };
  nb = {
    qt4 = callPackage (kdeLocale4 "nb" {}) {};
  };
  nds = {
    qt4 = callPackage (kdeLocale4 "nds" {}) {};
  };
  nl = {
    qt4 = callPackage (kdeLocale4 "nl" {}) {};
  };
  nn = {
    qt4 = callPackage (kdeLocale4 "nn" {}) {};
  };
  pa = {
    qt4 = callPackage (kdeLocale4 "pa" {}) {};
  };
  pl = {
    qt4 = callPackage (kdeLocale4 "pl" {}) {};
  };
  pt = {
    qt4 = callPackage (kdeLocale4 "pt" {}) {};
  };
  pt_BR = {
    qt4 = callPackage (kdeLocale4 "pt_BR" {}) {};
  };
  ro = {
    qt4 = callPackage (kdeLocale4 "ro" {}) {};
  };
  ru = {
    qt4 = callPackage (kdeLocale4 "ru" {}) {};
  };
  sk = {
    qt4 = callPackage (kdeLocale4 "sk" {}) {};
  };
  sl = {
    qt4 = callPackage (kdeLocale4 "sl" {}) {};
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
  };
  sv = {
    qt4 = callPackage (kdeLocale4 "sv" {}) {};
  };
  tr = {
    qt4 = callPackage (kdeLocale4 "tr" {}) {};
  };
  ug = {
    qt4 = callPackage (kdeLocale4 "ug" {}) {};
  };
  uk = {
    qt4 = callPackage (kdeLocale4 "uk" {}) {};
  };
  wa = {
    qt4 = callPackage (kdeLocale4 "wa" {}) {};
  };
  zh_CN = {
    qt4 = callPackage (kdeLocale4 "zh_CN" {}) {};
  };
  zh_TW = {
    qt4 = callPackage (kdeLocale4 "zh_TW" {}) {};
  };
}
