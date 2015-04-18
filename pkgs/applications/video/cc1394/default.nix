{ stdenv, fetchurl, libraw1394, libdc1394avt, qt4, SDL }:

stdenv.mkDerivation rec {
  name = "cc1394-3.0";

  src = fetchurl {
    url = http://www.alliedvisiontec.com/fileadmin/content/PDF/Software/AVT_software/zip_files/AVTFire4Linux3v0.src.tar;
    sha256 = "13fz3apxcv2rkb34hxd48lbhss6vagp9h96f55148l4mlf5iyyfv";
  };

  unpackPhase = ''
    tar xf $src
    BIGTAR=`echo *`
    tar xf */cc1394*.tar.gz
    rm -R $BIGTAR
    cd cc*
  '';

  NIX_LDFLAGS = "-lX11";

  enableParalellBuilding = true;

  preConfigure = ''
    sed -i -e s,/usr,$out, cc1394.pro
    qmake PREFIX=$out
  '';

  buildInputs = [ libraw1394 libdc1394avt qt4 SDL ];

  meta = {
    homepage = http://www.alliedvisiontec.com/us/products/software/linux/avt-fire4linux.html;
    description = "AVT Viewer application for AVT cameras";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = []; # because libdc1394avt is broken
  };
}
