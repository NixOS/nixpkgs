{
  lib,
  stdenv,
  fetchzip,
  libpng,
  zlib,
  zopfli,
}:

stdenv.mkDerivation rec {
  pname = "apngopt";
  version = "1.4";

  src = fetchzip {
    url = "mirror://sourceforge/apng/apngopt-${version}-src.zip";
    stripRoot = false;
    hash = "sha256-MAqth5Yt7+SabY6iEgSFcaBmuHvA0ZkNdXSgvhKao1Y=";
  };

  patches = [
    ./remove-7z.patch
  ];

  # Remove bundled libs
  postPatch = ''
    rm -r 7z libpng zlib zopfli
  '';

  buildInputs = [
    libpng
    zlib
    zopfli
  ];

  preBuild = ''
    buildFlagsArray+=("LIBS=-lzopfli -lstdc++ -lpng -lz")
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}c++" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 apngopt $out/bin/apngopt
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/apng/";
    description = "Optimizes APNG animations";
    license = licenses.zlib;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
