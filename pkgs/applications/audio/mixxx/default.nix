{ stdenv, fetchFromGitHub, makeWrapper, chromaprint, fetchpatch
, fftw, flac, faad2, glibcLocales, mp4v2
, libid3tag, libmad, libopus, libshout, libsndfile, libusb1, libvorbis
, libGLU, libxcb, lilv, lv2, opusfile
, pkgconfig, portaudio, portmidi, protobuf, qtbase, qtscript, qtsvg
, qtx11extras, rubberband, scons, sqlite, taglib, upower, vampSDK
}:

stdenv.mkDerivation rec {
  name = "mixxx-${version}";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "mixxx";
    rev = "release-${version}";
    sha256 = "1q6c2wfpprsx7s7nz1w0mhm2yhikj54jxcv61kwylxx3n5k2na9r";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    chromaprint fftw flac faad2 glibcLocales mp4v2 libid3tag libmad libopus libshout libsndfile
    libusb1 libvorbis libxcb libGLU lilv lv2 opusfile pkgconfig portaudio portmidi protobuf qtbase qtscript qtsvg
    qtx11extras rubberband scons sqlite taglib upower vampSDK
  ];

  enableParallelBuilding = true;

  sconsFlags = [
    "build=release"
    "qtdir=${qtbase}"
    "faad=1"
    "opus=1"
  ];

  fixupPhase = ''
    wrapProgram $out/bin/mixxx \
      --set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive;
  '';

  meta = with stdenv.lib; {
    homepage = https://mixxx.org;
    description = "Digital DJ mixing software";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.aszlig maintainers.goibhniu maintainers.bfortz ];
    platforms = platforms.linux;
  };
}
