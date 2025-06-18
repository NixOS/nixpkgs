{
  lib,
  stdenv,
  fetchzip,
  libtommath,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "convertlit";
  version = "1.8";

  src = fetchzip {
    url = "http://www.convertlit.com/convertlit${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }src.zip";
    sha256 = "182nsin7qscgbw2h92m0zadh3h8q410h5cza6v486yjfvla3dxjx";
    stripRoot = false;
  };

  buildInputs = [ libtommath ];

  hardeningDisable = [ "format" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  postPatch = ''
    substituteInPlace clit18/Makefile --replace gcc \$\(CC\)
    substituteInPlace clit18/Makefile --replace ../libtommath-0.30/libtommath.a -ltommath
  '';

  buildPhase = ''
    cd lib
    make
    cd ../clit18
    make
  '';

  installPhase = ''
    install -Dm755 clit $out/bin/clit
  '';

  meta = {
    homepage = "http://www.convertlit.com/";
    description = "Tool for converting Microsoft Reader ebooks to more open formats";
    mainProgram = "clit";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
