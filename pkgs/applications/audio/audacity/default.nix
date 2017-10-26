{ stdenv, fetchurl, wxGTK30, pkgconfig, file, gettext, gtk2, glib, zlib, perl, intltool,
  libogg, libvorbis, libmad, libjack2, lv2, lilv, serd, sord, sratom, suil, alsaLib, libsndfile, soxr, flac, lame, fetchpatch,
  expat, libid3tag, ffmpeg, soundtouch, /*, portaudio - given up fighting their portaudio.patch */
  autoconf, automake, libtool
  }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.1.3";
  name = "audacity-${version}";

  src = fetchurl {
    url = "https://github.com/audacity/audacity/archive/Audacity-${version}.tar.gz";
    sha256 = "11mx7gb4dbqrgfp7hm0154x3m76ddnmhf2675q5zkxn7jc5qfc6b";
  };
  patches = [
    (fetchpatch {
      name = "new-ffmpeg.patch";
      url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk"
        + "/audacity-ffmpeg.patch?h=packages/audacity&id=0c1e35798d4d70692";
      sha256 = "19fr674mw844zmkp1476yigkcnmb6zyn78av64ccdwi3p68i00rf";
    })
  ];

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

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    file gettext wxGTK30 expat alsaLib
    libsndfile soxr libid3tag libjack2 lv2 lilv serd sord sratom suil gtk2
    ffmpeg libmad lame libvorbis flac soundtouch
    autoconf automake libtool # for the preConfigure phase
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
