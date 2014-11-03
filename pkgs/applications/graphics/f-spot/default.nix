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
    url = http://tarballs.nixos.org/f-spot-0.0.10.tar.bz2;
    sha256 = "1hgls6hzvxsnk09j9y6hq10qxsc92i864mdg3gk2cimbkbr0mh8b";
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
