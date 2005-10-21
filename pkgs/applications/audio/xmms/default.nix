{stdenv, fetchurl, alsaLib, esound, libogg, libvorbis, glib, gtk}:

stdenv.mkDerivation {
  name = "xmms-1.2.10";
  src = fetchurl {
    url = http://www.xmms.org/files/1.2.x/xmms-1.2.10.tar.bz2;
    md5 = "03a85cfc5e1877a2e1f7be4fa1d3f63c" ;
  };

  buildInputs = [alsaLib esound libogg libvorbis glib gtk];
}
