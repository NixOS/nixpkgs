{ stdenv, fetchurl, mono, gtksharp, gtksourceviewsharp
, perl, perlXMLParser, pkgconfig
, glib, gconf, gnomevfs, libbonobo}:

stdenv.mkDerivation {
  name = "monodevelop-0.5.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://www.go-mono.com/archive/1.0.5/monodevelop-0.5.1.tar.gz;
    md5 = "d89458a2d909da09b2cc1f37e16d8990";
  };

  buildInputs = [
    mono gtksharp gtksourceviewsharp perl pkgconfig gnomevfs
    glib libbonobo gconf
  ];
  inherit perlXMLParser;
}
