{ stdenv, fetchurl, file, mono, gtksharp, gtksourceviewsharp
, gtkmozembedsharp, monodoc
, perl, perlXMLParser, pkgconfig
, glib, gtk, gconf, gnomevfs, libbonobo, libglade, libgnome
}:

stdenv.mkDerivation {
  name = "monodevelop-0.6-pre2315";
  builder = ./builder.sh;

  src = /home/eelco/monodevelop-0.6-pre2315.tar.bz2;

  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;
  
  patches = [./prefix.patch];
  
  buildInputs = [
    file mono gtksharp gtksourceviewsharp perl pkgconfig
    glib gtk gconf gnomevfs libbonobo libglade libgnome
    gtkmozembedsharp monodoc
  ];
  
  inherit perlXMLParser monodoc gtksharp gtkmozembedsharp gtksourceviewsharp;
}
