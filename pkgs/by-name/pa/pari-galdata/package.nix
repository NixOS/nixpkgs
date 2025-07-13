{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  version = "20080411";
  pname = "pari-galdata";

  src = fetchurl {
    url = "https://pari.math.u-bordeaux.fr/pub/pari/packages/galdata.tgz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  installPhase = ''
    mkdir -p "$out/share/pari"
    cp -R * "$out/share/pari/"
  '';

  meta = with lib; {
    description = "PARI database needed to compute Galois group in degrees 8 through 11";
    homepage = "http://pari.math.u-bordeaux.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    teams = [ teams.sage ];
  };
}
