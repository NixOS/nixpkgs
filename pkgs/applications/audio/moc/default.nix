{ stdenv, fetchurl, ncurses, pkgconfig, alsaLib, flac, libmad, speex, ffmpeg
, libvorbis, libmpc, libsndfile, libjack2, db, libmodplug, timidity, libid3tag
, libtool
}:

stdenv.mkDerivation rec {
  name = "moc-${version}";
  version = "2.5.2";

  src = fetchurl {
    url = "http://ftp.daper.net/pub/soft/moc/stable/moc-${version}.tar.bz2";
    sha256 = "026v977kwb0wbmlmf6mnik328plxg8wykfx9ryvqhirac0aq39pk";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    ncurses alsaLib flac libmad speex ffmpeg libvorbis libmpc libsndfile libjack2
    db libmodplug timidity libid3tag libtool
  ];

  meta = with stdenv.lib; {
    description = "An ncurses console audio player designed to be powerful and easy to use";
    homepage = http://moc.daper.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub jagajaga ];
    platforms = platforms.linux;
  };
}
