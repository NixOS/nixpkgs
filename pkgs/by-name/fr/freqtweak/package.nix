{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fftwFloat,
  libjack2,
  libsigcxx,
  libxml2,
  wxwidgets_3_2,

}:

stdenv.mkDerivation {
  pname = "freqtweak";
  version = "0.6.1-unstable-2019-08-03";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "essej";
    repo = "freqtweak";
    rev = "d4205337558d36657a4ee6b3afb29358aa18c0fd";
    hash = "sha256-0RXdVXf/IoxCeW11Hpi4oGEOIlSJKkAUKSzn1+oRmIE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    fftwFloat
    libjack2
    libsigcxx
    libxml2
    wxwidgets_3_2
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://essej.net/freqtweak/";
    description = "Realtime audio frequency spectral manipulation";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    mainProgram = "freqtweak";
  };
}
