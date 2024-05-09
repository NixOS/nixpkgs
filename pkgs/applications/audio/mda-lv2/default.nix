{ lib, stdenv, fetchurl, fftwSinglePrec, lv2, pkg-config, wafHook, python3 }:

stdenv.mkDerivation rec {
  pname = "mda-lv2";
  version = "1.2.6";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "sha256-zWYRcCSuBJzzrKg/npBKcCdyJOI6lp9yqcXQEKSYV9s=";
  };

  nativeBuildInputs = [ pkg-config wafHook python3 ];
  buildInputs = [ fftwSinglePrec lv2 ];

  meta = with lib; {
    homepage = "http://drobilla.net/software/mda-lv2.html";
    description = "An LV2 port of the MDA plugins by Paul Kellett";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
