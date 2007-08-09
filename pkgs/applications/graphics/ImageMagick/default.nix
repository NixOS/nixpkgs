{stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript,
libjpeg, libpng, libtiff, libX11, libxml2, zlib}:
stdenv.mkDerivation {
  name = "ImageMagick-6.3.5";

  src = fetchurl {
    url = ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick-6.3.5-5.tar.bz2;
    sha256 = "0avq6kllxw552krxgsa72c1b44zwyhwi38dk4a4ij3fqy0svy9zh";
  };

  configureFlags = " --with-dots --with-gs-font-dir="+ ghostscript +
		"/share/ghostscript/fonts --with-gslib ";

  buildInputs = [bzip2 freetype ghostscript graphviz libjpeg libpng 
		libtiff libX11 libxml2 zlib ];
}
