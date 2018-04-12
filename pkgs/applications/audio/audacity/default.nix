{ stdenv, fetchurl, wxGTK_3, pkgconfig, file, gettext, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad, libjack2, lv2, lilv, serd, sord, sratom, suil, alsaLib, libsndfile, soxr, flac, lame,
  expat, libid3tag, ffmpeg, soundtouch, /*, portaudio - given up fighting their portaudio.patch */
  autoreconfHook, libtool, wrapGAppsHook
  }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.2.2";
  name = "audacity-${version}";

  src = fetchurl {
    url = "https://github.com/audacity/audacity/archive/Audacity-${version}.tar.gz";
    sha256 = "18q7i77ynihx7xp45lz2lv0k0wrh6736pcrivlpwrxjgbvyqx7km";
  };

  configureFlags = [
    "--with-libsamplerate"
  ];

  # audacity only looks for lame and ffmpeg at runtime, so we need to link them in manually
  NIX_LDFLAGS = [
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

  nativeBuildInputs = [ pkgconfig autoreconfHook wrapGAppsHook ];
  buildInputs = [
    gettext wxGTK_3 wxGTK_3.gtk expat alsaLib
    libsndfile soxr libid3tag libjack2 lv2 lilv serd sord sratom suil
    ffmpeg libmad lame libvorbis flac soundtouch
  ]; #ToDo: detach sbsms

  enableParallelBuilding = true;

  dontDisableStatic = true;
  doCheck = false; # Test fails

  meta = with stdenv.lib; {
    description = "Sound editor with graphical UI";
    homepage = http://audacityteam.org/;
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ the-kenny ];
  };
}
