{ stdenv, fetchFromGitHub, makeWrapper, chromaprint, fetchpatch
, fftw, flac, faad2, glibcLocales, mp4v2
, libid3tag, libmad, libopus, libshout, libsndfile, libusb1, libvorbis
, libGLU, libxcb, lilv, lv2, opusfile
, pkgconfig, portaudio, portmidi, protobuf, qtbase, qtscript, qtsvg
, qtx11extras, rubberband, scons, sqlite, taglib, upower, vampSDK
}:

stdenv.mkDerivation rec {
  name = "mixxx-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "mixxx";
    rev = "release-${version}";
    sha256 = "1rp2nyhz2j695k5kk0m94x30akwrlr9jgs0n4pi4snnvjpwmbfp9";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    chromaprint fftw flac faad2 glibcLocales mp4v2 libid3tag libmad libopus libshout libsndfile
    libusb1 libvorbis libxcb libGLU lilv lv2 opusfile pkgconfig portaudio portmidi protobuf qtbase qtscript qtsvg
    qtx11extras rubberband scons sqlite taglib upower vampSDK
  ];

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
