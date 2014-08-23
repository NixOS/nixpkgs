{ stdenv, fetchurl, ncurses, pkgconfig, alsaLib, flac, libmad, speex, ffmpeg
, libvorbis, mpc, libsndfile, jack2, db, libmodplug, timidity, libid3tag
, libtool
}:

stdenv.mkDerivation rec {
  name = "moc-${version}";
  version = "2.5.0-beta2";

  src = fetchurl {
    url = "http://ftp.daper.net/pub/soft/moc/unstable/moc-${version}.tar.bz2";
    sha256 = "486d50584c3fb0067b8c03af54e44351633a7740b18dc3b7358322051467034c";
  };

  configurePhase = "./configure prefix=$out";

  buildInputs = [
    ncurses pkgconfig alsaLib flac libmad speex ffmpeg libvorbis
    mpc libsndfile jack2 db libmodplug timidity libid3tag libtool
  ];

  meta = {
    description = "MOC (music on console) is a console audio player for LINUX/UNIX designed to be powerful and easy to use.";
    homepage = http://moc.daper.net/;
    license = stdenv.lib.licenses.gpl2;
  };
}
