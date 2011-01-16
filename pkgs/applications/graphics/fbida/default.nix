{ stdenv, fetchurl, libjpeg, libexif, giflib, libtiff, libpng
, pkgconfig, freetype, fontconfig
}:

stdenv.mkDerivation rec {
  name = "fbida-2.07";
  
  src = fetchurl {
    url = "http://dl.bytesex.org/releases/fbida/${name}.tar.gz";
    sha256 = "0i6v3fvjc305pfw48sglb5f22lwxldmfch6mjhqbcp7lqkkxw435";
  };

  patches =
    [ # Fetch a segfault in exiftran (http://bugs.gentoo.org/284753).
      (fetchurl {
        url = http://bugs.gentoo.org/attachment.cgi?id=203930;
        sha256 = "0zwva6qbahjdzk7vaw7cn3mj0326kawqw58rspvrz9m4vw5kqdzj";
      })
    ];

  buildInputs =
    [ pkgconfig libexif libjpeg giflib libpng giflib freetype fontconfig ];
  
  makeFlags = [ "prefix=$(out)" "verbose=yes" ];

  meta = {
    description = "Image viewing and manipulation programs";
  };
}
