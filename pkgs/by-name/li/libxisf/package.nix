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
  version = "0.2.15";

  src = fetchFromGitea {
    domain = "gitea.nouspiro.space";
    owner = "nou";
    repo = "libXISF";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TNud3xsGu9lJTfYYp3w3Y0MXH8CxXhOZ3Dp+5UoILak=";
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
