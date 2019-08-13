{ stdenv, fetchurl, libjpeg, libexif, libungif, libtiff, libpng, libwebp, libdrm
, pkgconfig, freetype, fontconfig, which, imagemagick, curl, sane-backends, libXpm
, epoxy, poppler, mesa, lirc }:

stdenv.mkDerivation rec {
  name = "fbida-2.14";

  src = fetchurl {
    url = "http://dl.bytesex.org/releases/fbida/${name}.tar.gz";
    sha256 = "0f242mix20rgsqz1llibhsz4r2pbvx6k32rmky0zjvnbaqaw1dwm";
  };

  nativeBuildInputs = [ pkgconfig which ];
  buildInputs = [
    libexif libjpeg libpng libungif freetype fontconfig libtiff libwebp
    imagemagick curl sane-backends libdrm libXpm epoxy poppler lirc
    mesa
  ];

  makeFlags = [ "prefix=$(out)" "verbose=yes" "STRIP=" "JPEG_VER=62" ];

  patchPhase = ''
    sed -e 's@ cpp\>@ gcc -E -@' -i GNUmakefile
    sed -e 's@$(HAVE_LINUX_FB_H)@yes@' -i GNUmakefile
  '';

  meta = with stdenv.lib; {
    description = "Image viewing and manipulation programs";
    homepage = https://www.kraxel.org/blog/linux/fbida/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
