{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "objconv";
  version = "2.54.1";

  src = fetchurl {
    # Versioned archive of objconv sources maintained by orivej.
    url = "https://archive.org/download/objconv/objconv-${finalAttrs.version}.zip";
    sha256 = "sha256-DFyo+8fvHEr+PMfMkBhxGliFr6y+i868SAKNHskMzHw=";
  };

  nativeBuildInputs = [ unzip ];

  outputs = [
    "out"
    "doc"
  ];

  unpackPhase = ''
    mkdir -p "$name"
    cd "$name"
    unpackFile "$src"
    unpackFile source.zip
  '';

  buildPhase = "c++ -o objconv -O2 *.cpp";

  installPhase = ''
    mkdir -p $out/bin $out/doc/objconv
    mv objconv $out/bin
    mv objconv-instructions.pdf $out/doc/objconv
  '';

  meta = {
    description = "Object and executable file converter, modifier and disassembler";
    mainProgram = "objconv";
    homepage = "https://www.agner.org/optimize/";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
