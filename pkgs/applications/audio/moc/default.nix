{ stdenv, fetchurl, ncurses, pkgconfig, alsaLib, flac, libmad, speex, ffmpeg
, libvorbis, mpc, libsndfile, jack2, db, libmodplug, timidity, libid3tag
, libtool
}:

stdenv.mkDerivation rec {
  name = "moc-${version}";
  version = "2.5.0";

  src = fetchurl {
    url = "http://ftp.daper.net/pub/soft/moc/stable/moc-${version}.tar.bz2";
    sha256 = "14b0g9jn12jzxsf292g64dc6frlxv99kaagsasmc8xmg80iab7nj";
  };

  buildInputs = [
    ncurses pkgconfig alsaLib flac libmad speex ffmpeg libvorbis
    mpc libsndfile jack2 db libmodplug timidity libid3tag libtool
  ];

  meta = with stdenv.lib; {
    description = "An ncurses console audio player designed to be powerful and easy to use";
    homepage = http://moc.daper.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub jagajaga ];
    platforms = platforms.linux;
  };
}
