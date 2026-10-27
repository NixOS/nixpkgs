{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "par";
  version = "1.53.0";

  src = fetchurl {
    url = "http://www.nicemice.net/par/Par-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-yAnGIOuCtYlVOsVLmJjI2lUZbSYjOdE8BG8r5ErEeAQ=";
  };

  makefile = "protoMakefile";
  preBuild = ''
    makeFlagsArray+=(CC="${stdenv.cc.targetPrefix}cc -c" LINK1=${stdenv.cc.targetPrefix}cc)
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp par $out/bin

    mkdir -p $out/share/man/man1
    cp  par.1 $out/share/man/man1
  '';

  meta = {
    homepage = "http://www.nicemice.net/par/";
    description = "Paragraph reflow for email";
    mainProgram = "par";
    platforms = lib.platforms.unix;
    # See https://fedoraproject.org/wiki/Licensing/Par for license details
    license = lib.licenses.free;
  };
})
