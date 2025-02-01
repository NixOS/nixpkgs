{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  jsoncpp,
  libarchive,
  libcpr,
  libloot,
  pugixml,

  libsForQt5,

  withUnrar ? true,
  unrar, # has an unfree license
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "limo";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "limo-app";
    repo = "limo";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-ytSlR6JhR7qYT/jCbTthHWc+YOX4AbJs9a4GRdgHj5c=";
  };

  patches = lib.optionals (!withUnrar) [
    # remove `unrar` as fallback when libarchive fails
    ./remove-unrar.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs =
    [
      jsoncpp
      libarchive
      libcpr
      libloot
      pugixml

      libsForQt5.qtbase
      libsForQt5.qtsvg
      libsForQt5.qtwayland
    ]
    ++ lib.optionals withUnrar [
      unrar
    ];

  cmakeFlags =
    [
      (lib.cmakeFeature "LIMO_INSTALL_PREFIX" (placeholder "out"))
      (lib.cmakeBool "USE_SYSTEM_LIBUNRAR" true)
    ]
    ++ lib.optionals (!withUnrar) [
      (lib.cmakeFeature "LIBUNRAR_PATH" "")
      (lib.cmakeFeature "LIBUNRAR_INCLUDE_DIR" "")
    ];

  meta = {
    description = "General purpose mod manager with support for the NexusMods API and LOOT";
    homepage = "https://github.com/limo-app/limo";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Limo";
    maintainers = with lib.maintainers; [
      tomasajt
      MattSturgeon
    ];
    platforms = lib.platforms.linux;
  };
})
