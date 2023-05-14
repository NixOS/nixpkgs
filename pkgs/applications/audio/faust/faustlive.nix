{ lib, stdenv, fetchFromGitHub
, llvm_10, qt5, qrencode, libmicrohttpd, libjack2, alsa-lib, faust, curl
, bc, coreutils, which, libsndfile, flac, libogg, libvorbis, libopus, pkg-config, libxcb, cmake, gnutls, libtasn1, p11-kit
}:

stdenv.mkDerivation rec {
  pname = "faustlive";
  version = "2.5.13";
  src = fetchFromGitHub {
    owner = "grame-cncm";
    repo = "faustlive";
    rev = version;
    sha256 = "sha256-Tgb9UYj8mI4JsxA/PaTokm2NzQ14P8cOdKK8KCcnSIQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config qt5.wrapQtAppsHook cmake ];

  buildInputs = [
    llvm_10 qt5.qtbase qrencode libmicrohttpd libjack2 alsa-lib faust curl
    bc coreutils which libsndfile flac libogg libvorbis libopus libxcb gnutls libtasn1 p11-kit
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
