{ stdenv, mkDerivation, fetchFromGitHub, chromaprint
, fftw, flac, faad2, glibcLocales, mp4v2
, libid3tag, libmad, libopus, libshout, libsndfile, libusb1, libvorbis
, libGLU, libxcb, lilv, lv2, opusfile
, pkgconfig, portaudio, portmidi, protobuf, qtbase, qtscript, qtsvg
, qtx11extras, rubberband, scons, sqlite, taglib, upower, vampSDK
}:

mkDerivation rec {
  pname = "mixxx";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "mixxx";
    rev = "release-${version}";
    sha256 = "1h7q25fv62c5m74d4cn1m6mpanmqpbl2wqbch4qvn488jb2jw1dv";
  };

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

  qtWrapperArgs = [
    "--set LOCALE_ARCHIVE ${glibcLocales}/lib/locale/locale-archive"
  ];

  meta = with stdenv.lib; {
    homepage = https://mixxx.org;
    description = "Digital DJ mixing software";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.aszlig maintainers.goibhniu maintainers.bfortz ];
    platforms = platforms.linux;
  };
}
