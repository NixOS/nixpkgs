{
  enableAvifSupport ? false,
  stdenv,
  lib,
  cmake,
  pkg-config,
  boost,
  openssl,
  libsecret,
  libavif,
  kdePackages,
}:

stdenv.mkDerivation {
  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
  ];

  buildInputs =
    (with kdePackages; [
      qtbase
      qtsvg
      qt5compat
      qtkeychain
    ])
    ++ [
      boost
      openssl
      libsecret
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux kdePackages.qtwayland
    ++ lib.optional enableAvifSupport libavif;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_QT6" true)
    (lib.cmakeBool "USE_SYSTEM_QTKEYCHAIN" true)
    (lib.cmakeBool "CHATTERINO_UPDATER" false)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv bin/chatterino.app "$out/Applications/"
  '';
}
