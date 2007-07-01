
{stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript,
libjpeg, libpng, libtiff, libX11, libxml2, zlib}:
stdenv.mkDerivation {
  name = "ImageMagick";

  src = fetchurl {
    url = ftp://ftp.carnet.hr/misc/imagemagick/ImageMagick-6.3.4-7.tar.bz2;
    sha1 = "bead7b27d951cb9c780c76771562e9e7c7c23d16";
# cdc388e20580de2a0f91f68e1228c68b0735f385 
  };

  configureFlags = " --with-dots --with-gs-font-dir="+ ghostscript +
		"/share/ghostscript/fonts --with-gslib ";

  buildInputs = [bzip2 freetype ghostscript graphviz libjpeg libpng 
		libtiff libX11 libxml2 zlib ];
}
