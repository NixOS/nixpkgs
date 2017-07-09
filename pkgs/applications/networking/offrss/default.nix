{ stdenv, fetchurl, curl, libmrss, podofo, libiconv }:

stdenv.mkDerivation {
  name = "offrss-1.3";

  installPhase = ''
    mkdir -p $out/bin
    cp offrss $out/bin
  '';

  crossAttrs = {
    propagatedBuildInputs = [ curl.crossDrv libmrss.crossDrv ];
    preConfigure = ''
      sed 's/^PDF/#PDF/' -i Makefile
    '';
  };

  buildInputs = [ curl libmrss podofo ]
    ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;

  configurePhase = stdenv.lib.optionalString (!stdenv.isLinux) ''
    sed 's/#EXTRA/EXTRA/' -i Makefile
  '';

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/offrss/offrss-1.3.tar.gz;
    sha256 = "1akw1x84jj2m9z60cvlvmz21qwlaywmw18pl7lgp3bj5nw6250p6";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/cgi-bin/offrss";
    description = "Offline RSS/Atom reader";
    license="AGPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
