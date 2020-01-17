{ stdenv, fetchzip, wxGTK30, pkgconfig, file, gettext,
  libvorbis, libmad, libjack2, lv2, lilv, serd, sord, sratom, suil, alsaLib, libsndfile, soxr, flac, lame,
  expat, libid3tag, ffmpeg, soundtouch, /*, portaudio - given up fighting their portaudio.patch */
  autoconf, automake, libtool
  }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.3.3";
  pname = "audacity";

  src = fetchzip {
    url = "https://github.com/audacity/audacity/archive/Audacity-${version}.tar.gz";
    sha256 = "0ddc03dbm4ixy877czmwd03fpjgr3y68bxfgb6n2q6cv4prp30ig";
  };

  preConfigure = /* we prefer system-wide libs */ ''
    autoreconf -vi # use system libraries

    # we will get a (possibly harmless) warning during configure without this
    substituteInPlace configure \
      --replace /usr/bin/file ${file}/bin/file
  '';

  configureFlags = [
    "--with-libsamplerate"
  ];

  # audacity only looks for lame and ffmpeg at runtime, so we need to link them in manually
  NIX_LDFLAGS = toString [
    # LAME
    "-lmp3lame"
    # ffmpeg
    "-lavcodec"
    "-lavdevice"
    "-lavfilter"
    "-lavformat"
    "-lavresample"
    "-lavutil"
    "-lpostproc"
    "-lswresample"
    "-lswscale"
  ];

  nativeBuildInputs = [ pkgconfig autoconf automake libtool ];
  buildInputs = [
    file gettext wxGTK30 expat alsaLib
    libsndfile soxr libid3tag libjack2 lv2 lilv serd sord sratom suil wxGTK30.gtk
    ffmpeg libmad lame libvorbis flac soundtouch
  ]; #ToDo: detach sbsms

  enableParallelBuilding = true;

  dontDisableStatic = true;
  doCheck = false; # Test fails

  meta = with stdenv.lib; {
    description = "Sound editor with graphical UI";
    homepage = http://audacityteam.org/;
    license = licenses.gpl2Plus;
    platforms = intersectLists platforms.linux platforms.x86; # fails on ARM
    maintainers = with maintainers; [ the-kenny ];
  };
}
