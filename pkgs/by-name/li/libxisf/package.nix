{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  pkg-config,
  lz4,
  pugixml,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxisf";
  version = "0.2.14";

  src = fetchFromGitea {
    domain = "gitea.nouspiro.space";
    owner = "nou";
    repo = "libXISF";
    rev = "v${finalAttrs.version}";
    hash = "sha256-t7QnXLJ2Btimjyq+KiYL1YGLllpCDilknX1xq4ka5YQ=";
  };

  patches = [
    ./0001-Fix-pkg-config-paths.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DUSE_BUNDLED_LIBS=OFF"
  ]
  ++ lib.optional stdenv.hostPlatform.isStatic "-DBUILD_SHARED_LIBS=OFF";

  buildInputs = [
    lz4
    pugixml
    zlib
    zstd
  ];

  doCheck = true;

  meta = {
    description = "Library to load and write XISF format from PixInsight";
    homepage = "https://gitea.nouspiro.space/nou/libXISF";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ panicgh ];
    platforms = lib.platforms.linux;
  };
})
