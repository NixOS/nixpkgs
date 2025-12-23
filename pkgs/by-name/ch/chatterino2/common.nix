{
  enableAvifSupport ? false,
  stdenv,
  lib,
  cmake,
  pkg-config,
  boost,
  openssl,
  libsecret,
  libnotify,
  libavif,
  kdePackages,
  autoPatchelfHook,
  libpulseaudio,
}:

stdenv.mkDerivation {
  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs =
    (with kdePackages; [
      qtbase
      qtsvg
      qt5compat
      qtkeychain
      qtimageformats
    ])
    ++ [
      boost
      openssl
      libsecret
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      kdePackages.qtwayland
      libnotify
    ]
    ++ lib.optional enableAvifSupport libavif;

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [ libpulseaudio ];

  preConfigure = ''
    if [[ -f "$src/GIT_HASH" ]]; then
      export GIT_HASH="$(cat $src/GIT_HASH)"
    fi
  '';

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
