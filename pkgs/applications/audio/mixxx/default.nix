{ stdenv, fetchFromGitHub, makeWrapper, chromaprint, fetchpatch
, fftw, flac, faad2, glibcLocales, mp4v2
, libid3tag, libmad, libopus, libshout, libsndfile, libusb1, libvorbis
, opusfile
, pkgconfig, portaudio, portmidi, protobuf, qt4, rubberband, scons, sqlite
, taglib, upower, vampSDK
}:

stdenv.mkDerivation rec {
  name = "mixxx-${version}";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "mixxxdj";
    repo = "mixxx";
    rev = "release-${version}";
    sha256 = "0h14pwglz03sdmgzviypv1qa1xfjclrnhyqaq5nd60j47h4z39dr";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    chromaprint fftw flac faad2 glibcLocales mp4v2 libid3tag libmad libopus libshout libsndfile
    libusb1 libvorbis opusfile pkgconfig portaudio portmidi protobuf qt4
    rubberband scons sqlite taglib upower vampSDK
  ];

  sconsFlags = [
    "build=release"
    "qtdir=${qt4}"
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
