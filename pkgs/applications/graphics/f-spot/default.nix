{ stdenv, fetchurl, perl, perlXMLParser, pkgconfig, mono, libexif
, libgnome, libgnomeui, gtksharp, libjpeg, sqlite, lcms, libgphoto2
, monoDLLFixer
, makeWrapper
}:

stdenv.mkDerivation {
  name = "f-spot-0.0.10";

  builder = ./builder.sh;
  
  inherit makeWrapper;

  src = fetchurl {
    url = http://nixos.org/tarballs/f-spot-0.0.10.tar.bz2;
    md5 = "19cc6e067ccc261b0502ff6189b79832";
  };

  patches = [./dllmap.patch];

  buildInputs = [
    perl perlXMLParser pkgconfig mono libexif
    libgnome libgnomeui gtksharp libjpeg sqlite
    lcms libgphoto2
  ];

  inherit monoDLLFixer gtksharp sqlite libgnomeui;

  meta = {
    homepage = http://f-spot.org;
  };
}
