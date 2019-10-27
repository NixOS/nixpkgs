{ stdenv, fetchurl, curl, libmrss, podofo, libiconv }:

stdenv.mkDerivation {
  name = "offrss-1.3";

  installPhase = ''
    mkdir -p $out/bin
    cp offrss $out/bin
  '';

  buildInputs = [ curl libmrss ]
    ++ stdenv.lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) podofo
    ++ stdenv.lib.optional (!stdenv.isLinux) libiconv;

  configurePhase = ''
    substituteInPlace Makefile \
      --replace '$(CC) $(CFLAGS) $(LDFLAGS)' '$(CXX) $(CFLAGS) $(LDFLAGS)'
  '' + stdenv.lib.optionalString (!stdenv.isLinux) ''
    sed 's/#EXTRA/EXTRA/' -i Makefile
  '' + stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed 's/^PDF/#PDF/' -i Makefile
  '';

  src = fetchurl {
    url = http://vicerveza.homeunix.net/~viric/soft/offrss/offrss-1.3.tar.gz;
    sha256 = "1akw1x84jj2m9z60cvlvmz21qwlaywmw18pl7lgp3bj5nw6250p6";
  };

  meta = {
    homepage = http://vicerveza.homeunix.net/~viric/cgi-bin/offrss;
    description = "Offline RSS/Atom reader";
    license="AGPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.linux;
  };
}
