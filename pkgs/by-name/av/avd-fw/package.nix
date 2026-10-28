{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pkgsCross,
  meson,
  ninja,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "avd-fw";
  version = "0.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "avd-fw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cq/gOgmbCg5IX0GSiS7Z5lBhpursB1Num8LSANw5fpI=";
  };

  nativeBuildInputs = [
    pkgsCross.arm-embedded.stdenv.cc
    ninja
    meson
  ];

  mesonFlags = [
    "--cross-file=arm-none-eabi-gcc.ini"
    "--buildtype"
    "release"
  ];

  meta = {
    description = "Firmware for the Apple Video Decoder, found on M-Series Apple Silicon Devices";
    homepage = "https://github.com/AsahiLinux/avd-fw";
    license = lib.licenses.mit;
    platforms = [ "aarch64-linux" ];
    maintainers = with lib.maintainers; [
      sempiternal-aurora
      yuka
    ];
  };
})
