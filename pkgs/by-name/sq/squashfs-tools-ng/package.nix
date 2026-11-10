{
  stdenv,
  lib,
  fetchurl,
  doxygen,
  graphviz,
  perl,
  pkg-config,
  bzip2,
  lz4,
  lzo,
  xz,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "squashfs-tools-ng";
  version = "1.3.2";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-DZB6w+c1w1HkfIZ/tR2Uv/o7BfuVvsAfMehIt8RCFak=";
  };

  nativeBuildInputs = [
    doxygen
    graphviz
    pkg-config
    perl
  ];
  buildInputs = [
    bzip2
    zlib
    xz
    lz4
    lzo
    zstd
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/AgentD/squashfs-tools-ng";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = lib.platforms.unix;
  };
})
