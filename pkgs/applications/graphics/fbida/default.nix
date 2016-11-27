{ stdenv, fetchurl, libjpeg, libexif, libungif, libtiff, libpng, libwebp, libdrm
, pkgconfig, freetype, fontconfig, which, imagemagick, curl, sane-backends, libXpm
, epoxy, poppler }:

stdenv.mkDerivation rec {
  name = "fbida-2.12";
  
  src = fetchurl {
    url = "http://dl.bytesex.org/releases/fbida/${name}.tar.gz";
    sha256 = "0bw224vb7jh0lrqaf4jgxk48xglvxs674qcpj5y0axyfbh896cfk";
  };

  nativeBuildInputs = [ pkgconfig which ];
  buildInputs = [ libexif libjpeg libpng libungif freetype fontconfig libtiff
   libwebp imagemagick curl sane-backends libdrm libXpm epoxy poppler ];
  
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
    platforms = platforms.linux;
  };
}
