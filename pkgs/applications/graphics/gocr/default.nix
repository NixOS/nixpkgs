{ stdenv, fetchurl, tk }:

stdenv.mkDerivation rec {
  name = "gocr-0.50";

  src = fetchurl {
    url = "http://www-e.uni-magdeburg.de/jschulen/ocr/${name}.tar.gz";
    sha256 = "1dgmcpapy7h68d53q2c5d0bpgzgfb2nw2blndnx9qhc7z12149mw";
  };

  postInstall = ''
    sed -i -e 's|exec wish|exec ${tk}/bin/wish|' $out/bin/gocr.tcl
  '';

  meta = {
    homepage = "http://jocr.sourceforge.net/";
    description = "GPL Optical Character Recognition";
    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
