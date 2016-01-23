{ stdenv, fetchurl, scons, pkgconfig, qt4, portaudio, portmidi, libusb1
, libmad, protobuf, libvorbis, taglib, libid3tag, flac, libsndfile, libshout
, rubberband, fftw, vampSDK, chromaprint, libopus, sqlite
}:

stdenv.mkDerivation rec {
  name = "mixxx-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "http://downloads.mixxx.org/${name}/${name}-src.tar.gz";
    sha256 = "0vb71w1yq0xwwsclrn2jj9bk8w4n14rfv5c0aw46c11mp8xz7f71";
  };

  buildInputs = [
    scons pkgconfig qt4 portaudio portmidi libusb1 libmad protobuf libvorbis
    taglib libid3tag flac libsndfile libshout rubberband fftw vampSDK chromaprint
    libopus sqlite
  ];

  sconsFlags = [
    "build=release"
    "qtdir=${qt4}"
  ];

  postPatch = ''
    sed -i -e 's/"which /"type -P /' build/depends.py
  '';

  buildPhase = ''
    runHook preBuild
    mkdir -p "$out"
    scons \
      -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES \
      $sconsFlags "prefix=$out"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    scons $sconsFlags "prefix=$out" install
    runHook postInstall
  '';

  meta = {
    homepage = "http://mixxx.org/";
    description = "Digital DJ mixing software";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.aszlig ];
    platforms = stdenv.lib.platforms.linux;
  };
}
