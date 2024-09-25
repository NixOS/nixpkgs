{
  lib,
  stdenv,
  cmake,
  curl,
  fetchFromGitHub,
  libarchive,
  nix-update-script,
  pkg-config,
  qt5,
  testers,
  util-linux,
  xz,
  enableTelemetry ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rpi-imager";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-imager";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-JrotKMyAgQO3Y5RsFAar9N5/wDpWiBcy8RfvBWDiJMs=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  # By default, the builder checks for JSON support in lsblk by running "lsblk --json",
  # but that throws an error, as /sys/dev doesn't exist in the sandbox.
  # This patch removes the check.
  patches = [ ./lsblkCheckFix.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
    util-linux
  ];

  buildInputs =
    [
      curl
      libarchive
      qt5.qtbase
      qt5.qtdeclarative
      qt5.qtgraphicaleffects
      qt5.qtquickcontrols2
      qt5.qtsvg
      qt5.qttools
      xz
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qt5.qtwayland
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

  meta = with lib; {
    description = "Raspberry Pi Imaging Utility";
    homepage = "https://github.com/raspberrypi/rpi-imager/";
    changelog = "https://github.com/raspberrypi/rpi-imager/releases/tag/v${finalAttrs.version}";
    license = licenses.asl20;
    mainProgram = "rpi-imager";
    maintainers = with maintainers; [
      ymarkus
      anthonyroussel
    ];
    platforms = platforms.all;
    # does not build on darwin
    broken = stdenv.hostPlatform.isDarwin;
  };
})
