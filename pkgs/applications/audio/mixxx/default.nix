{ stdenv, fetchurl, chromaprint, fftw, flac, libid3tag, libmad
, libopus, libshout, libsndfile, libusb1, libvorbis, pkgconfig
, portaudio, portmidi, protobuf, qt4, rubberband, scons, sqlite
, taglib, vampSDK
}:

stdenv.mkDerivation rec {
  name = "mixxx-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "http://downloads.mixxx.org/${name}/${name}-src.tar.gz";
    sha256 = "0vb71w1yq0xwwsclrn2jj9bk8w4n14rfv5c0aw46c11mp8xz7f71";
  };

  patches = [ ./sqlite.patch ]; # from: https://bugs.gentoo.org/show_bug.cgi?id=622776

  buildInputs = [
    chromaprint fftw flac libid3tag libmad libopus libshout libsndfile
    libusb1 libvorbis pkgconfig portaudio portmidi protobuf qt4
    rubberband scons sqlite taglib vampSDK
  ];

  sconsFlags = [
    "build=release"
    "qtdir=${qt4}"
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
