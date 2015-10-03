{stdenv, fetchurl, qt4, pkgconfig, poppler_qt4, djvulibre, libspectre, cups
, file, ghostscript
}:
let
  s = # Generated upstream information
  rec {
    baseName="qpdfview";
    version = "0.4.15";
    name="${baseName}-${version}";
    url="https://launchpad.net/qpdfview/trunk/${version}/+download/qpdfview-${version}.tar.gz";
    sha256 = "0wgj02zpbyq4m2ix8rljiz312l2xk81gpy030vy424icq4xsip52";
  };
  buildInputs = [
    qt4 poppler_qt4 pkgconfig djvulibre libspectre cups file ghostscript
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  configurePhase = ''
    qmake *.pro
    for i in *.pro; do 
      qmake "$i" -o "Makefile.$(basename "$i" .pro)"
    done
    sed -e "s@/usr/@$out/@g" -i Makefile*
  '';
  meta = {
    inherit (s) version;
    description = "A tabbed document viewer";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://launchpad.net/qpdfview";
    updateWalker = true;
  };
}
