{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, which
, alsa-lib
, curl
, faust
, flac
, gnutls
, libjack2
, libmicrohttpd
, libmpg123
, libogg
, libopus
, libsndfile
, libtasn1
, libvorbis
, libxcb
, llvm
, p11-kit
, qrencode
, qt5
}:

stdenv.mkDerivation rec {
  pname = "faustlive";
  version = "2.5.17";
  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faustlive";
    rev = version;
    hash = "sha256-RqtdDkP63l/30sL5PDocvpar5TI4LdKfeeliSNeOHog=";
    fetchSubmodules = true;
  };

  patches = [
    # move mutex initialization outside assert call
    # https://github.com/grame-cncm/faustlive/pull/59
    (fetchpatch {
      name = "initalize-mutexes.patch";
      url = "https://github.com/grame-cncm/faustlive/commit/fdd46b12202def9731b9ed2f6363287af16be892.patch";
      hash = "sha256-yH95Y4Jbqgs8siE9rtutmu5C2sNZwQMJzCgDYqNBDj4=";
    })
  ];

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

  meta = with lib; {
    description = "Standalone just-in-time Faust compiler";
    mainProgram = "FaustLive";
    longDescription = ''
      FaustLive is a standalone just-in-time Faust compiler. It tries to bring
      together the convenience of a standalone interpreted language with the
      efficiency of a compiled language. It's ideal for fast prototyping.
    '';
    homepage = "https://faust.grame.fr/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ magnetophon ];
  };
}
