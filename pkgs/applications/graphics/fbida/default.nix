{ stdenv, fetchurl, libjpeg, libexif, libungif, libtiff, libpng, libwebp
, pkgconfig, freetype, fontconfig, which, imagemagick, curl, sane-backends
}:

stdenv.mkDerivation rec {
  name = "fbida-2.10";
  
  src = fetchurl {
    url = "http://dl.bytesex.org/releases/fbida/${name}.tar.gz";
    sha256 = "1dkc1d6qlfa1gn94wcbyr7ayiy728q52fvbipwmnl2mlc6n3lnks";
  };

  nativeBuildInputs = [ pkgconfig which ];
  buildInputs =
    [ libexif libjpeg libpng libungif freetype fontconfig libtiff libwebp
      imagemagick curl sane-backends
    ];
  
  makeFlags = [ "prefix=$(out)" "verbose=yes" ];

  patchPhase =
    ''
    sed -e 's@ cpp\>@ gcc -E -@' -i GNUmakefile
    '';

  configurePhase = "make config $makeFlags";

  crossAttrs = {
    makeFlags = makeFlags ++ [ "CC=${stdenv.cross.config}-gcc" "STRIP="];
  };

  meta = with stdenv.lib; {
    description = "Image viewing and manipulation programs";
    homepage = https://www.kraxel.org/blog/linux/fbida/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
