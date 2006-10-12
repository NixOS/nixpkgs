{ stdenv, fetchurl, pkgconfig, alsaLib, esound, libogg, libvorbis, id3lib
, glib, gtk, libglade
}:

stdenv.mkDerivation {
  name = "bmp-0.9.7.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bmp-0.9.7.1.tar.gz;
    md5 = "c25d5a8d49cc5851d13d525a20023c4c";
  };

  buildInputs = [
    pkgconfig alsaLib esound libogg libvorbis id3lib
    glib gtk libglade
  ];

  meta = {
    description = "Beep Media Player, an XMMS fork";
  };
}
