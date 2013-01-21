{ stdenv, fetchurl, tk }:

stdenv.mkDerivation rec {
  name = "gocr-0.49";

  src = fetchurl {
    url = http://www-e.uni-magdeburg.de/jschulen/ocr/gocr-0.49.tar.gz;
    sha256 = "06hpzp7rkkwfr1fvmc8kcfz9v490i9yir7f7imh13gmka0fr6afc";
  };

  postInstall = ''
    sed -i -e 's|exec wish|exec ${tk}/bin/wish|' $out/bin/gocr.tcl
  '';

  meta = {
    homepage = "http://jocr.sourceforge.net/";
    description = "GPL Optical Character Recognition";
    license = "GPLv2";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
