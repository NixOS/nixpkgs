{ stdenv, fetchurl, file, mono, gtksharp, gtksourceviewsharp
, gtkmozembedsharp, monodoc
, perl, perlXMLParser, pkgconfig
, glib, gtk, GConf, gnome_vfs, libbonobo, libglade, libgnome
, mozilla, makeWrapper
}:

stdenv.mkDerivation {
  name = "monodevelop-0.6-pre2315";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://nixos.org/tarballs/monodevelop-0.6-pre2315.tar.bz2;
    md5 = "8c33df5629b0676b7ab552854c1de6fd";
  };

  patches = [./prefix.patch];
  
  buildInputs = [
    file mono gtksharp gtksourceviewsharp perl perlXMLParser pkgconfig
    glib gtk GConf gnome_vfs libbonobo libglade libgnome
    gtkmozembedsharp monodoc
  ];
  
  inherit mozilla monodoc gtksharp gtkmozembedsharp gtksourceviewsharp makeWrapper;
}
