{ stdenv, fetchurl, libjpeg, libexif, giflib, libtiff, libpng
, pkgconfig, freetype, fontconfig
}:

stdenv.mkDerivation rec {
  name = "fbida-2.07";
  
  src = fetchurl {
    url = "http://dl.bytesex.org/releases/fbida/${name}.tar.gz";
    sha256 = "0i6v3fvjc305pfw48sglb5f22lwxldmfch6mjhqbcp7lqkkxw435";
  };

  preBuild =
    ''
      # Fetch a segfault in exiftran (http://bugs.gentoo.org/284753).
      # `fbida' contains a copy of some internal libjpeg source files.
      # If these do not match with the actual libjpeg, exiftran may
      # fail.
      tar xvf ${libjpeg.src}
      for i in jpegint.h jpeglib.h jinclude.h transupp.c transupp.h; do
        cp jpeg-*/$i jpeg/
      done
    '';

  buildInputs =
    [ pkgconfig libexif libjpeg giflib libpng giflib freetype fontconfig ];
  
  makeFlags = [ "prefix=$(out)" "verbose=yes" ];

  crossAttrs = {
    makeFlags = makeFlags ++ [ "CC=${stdenv.cross.config}-gcc" "STRIP="];
  };

  meta = {
    description = "Image viewing and manipulation programs";
  };
}
