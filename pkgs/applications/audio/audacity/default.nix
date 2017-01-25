{ stdenv, fetchurl, wxGTK30, pkgconfig, file, gettext, gtk2, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad, libjack2, lv2, lilv, serd, sord, sratom, suil, alsaLib, libsndfile, soxr, flac, lame, fetchpatch,
  expat, libid3tag, ffmpeg, soundtouch /*, portaudio - given up fighting their portaudio.patch */
  }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.1.2";
  name = "audacity-${version}";

  src = fetchurl {
    url = "https://github.com/audacity/audacity/archive/Audacity-${version}.tar.gz";
    sha256 = "1ggr6g0mk36rqj7ahsg8b0b1r9kphwajzvxgn43md263rm87n04h";
  };
  patches = [(fetchpatch {
    name = "new-ffmpeg.patch";
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk"
      + "/audacity-ffmpeg.patch?h=packages/audacity&id=0c1e35798d4d70692";
    sha256 = "19fr674mw844zmkp1476yigkcnmb6zyn78av64ccdwi3p68i00rf";
  })];

  preConfigure = /* we prefer system-wide libs */ ''
    mv lib-src lib-src-rm
    mkdir lib-src
    mv lib-src-rm/{Makefile*,lib-widget-extra,portaudio-v19,portmixer,portsmf,FileDialog,sbsms,libnyquist} lib-src/
    rm -r lib-src-rm/

    # we will get a (possibly harmless) warning during configure without this
    substituteInPlace configure \
      --replace /usr/bin/file ${file}/bin/file
  '';

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

  buildInputs = [
    pkgconfig file gettext wxGTK30 expat alsaLib
    libsndfile soxr libid3tag libjack2 lv2 lilv serd sord sratom suil gtk2
    ffmpeg libmad lame libvorbis flac soundtouch
  ]; #ToDo: detach sbsms

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
