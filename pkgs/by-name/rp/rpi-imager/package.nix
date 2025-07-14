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
  zstd,
  libtasn1,
  enableTelemetry ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rpi-imager";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-imager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ih7FeAKTKSvuwsrMgKQ0VEUYHHT6L99shxfAIjAzErk=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  # By default, the builder checks for JSON support in lsblk by running "lsblk --json",
  # but that throws an error, as /sys/dev doesn't exist in the sandbox.
  # This patch removes the check.
  # remove-vendoring.patch from
  # https://gitlab.archlinux.org/archlinux/packaging/packages/rpi-imager/-/raw/main/remove-vendoring.patch
  patches = [ ./remove-vendoring-and-lsblk-check.patch ];

  postPatch = ''
    substituteInPlace ../debian/org.raspberrypi.rpi-imager.desktop \
      --replace-fail "/usr/bin/" ""
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
      zstd
      libtasn1
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qt6.qtwayland
    ];

  cmakeFlags =
    # Disable vendoring
    [
      (lib.cmakeBool "ENABLE_VENDORING" false)
    ]
    # Disable telemetry and update check.
    ++ lib.optionals (!enableTelemetry) [
      (lib.cmakeBool "ENABLE_CHECK_VERSION" false)
      (lib.cmakeBool "ENABLE_TELEMETRY" false)
    ];

  qtWrapperArgs = [
    "--unset QT_QPA_PLATFORMTHEME"
    "--unset QT_STYLE_OVERRIDE"
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
