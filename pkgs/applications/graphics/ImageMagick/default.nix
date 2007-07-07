{stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript,
libjpeg, libpng, libtiff, libX11, libxml2, zlib}:
stdenv.mkDerivation {
  name = "ImageMagick-6.3.5";

  src = fetchurl {
    url = ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.3.5-0.tar.bz2;
    sha256 = "0yp3srha2h21qsnhfsfczjqw8x1qy1bdlc06qsrj1as0bn2br7b4";
  };

  configureFlags = " --with-dots --with-gs-font-dir="+ ghostscript +
		"/share/ghostscript/fonts --with-gslib ";

  buildInputs = [bzip2 freetype ghostscript graphviz libjpeg libpng 
		libtiff libX11 libxml2 zlib ];
}
