{stdenv, fetchurl, curl, libmrss}:

stdenv.mkDerivation {
  name = "offrss-1.1";

  installPhase = ''
    mkdir -p $out/bin
    cp offrss $out/bin
  '';

  crossAttrs = {
    makeFlags = "CC=${stdenv.cross.config}-gcc";
  };

  buildInputs = [ curl libmrss ];

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/offrss/offrss-1.1.tar.gz;
    sha256 = "1l8c5sw368zbrcfq4wf963fbh29q9lqgsn0lbsiwz3vpybc8plp2";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/cgi-bin/offrss";
    description = "Offline RSS/Atom reader";
    license="AGPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
