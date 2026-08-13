{
  lib,
  stdenv,
  fetchurl,
  fftwSinglePrec,
  lv2,
  pkg-config,
  wafHook,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mda-lv2";
  version = "1.2.6";

  src = fetchurl {
    url = "https://download.drobilla.net/mda-lv2-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-zWYRcCSuBJzzrKg/npBKcCdyJOI6lp9yqcXQEKSYV9s=";
  };

  nativeBuildInputs = [
    pkg-config
    wafHook
    python3
  ];
  buildInputs = [
    fftwSinglePrec
    lv2
  ];

  meta = {
    homepage = "http://drobilla.net/software/mda-lv2.html";
    description = "LV2 port of the MDA plugins by Paul Kellett";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
