{
  lib,
  stdenv,
  fetchurl,
  curl,
  libmrss,
  podofo,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "offrss";
  version = "1.3";

  installPhase = ''
    mkdir -p $out/bin
    cp offrss $out/bin
  '';

  buildInputs =
    [
      curl
      libmrss
    ]
    ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) podofo
    ++ lib.optional (!stdenv.hostPlatform.isLinux) libiconv;

  # Workaround build failure on -fno-common toolchains:
  #   ld: serve_pdf.o:offrss.h:75: multiple definition of `cgi_url_path';
  #     offrss.o:offrss.h:75: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon -Wno-error=implicit-function-declaration";

  configurePhase =
    ''
      substituteInPlace Makefile \
        --replace '$(CC) $(CFLAGS) $(LDFLAGS)' '$(CXX) $(CFLAGS) $(LDFLAGS)'
    ''
    + lib.optionalString (!stdenv.hostPlatform.isLinux) ''
      sed 's/#EXTRA/EXTRA/' -i Makefile
    ''
    + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
      sed 's/^PDF/#PDF/' -i Makefile
    '';

  src = fetchurl {
    url = "http://vicerveza.homeunix.net/~viric/soft/offrss/offrss-${finalAttrs.version}.tar.gz";
    hash = "sha256-5oIiDLdFrnEfPfSiwCv3inIcxK+bbgbMT1VISVAPfKo=";
  };

  meta = {
    homepage = "http://vicerveza.homeunix.net/~viric/cgi-bin/offrss";
    description = "Offline RSS/Atom reader";
    license = lib.licenses.agpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "offrss";
  };
})
