{ stdenv, fetchurl, scons, pkgconfig, qt4, portaudio, portmidi, libusb1
, libmad, protobuf, libvorbis, taglib, libid3tag, flac, libsndfile, libshout
, fftw, vampSDK
}:

stdenv.mkDerivation rec {
  name = "mixxx-${version}";
  version = "1.11.0";

  src = fetchurl {
    url = "http://downloads.mixxx.org/${name}/${name}-src.tar.gz";
    sha256 = "0c833gf4169xvpfn7car9vzvwfwl9d3xwmbfsy36cv8ydifip5h0";
  };

  buildInputs = [
    scons pkgconfig qt4 portaudio portmidi libusb1 libmad protobuf libvorbis
    taglib libid3tag flac libsndfile libshout fftw vampSDK
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
