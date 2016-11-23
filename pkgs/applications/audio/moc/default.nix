{ stdenv, fetchurl, ncurses, pkgconfig, alsaLib, flac, libmad, speex, ffmpeg
, libvorbis, libmpc, libsndfile, libjack2, db, libmodplug, timidity, libid3tag
, libtool
}:

stdenv.mkDerivation rec {
  name = "moc-${version}";
  version = "2.5.1";

  src = fetchurl {
    url = "http://ftp.daper.net/pub/soft/moc/stable/moc-${version}.tar.bz2";
    sha256 = "1wn4za08z64bhsgfhr9c0crfyvy8c3b6a337wx7gz19am5srqh8v";
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
