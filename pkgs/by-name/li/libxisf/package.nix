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
  version = "0.2.13";

  src = fetchFromGitea {
    domain = "gitea.nouspiro.space";
    owner = "nou";
    repo = "libXISF";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vc42Jw7kBbQYu+/6jakxFnSuVkS8t6ZyYuSMLGMnEn4=";
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

  meta = with lib; {
    description = "Library to load and write XISF format from PixInsight";
    homepage = "https://gitea.nouspiro.space/nou/libXISF";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ panicgh ];
    platforms = platforms.linux;
  };
})
