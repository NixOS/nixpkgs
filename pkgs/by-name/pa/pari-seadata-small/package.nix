{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  version = "20090618";
  pname = "pari-seadata-small";

  src = fetchurl {
    url = "https://pari.math.u-bordeaux.fr/pub/pari/packages/seadata-small.tgz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  installPhase = ''
    mkdir -p "$out/share/pari"
    cp -R * "$out/share/pari/"
  '';

  meta = with lib; {
    description = "PARI database needed by ellap for large primes";
    homepage = "http://pari.math.u-bordeaux.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    teams = [ teams.sage ];
  };
}
