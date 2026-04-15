{
  lib,
  stdenv,
  fetchurl,
  lzip,
  lzlib,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plzip";
  version = "1.13";
  outputs = [
    "out"
    "man"
    "info"
  ];

  src = fetchurl {
    url = "mirror://savannah/lzip/plzip/plzip-${finalAttrs.version}.tar.lz";
    hash = "sha256-f+AUG3Lq8ITYKq07FLOk2W3/C97698OJ91XYlIs2N8g=";
    # hash from release email
  };

  nativeBuildInputs = [
    lzip
    texinfo
  ];
  buildInputs = [ lzlib ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    homepage = "https://www.nongnu.org/lzip/plzip.html";
    description = "Massively parallel lossless data compressor based on the lzlib compression library";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      _360ied
    ];
    mainProgram = "plzip";
  };
})
