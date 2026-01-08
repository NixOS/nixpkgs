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
  env.LDFLAGS = "-lm";

  nativeBuildInputs = [
    validatePkgConfig
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  buildPhase = ''
    make -f Makefile.cmdline
  ''
  + lib.optionalString (!stdenv.hostPlatform.isStatic && !stdenv.hostPlatform.isMinGW) ''
    make INSTALL_PREFIX="$out" -f Makefile.sharedlibrary
  ''
  + lib.optionalString (!stdenv.hostPlatform.isStatic && stdenv.hostPlatform.isMinGW) ''
    # The upstream shared library Makefile produces a Unix-named .so even on MinGW,
    # which doesn't provide an import/static library for consumers (e.g. libproxy).
    # Build and install a conventional static library instead.
    $CC -c $NIX_CFLAGS_COMPILE -Isrc -o duktape.o src/duktape.c
    $AR rcs libduktape.a duktape.o
  '';

  installPhase = ''
    install -d $out/bin
    install -m755 "duk${stdenv.hostPlatform.extensions.executable}" $out/bin/
  ''
  + lib.optionalString (!stdenv.hostPlatform.isStatic && !stdenv.hostPlatform.isMinGW) ''
    install -d $out/lib/pkgconfig
    install -d $out/include

    make INSTALL_PREFIX="$out" -f Makefile.sharedlibrary install
  ''
  + lib.optionalString (!stdenv.hostPlatform.isStatic && stdenv.hostPlatform.isMinGW) ''
    install -d $out/lib $out/lib/pkgconfig $out/include
    install -m644 libduktape.a $out/lib/
    install -m644 src/duktape.h src/duk_config.h $out/include/

    cat > $out/lib/pkgconfig/duktape.pc <<EOF
    prefix=$out
    exec_prefix=$out
    libdir=$out/lib
    includedir=$out/include

    Name: duktape
    Description: Embeddable Javascript engine, with a focus on portability and compact footprint
    Version: ${finalAttrs.version}
    Libs: -L$out/lib -lduktape -lm
    Cflags: -I$out/include
    EOF
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Embeddable Javascript engine, with a focus on portability and compact footprint";
    homepage = "https://duktape.org/";
    downloadPage = "https://duktape.org/download.html";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.fgaz ];
    mainProgram = "duk";
    platforms = lib.platforms.all;
  };
})
