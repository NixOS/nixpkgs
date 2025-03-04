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
  testers,
  util-linux,
  xz,
  gnutls,
  enableTelemetry ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rpi-imager";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-imager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7rkoOKG0yMSIgQjqBBFUMgX/4szHn2NXoBR+5PnKlH4=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  # By default, the builder checks for JSON support in lsblk by running "lsblk --json",
  # but that throws an error, as /sys/dev doesn't exist in the sandbox.
  # This patch removes the check.
  patches = [ ./lsblkCheckFix.patch ];

  # avoid duplicate path prefixes
  postPatch = ''
    substituteInPlace dependencies/xz-5.6.2/CMakeLists.txt \
      --replace-fail '\''${D}/' ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    util-linux
  ];

  buildInputs =
    [
      curl
      libarchive
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtsvg
      qt6.qttools
      xz
      gnutls
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qt6.qtwayland
    ];

  # Disable telemetry and update check.
  cmakeFlags = lib.optionals (!enableTelemetry) [
    "-DENABLE_CHECK_VERSION=OFF"
    "-DENABLE_TELEMETRY=OFF"
  ];

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
    platforms = lib.platforms.all;
    # does not build on darwin
    broken = stdenv.hostPlatform.isDarwin;
  };
})
