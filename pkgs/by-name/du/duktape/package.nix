{
  lib,
  stdenv,
  fetchurl,
  fixDarwinDylibNames,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "duktape";
  version = "2.7.0";
  src = fetchurl {
    url = "http://duktape.org/duktape-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-kPjS+otVZ8aJmDDd7ywD88J5YLEayiIvoXqnrGE8KJA=";
  };

  # https://github.com/svaarala/duktape/issues/2464
  LDFLAGS = [ "-lm" ];

  nativeBuildInputs = [
    validatePkgConfig
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  buildPhase = ''
    make -f Makefile.cmdline
  ''
  + lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    make INSTALL_PREFIX="$out" -f Makefile.sharedlibrary
  '';

  installPhase = ''
    install -d $out/bin
    install -m755 duk $out/bin/
  ''
  + lib.optionalString (!stdenv.hostPlatform.isStatic) ''
    install -d $out/lib/pkgconfig
    install -d $out/include

    make INSTALL_PREFIX="$out" -f Makefile.sharedlibrary install
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Embeddable Javascript engine, with a focus on portability and compact footprint";
    homepage = "https://duktape.org/";
    downloadPage = "https://duktape.org/download.html";
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
    mainProgram = "duk";
    platforms = platforms.all;
  };
})
