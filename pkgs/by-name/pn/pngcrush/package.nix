{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  libpng,
}:

stdenv.mkDerivation rec {
  pname = "pngcrush";
  version = "1.8.13";

  src = fetchurl {
    url = "mirror://sourceforge/pmt/pngcrush-${version}-nolib.tar.xz";
    sha256 = "0l43c59d6v9l0g07z3q3ywhb8xb3vz74llv3mna0izk9bj6aqkiv";
  };

  patches = [
    (fetchpatch2 {
      url = "https://salsa.debian.org/debian/pngcrush/-/raw/b4856b56fbc28252103cc14d156baddd564ca880/debian/patches/ignore_PNG_IGNORE_ADLER32.patch";
      hash = "sha256-pFON/NUJiXMe9GETptgNltWa0izlby6P/fLsG1abz3g=";
    })
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"
  ]; # gcc and/or clang compat

  configurePhase = ''
    runHook preConfigure

    sed -i s,/usr,$out, Makefile

    runHook postConfigure
  '';

  buildInputs = [ libpng ];

  meta = {
    homepage = "http://pmt.sourceforge.net/pngcrush";
    description = "PNG optimizer";
    license = lib.licenses.free;
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "pngcrush";
  };
}
