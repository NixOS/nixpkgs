{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  version = "20090618";
  pname = "pari-seadata-small";

  src = fetchurl {
    url = "http://pari.math.u-bordeaux.fr/pub/pari/packages/seadata-small.tgz";
    sha256 = "13qafribxwkz8h3haa0cng7arz0kh7398br4y7vqs9ib8w9yjnxz";
  };

  installPhase = ''
    mkdir -p "$out/share/pari"
    cp -R * "$out/share/pari/"
  '';

  meta = {
    description = "PARI database needed by ellap for large primes";
    homepage = "http://pari.math.u-bordeaux.fr/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    teams = [ lib.teams.sage ];
  };
}
