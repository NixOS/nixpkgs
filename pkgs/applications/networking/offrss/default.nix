{ lib, stdenv, fetchurl, curl, libmrss, podofo, libiconv }:

stdenv.mkDerivation rec {
  pname = "offrss";
  version = "1.3";

  installPhase = ''
    mkdir -p $out/bin
    cp offrss $out/bin
  '';

  buildInputs = [ curl libmrss ]
    ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) podofo
    ++ lib.optional (!stdenv.isLinux) libiconv;

  # Workaround build failure on -fno-common toolchains:
  #   ld: serve_pdf.o:offrss.h:75: multiple definition of `cgi_url_path';
  #     offrss.o:offrss.h:75: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  configurePhase = ''
    substituteInPlace Makefile \
      --replace '$(CC) $(CFLAGS) $(LDFLAGS)' '$(CXX) $(CFLAGS) $(LDFLAGS)'
  '' + lib.optionalString (!stdenv.isLinux) ''
    sed 's/#EXTRA/EXTRA/' -i Makefile
  '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed 's/^PDF/#PDF/' -i Makefile
  '';

  src = fetchurl {
    url = "http://vicerveza.homeunix.net/~viric/soft/offrss/offrss-${version}.tar.gz";
    sha256 = "1akw1x84jj2m9z60cvlvmz21qwlaywmw18pl7lgp3bj5nw6250p6";
  };

  meta = with lib; {
    homepage = "http://vicerveza.homeunix.net/~viric/cgi-bin/offrss";
    description = "Offline RSS/Atom reader";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ viric ];
    platforms = lib.platforms.linux;
  };
}
