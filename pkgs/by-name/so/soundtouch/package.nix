{
  stdenv,
  lib,
  fetchFromCodeberg,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soundtouch";
  version = "2.4.1";

  src = fetchFromCodeberg {
    owner = "soundtouch";
    repo = "soundtouch";
    rev = finalAttrs.version;
    hash = "sha256-srSeFykj6jxAO2OaFCgA8J7SbD2REOKtRp3V17bCFQI=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  preConfigure = "./bootstrap";

  enableParallelBuilding = true;

  meta = {
    description = "Program and library for changing the tempo, pitch and playback rate of audio";
    homepage = "https://www.surina.net/soundtouch/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    mainProgram = "soundstretch";
    platforms = lib.platforms.all;
  };
})
