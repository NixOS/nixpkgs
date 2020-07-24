{ stdenv, fetchzip, wxGTK31, pkgconfig, file, gettext,
  libvorbis, libmad, libjack2, lv2, lilv, serd, sord, sratom, suil, alsaLib, libsndfile, soxr, flac, lame,
  expat, libid3tag, ffmpeg_3, soundtouch, /*, portaudio - given up fighting their portaudio.patch */
  pcre, vamp-plugin-sdk, portmidi, twolame, git,
  cmake, libtool
  }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.4.2";
  pname = "audacity";

  src = fetchzip {
    url = "https://github.com/audacity/audacity/archive/Audacity-${version}.tar.gz";
    sha256 = "0lklcvqkxrr2gkb9gh3422iadzl2rv9v0a8s76rwq43lj2im7546";
  };

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

  nativeBuildInputs = [ pkgconfig cmake libtool git ];
  buildInputs = [
    file gettext wxGTK31 expat alsaLib
    libsndfile soxr libid3tag libjack2 lv2 lilv serd sord sratom suil wxGTK31.gtk
    ffmpeg_3 libmad lame libvorbis flac soundtouch
    pcre vamp-plugin-sdk portmidi twolame
  ]; #ToDo: detach sbsms

  enableParallelBuilding = true;

  dontDisableStatic = true;
  doCheck = false; # Test fails

  meta = with stdenv.lib; {
    description = "Sound editor with graphical UI";
    homepage = "http://audacityteam.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lheckemann ];
    platforms = intersectLists platforms.linux platforms.x86; # fails on ARM
  };
}
