{
  lib,
  stdenv,
  fetchzip,
  libpng,
  zlib,
  zopfli,
}:

stdenv.mkDerivation rec {
  pname = "apngasm";
  version = "2.91";

  src = fetchzip {
    url = "mirror://sourceforge/${pname}/${pname}-${version}-src.zip";
    stripRoot = false;
    sha256 = "0qhljqql159xkn1l83vz0q8wvzr7rjz4jnhiy0zn36pgvacg0zn1";
  };

  buildInputs = [
    libpng
    zlib
    zopfli
  ];

  postPatch = ''
    rm -rf libpng zlib zopfli
  '';

  NIX_CFLAGS_LINK = "-lzopfli";

  installPhase = ''
    install -Dt $out/bin apngasm
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Create highly optimized Animated PNG files from PNG/TGA images";
    mainProgram = "apngasm";
    homepage = "https://apngasm.sourceforge.net/";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ orivej ];
    platforms = lib.platforms.linux;
  };

}
