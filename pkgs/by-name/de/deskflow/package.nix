{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  doxygen,
  ninja,
  pkg-config,
  qt6,

  # nativeCheckInputs
  writableTmpDirAsHomeHook,

  # buildInputs (Linux and Darwin)
  openssl,
  pugixml,
  python3,

  # buildInputs (Linux-specific)
  gdk-pixbuf,
  gtest,
  lerc,
  libei,
  libnotify,
  libportal,
  libsysprof-capture,
  libx11,
  libxi,
  libxinerama,
  libxkbcommon,
  libxkbfile,
  libxrandr,
  libxtst,
  wayland,
  wayland-protocols,

  # Update script for `passthru`.
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deskflow";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "deskflow";
    repo = "deskflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XcSG47Ysjn+wrJH5DC/XXGXcneXcW7xIhAn6sguuv+s=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    doxygen # docs
  ];

  buildInputs = [
    openssl
    pugixml
    python3
    qt6.qtbase
    qt6.qttools
    qt6.qttranslations
  ]
  ++ (lib.optionals stdenv.hostPlatform.isLinux [
    gdk-pixbuf
    gtest
    lerc
    libei
    libnotify
    libportal
    libsysprof-capture
    libx11
    libxi
    libxinerama
    libxkbcommon
    libxkbfile
    libxrandr
    libxtst
    pugixml
    python3
    qt6.qtdeclarative
    qt6.qtwayland
    wayland
    wayland-protocols
  ]);

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export PATH="${qt6.qtbase}/bin:$PATH"
  '';

  postPatch = ''
    substituteInPlace translations/CMakeLists.txt \
      --replace-fail 'PATHS ''${QT_ROOT_DIR} PATH_SUFFIXES "translations" "share/qt/translations"' 'PATHS "${qt6.qttranslations}/translations"'
    substituteInPlace src/lib/net/CMakeLists.txt \
      --replace-fail "set(OPENSSL_USE_STATIC_LIBS TRUE)" ""
    substituteInPlace deploy/linux/deploy.cmake \
      --replace-fail 'message(FATAL_ERROR "Unable to read file /etc/os-release")' 'set(RELEASE_FILE_CONTENTS "")'
  '';

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON" # Avoid generating incorrect RPATH
    "-DSKIP_BUILD_TESTS=ON" # Perform unit tests in `checkPhase` manually, with one job at a time.
  ];

  qtWrapperArgs = lib.optional stdenv.hostPlatform.isLinux "--set QT_QPA_PLATFORM_PLUGIN_PATH ${qt6.qtwayland}/${qt6.qtbase.qtPluginPrefix}/platforms";

  strictDeps = true;

  doCheck = true;

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkPhase = ''
    runHook preCheck

    export QT_QPA_PLATFORM=offscreen
    ctest --test-dir  "src/unittests" --output-on-failure
    ./bin/legacytests

    runHook postCheck
  '';

  postInstall = ''
    install -Dm644 ../README.md ../doc/user/configuration.md -t $out/share/doc/deskflow
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    homepage = "https://github.com/deskflow/deskflow";
    description = "Share one mouse and keyboard between multiple computers on Windows, macOS and Linux";
    mainProgram = "deskflow";
    maintainers = with lib.maintainers; [ flacks ];
    license = with lib.licenses; [
      gpl2Plus
      lib.licenses.openssl # We have to be explicit here, as `openssl` is a buildInput.
      mit # share/applications/org.deskflow.deskflow.desktop
    ];
    platforms = lib.platforms.unix;
  };
})
