{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  version = "20080411";
  pname = "pari-galdata";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/packages/galdata.tgz";
    sha256 = "1pch6bk76f1i6cwwgm7hhxi5h71m52lqayp4mnyj0jmjk406bhdp";
  };

  installPhase = ''
    mkdir -p "$out/share/pari"
    cp -R * "$out/share/pari/"
  '';

  meta = {
    description = "PARI database needed to compute Galois group in degrees 8 through 11";
    homepage = "http://pari.math.u-bordeaux.fr/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    teams = [ lib.teams.sage ];
  };
}
