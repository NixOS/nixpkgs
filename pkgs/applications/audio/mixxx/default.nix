{ stdenv, fetchFromGitHub, chromaprint, fetchpatch, fftw, flac, faad2, mp4v2
, libid3tag, libmad, libopus, libshout, libsndfile, libusb1, libvorbis
, pkgconfig, portaudio, portmidi, protobuf, qt4, rubberband, scons, sqlite
, taglib, vampSDK, libebur128, hidapi, opusfile, upower, libjack2, soundtouch, libogg
}:

stdenv.mkDerivation rec {
  name = "mixxx-${version}";
  version = "2.1.0";

# The source is not in the usual location, see:
# https://bugs.launchpad.net/mixxx/+bug/1764840
  src = fetchFromGitHub {
      owner = "mixxxdj";
      repo = "mixxx";
      rev = "release-${version}";
      sha256 = "0mh2slj6c28kkzrir752harsmakn0v9h6hi6rj0yy6hygb5lq1wz";
  };

  buildInputs = [
    chromaprint fftw flac faad2 mp4v2 libid3tag libmad libopus libshout libsndfile
    libusb1 libvorbis pkgconfig portaudio portmidi protobuf qt4
    rubberband scons sqlite taglib vampSDK libebur128 hidapi opusfile upower libjack2 soundtouch libogg
  ];

  sconsFlags = [
    "build=release"
    "qtdir=${qt4}"
    "faad=1"
  ];

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

  meta = with stdenv.lib; {
    homepage = https://mixxx.org;
    description = "Digital DJ mixing software";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.aszlig maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
