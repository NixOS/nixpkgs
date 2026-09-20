{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  libx11,
  libxfixes,
  libxtst,
  wayland,
  miniaudio,
  pkg-config,
  kdePackages,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "CopyQ";
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = "hluk";
    repo = "CopyQ";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QO7iOFwO++tXZMWvJVmzUDrjnuz0Fl2XYsqfIPl5GBA=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtdeclarative
    kdePackages.qca
    kdePackages.qtkeychain
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxfixes
    libxtst
    qt6.qtwayland
    wayland
    miniaudio
    kdePackages.kconfig
    kdePackages.kstatusnotifieritem
    kdePackages.knotifications
    kdePackages.kguiaddons
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_QT6" true)
    (lib.cmakeBool "WITH_NATIVE_NOTIFICATIONS" stdenv.hostPlatform.isLinux)
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (lib.cmakeFeature "MINIAUDIO_INCLUDE_DIR" "${lib.getInclude miniaudio}/include/miniaudio")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "MINIAUDIO_INCLUDE_DIR" "${miniaudio.src}")
  ];

  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  # A symlink makes Qt miss the Cocoa platform plugin because it does not resolve the bundle path.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    makeBinaryWrapper "$out/CopyQ.app/Contents/MacOS/CopyQ" "$out/bin/copyq"
  '';

  meta = {
    homepage = "https://hluk.github.io/CopyQ";
    description = "Clipboard Manager with Advanced Features";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ artturin ];
    platforms = lib.platforms.unix;
    mainProgram = "copyq";
  };
})
