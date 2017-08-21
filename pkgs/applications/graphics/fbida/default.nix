{ stdenv, fetchurl, libjpeg, libexif, libungif, libtiff, libpng, libwebp, libdrm
, pkgconfig, freetype, fontconfig, which, imagemagick, curl, sane-backends, libXpm
, epoxy, poppler, lirc }:

stdenv.mkDerivation rec {
  name = "fbida-2.13";
  
  src = fetchurl {
    url = "http://dl.bytesex.org/releases/fbida/${name}.tar.gz";
    sha256 = "01yv4qqqfbz9v281y2jlxhxdym3ricyb0zkqkgp5b40qrmfik1x8";
  };

  nativeBuildInputs = [ pkgconfig which ];
  buildInputs = [ libexif libjpeg libpng libungif freetype fontconfig libtiff
   libwebp imagemagick curl sane-backends libdrm libXpm epoxy poppler lirc ];
  
  makeFlags = [ "prefix=$(out)" "verbose=yes" "STRIP=" ];

  patchPhase =
    ''
    sed -e 's@ cpp\>@ gcc -E -@' -i GNUmakefile
    '';

  meta = with stdenv.lib; {
    description = "Image viewing and manipulation programs";
    homepage = https://www.kraxel.org/blog/linux/fbida/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
