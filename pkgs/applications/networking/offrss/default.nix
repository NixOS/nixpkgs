{stdenv, fetchurl, curl, libmrss}:

stdenv.mkDerivation {
  name = "offrss-0.9";

  installPhase = ''
    ensureDir $out/bin
    cp offrss $out/bin
  '';

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  buildInputs = [ curl libmrss ];

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/offrss/offrss-0.9.tar.gz;
    sha256 = "1mpnsfakcpqzf76dicm21nc7sj7qacazb3rbcmlhz1zhbrw5kszj";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/cgi-bin/offrss";
    description = "Offline RSS/Atom reader";
    license="AGPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
