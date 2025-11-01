{
  lib,
  stdenv,
  cmake,
  curl,
  fetchFromGitHub,
  libarchive,
  nix-update-script,
  pkg-config,
  qt6,
  wrapGAppsHook4,
  testers,
  writeShellScriptBin,
  xz,
  gnutls,
  zstd,
  libtasn1,
  enableTelemetry ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rpi-imager";
  version = "2.0.0-rc4";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-imager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XSTQSY7q3YhuG3xpb7P7KoHBYxkIWVJqlLPFgDJv5Z0=";
  };

  patches = [ ./remove-vendoring.patch ];

  postPatch = ''
    substituteInPlace debian/com.raspberrypi.rpi-imager.desktop \
      --replace-fail "/usr/bin/" ""
  '';

  preConfigure = ''
    cd src
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    wrapGAppsHook4
    # Fool upstream's cmake lsblk check a bit
    (writeShellScriptBin "lsblk" ''
      echo "our lsblk has --json support but it doesn't work in our sandbox"
    '')
  ];

  buildInputs = [
    curl
    libarchive
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qttools
    xz
    gnutls
    zstd
    libtasn1
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  cmakeFlags = [
    # Isn't relevant for Nix
    (lib.cmakeBool "ENABLE_CHECK_VERSION" false)
    (lib.cmakeBool "ENABLE_TELEMETRY" enableTelemetry)
  ];

  qtWrapperArgs = [
    "--unset QT_QPA_PLATFORMTHEME"
    "--unset QT_STYLE_OVERRIDE"
  ];
  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "QT_QPA_PLATFORM=offscreen rpi-imager --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Raspberry Pi Imaging Utility";
    homepage = "https://github.com/raspberrypi/rpi-imager/";
    changelog = "https://github.com/raspberrypi/rpi-imager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "rpi-imager";
    maintainers = with lib.maintainers; [
      ymarkus
      anthonyroussel
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    # could not find xz
    badPlatforms = lib.platforms.darwin;
  };
})
