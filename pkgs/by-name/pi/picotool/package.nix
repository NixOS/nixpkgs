{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  pico-sdk,
  mbedtls,
  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "picotool";
  version = "2.2.0-a4";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "picotool";
    tag = finalAttrs.version;
    hash = "sha256-kIB/ODAvwWWoAQDq2cMiFuNWjzzLgPuRQv0NluWYU+Y=";
  };

  buildInputs = [
    libusb1
    pico-sdk
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  cmakeFlags = [
    "-DPICO_SDK_PATH=${pico-sdk}/lib/pico-sdk"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Tool for interacting with RP2040/RP2350 device(s) in BOOTSEL mode, or with an RP2040/RP2350 binary";
    homepage = "https://github.com/raspberrypi/picotool";
    changelog = "https://github.com/raspberrypi/picotool/releases/tag/${finalAttrs.version}";
    mainProgram = "picotool";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ muscaln ];
    platforms = lib.platforms.unix;
  };
})
