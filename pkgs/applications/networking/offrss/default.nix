{stdenv, fetchurl, curl, libmrss}:

stdenv.mkDerivation {
  name = "offrss-1.0";

  installPhase = ''
    ensureDir $out/bin
    cp offrss $out/bin
  '';

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  buildInputs = [ curl libmrss ];

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/offrss/offrss-1.0.tar.gz;
    sha256 = "15qf5vvvaf6jjm05acx0s0fjb6iyiw63mk96cpqhlmif02g8rysd";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/cgi-bin/offrss";
    description = "Offline RSS/Atom reader";
    license="AGPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
