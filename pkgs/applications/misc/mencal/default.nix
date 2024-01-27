{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "mencal";
  version = "3.0";

  src = fetchurl {
    url = "http://kyberdigi.cz/projects/mencal/files/mencal-${version}.tar.gz";
    sha256 = "9328d0b2f3f57847e8753c5184531f4832be7123d1b6623afdff892074c03080";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp mencal $out/bin/
  '';

  buildInputs = [ perl ];

  meta = with lib; {
    description = "Menstruation calendar";
    longDescription = ''
      Mencal is a simple variation of the well-known unix command cal.
      The main difference is that you can have some periodically repeating
      days highlighted in color. This can be used to track
      menstruation (or other) cycles conveniently.
    '';
    homepage = "http://www.kyberdigi.cz/projects/mencal/english.html";
    license = licenses.gpl2;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.all;
  };
}
