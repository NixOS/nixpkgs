{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, which
, alsa-lib
, bc
, coreutils
, curl
, faust
, flac
, gnutls
, libjack2
, libmicrohttpd
, libogg
, libopus
, libsndfile
, libtasn1
, libvorbis
, libxcb
, llvm_10
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
    sha256 = "sha256-RqtdDkP63l/30sL5PDocvpar5TI4LdKfeeliSNeOHog=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    bc
    coreutils
    curl
    faust
    flac
    gnutls
    libjack2
    libmicrohttpd
    libogg
    libopus
    libsndfile
    libtasn1
    libvorbis
    libxcb
    llvm_10
    p11-kit
    qrencode
    qt5.qtbase
    which
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/FaustLive --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libmicrohttpd libsndfile faust llvm_10 ]}"
  '';

  postPatch = "cd Build";

  meta = with lib; {
    description = "A standalone just-in-time Faust compiler";
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
