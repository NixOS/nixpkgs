{ stdenv, mkDerivation, fetchurl, fetchFromGitHub, chromaprint
, fftw, flac, faad2, glibcLocales, mp4v2
, libid3tag, libmad, libopus, libshout, libsndfile, libusb1, libvorbis
, libGLU, libxcb, lilv, lv2, opusfile
, pkgconfig, portaudio, portmidi, protobuf, qtbase, qtscript, qtsvg
, qtx11extras, rubberband, scons, sqlite, taglib, upower, vamp-plugin-sdk
}:

let
  # Because libshout 2.4.2 and newer seem to break streaming in mixxx, build it
  # with 2.4.1 instead.
  libshout241 = libshout.overrideAttrs (o: rec {
    name = "libshout-2.4.1";
    src = fetchurl {
      url = "http://downloads.xiph.org/releases/libshout/${name}.tar.gz";
      sha256 = "0kgjpf8jkgyclw11nilxi8vyjk4s8878x23qyxnvybbgqbgbib7k";
    };
  });
in
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
    chromaprint fftw flac faad2 glibcLocales mp4v2 libid3tag libmad libopus libshout241 libsndfile
    libusb1 libvorbis libxcb libGLU lilv lv2 opusfile pkgconfig portaudio portmidi protobuf qtbase qtscript qtsvg
    qtx11extras rubberband scons sqlite taglib upower vamp-plugin-sdk
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
