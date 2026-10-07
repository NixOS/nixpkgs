{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  which,
  alsa-lib,
  curl,
  faust,
  flac,
  gnutls,
  libjack2,
  libmicrohttpd,
  libmpg123,
  libogg,
  libopus,
  libsndfile,
  libtasn1,
  libvorbis,
  libxcb,
  llvm,
  p11-kit,
  qrencode,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "faustlive";
  version = "2.5.19";
  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faustlive";
    tag = finalAttrs.version;
    hash = "sha256-IBMgesMkT+0Oh1TjHa+bcSp6YziLNBtNPoUCzbyhMFI=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    faust
    llvm
    pkg-config
    qt5.wrapQtAppsHook
    which
  ];

  buildInputs = [
    alsa-lib
    curl
    faust
    flac
    gnutls
    libjack2
    libmicrohttpd
    libmpg123
    libogg
    libopus
    libsndfile
    libtasn1
    libvorbis
    libxcb
    llvm
    p11-kit
    qrencode
    qt5.qtbase
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
  ];

  postPatch = "cd Build";

  meta = {
    description = "Standalone just-in-time Faust compiler";
    mainProgram = "FaustLive";
    longDescription = ''
      FaustLive is a standalone just-in-time Faust compiler. It tries to bring
      together the convenience of a standalone interpreted language with the
      efficiency of a compiled language. It's ideal for fast prototyping.
    '';
    homepage = "https://faust.grame.fr/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ magnetophon ];
  };
})
