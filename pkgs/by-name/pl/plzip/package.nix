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
  version = "1.12";
  outputs = [
    "out"
    "man"
    "info"
  ];

  src = fetchurl {
    url = "mirror://savannah/lzip/plzip/plzip-${finalAttrs.version}.tar.lz";
    hash = "sha256-RLvt4rLiOPBbmSEon5194ia3lYKmN2pdEOv8u4dxOoQ=";
    # hash from release email
  };

  nativeBuildInputs = [
    lzip
    texinfo
  ];
  buildInputs = [ lzlib ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/plzip.html";
    description = "Massively parallel lossless data compressor based on the lzlib compression library";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [
      _360ied
      ehmry
    ];
    mainProgram = "plzip";
  };
})
