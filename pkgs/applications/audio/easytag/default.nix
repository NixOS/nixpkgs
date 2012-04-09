{ stdenv, fetchurl, pkgconfig, gtk, libid3tag, id3lib, libvorbis, libogg, flac }:

let

  version = "2.1.7";
  sha256 = "bfed34cbdce96aca299a0db2b531dbc66feb489b911a34f0a9c67f2eb6ee9301";

in stdenv.mkDerivation {
  name = "easytag-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/easytag/easytag-${version}.tar.bz2";
    inherit sha256;
  };

  buildInputs = [ pkgconfig gtk libid3tag id3lib libvorbis libogg flac ];

  meta = {
    description = "an utility for viewing and editing tags for various audio files";
    homepage = http://http://easytag.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
  };
}