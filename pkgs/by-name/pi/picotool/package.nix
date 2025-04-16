{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  pico-sdk,
  mbedtls_2,
  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "picotool";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "picotool";
    tag = finalAttrs.version;
    hash = "sha256-WA17FXSUGylzUcbvzgAGCeds+XeuSvDlgFBJD10ERVY=";
  };

  postPatch = ''
    # necessary for signing/hashing support. our pico-sdk does not come with
    # it by default, and it shouldn't due to submodule size. pico-sdk uses
    # an upstream version of mbedtls 2.x so we patch ours in directly.
    substituteInPlace lib/CMakeLists.txt \
      --replace-fail "''$"'{PICO_SDK_PATH}/lib/mbedtls' '${mbedtls_2.src}'
  '';

  buildInputs = [
    libusb1
    pico-sdk
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  cmakeFlags = [ "-DPICO_SDK_PATH=${pico-sdk}/lib/pico-sdk" ];

  postInstall = ''
    install -Dm444 ../udev/99-picotool.rules -t $out/etc/udev/rules.d
  '';

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
