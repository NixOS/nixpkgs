{stdenv, fetchurl, libX11, libXt, libXext, arts, qt, kdelibs, zlib, libpng, libjpeg, perl, expat}:

stdenv.mkDerivation {
  name = "konversation-1.0.1";
  src = fetchurl {
    url = http://download.berlios.de/konversation/konversation-1.0.1.tar.bz2;
    sha256 = "8be736289c52c21fe5ada7dd153767abd5155424a510ab9781b9d2f585cc00fd";
  };
  buildInputs = [arts qt kdelibs libX11 libXt libXext zlib libpng libjpeg perl expat];
  postConfigure = '' for i in `find . -name Makefile`; do echo $i; sed -i -e "s|-L/usr/lib||g" -e "s|\-R \$(x_libraries)||g" $i; done '';

  meta = {
    homepage = http://www.konversation.org;
    license = "GPL";
  };
}
