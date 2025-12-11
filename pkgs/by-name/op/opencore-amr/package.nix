{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "opencore-amr";
  version = "0.1.6";
  src = fetchurl {
    url = "mirror://sourceforge/opencore-amr/opencore-amr/opencore-amr-${version}.tar.gz";
    hash = "sha256-SD60BhCI4rNLNY5HVAtdSVqWzUaONhBQ+uYVsYCdxKE=";
  };

  meta = {
    homepage = "https://sourceforge.net/projects/opencore-amr/";
    description = "Library of OpenCORE Framework implementation of Adaptive Multi Rate Narrowband and Wideband (AMR-NB and AMR-WB) speech codec.
    Library of VisualOn implementation of Adaptive Multi Rate Wideband (AMR-WB)";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kiloreux ];
  };
}
