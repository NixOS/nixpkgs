{ stdenv, fetchurl, ncurses, pkgconfig, alsaLib, flac, libmad, speex, ffmpeg_0_10, libvorbis, mpc, libsndfile, jackaudio, db, libmodplug, timidity, libid3tag, libtool }:

stdenv.mkDerivation rec {
  name = "moc-${version}";
  version = "2.5.0-beta1";

  src = fetchurl {
    url = "http://ftp.daper.net/pub/soft/moc/unstable/moc-${version}.tar.bz2";
    sha256 = "076816da9c6d1e61a386a1dda5f63ee2fc84bc31e9011ef70acc1d391d4c46a6";
  };

  configurePhase = "./configure prefix=$out";

  buildInputs = [ ncurses pkgconfig alsaLib flac libmad speex ffmpeg_0_10 libvorbis mpc libsndfile jackaudio db libmodplug timidity libid3tag libtool ];

  meta = {
    description = "MOC (music on console) is a console audio player for LINUX/UNIX designed to be powerful and easy to use.";
    homepage = http://moc.daper.net/;
    license = stdenv.lib.licenses.gpl2;
  };
}
