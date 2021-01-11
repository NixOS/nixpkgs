{ lib, stdenv, fetchzip, wxGTK30, pkgconfig, file, gettext,
  libvorbis, libmad, libjack2, lv2, lilv, serd, sord, sratom, suil, alsaLib, libsndfile, soxr, flac, lame,
  expat, libid3tag, ffmpeg_3, soundtouch, /*, portaudio - given up fighting their portaudio.patch */
  cmake
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.4.1";
  pname = "audacity";

  src = fetchzip {
    url = "https://github.com/audacity/audacity/archive/Audacity-${version}.tar.gz";
    sha256 = "1xk0piv72d2xd3p7igr916fhcbrm76fhjr418k1rlqdzzg1hfljn";
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
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

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    file gettext wxGTK30 expat alsaLib
    libsndfile soxr libid3tag libjack2 lv2 lilv serd sord sratom suil wxGTK30.gtk
    ffmpeg_3 libmad lame libvorbis flac soundtouch
  ]; #ToDo: detach sbsms

  dontDisableStatic = true;
  doCheck = false; # Test fails

  meta = with lib; {
    description = "Sound editor with graphical UI";
    homepage = "https://www.audacityteam.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lheckemann ];
    platforms = intersectLists platforms.linux platforms.x86; # fails on ARM
  };
}
