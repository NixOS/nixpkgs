{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  pkgsCross,
  meson,
  ninja,
  codecs ? [ "all_free" ],
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "avd-fw";
  version = "0.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "avd-fw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ib8vn/PbBNv3BWPuWmRZ+dXEcPuJ21Wl+cynf0WPySc=";
  };

  nativeBuildInputs = [
    pkgsCross.arm-embedded.stdenv.cc
    ninja
    meson
  ];

  postPatch = ''
    meson rewrite kwargs set project / version '${finalAttrs.version}'
  '';

  mesonBuildType = "release";
  mesonFlags = [
    "--cross-file=arm-none-eabi-gcc.ini"
    (lib.mesonOption "video-codecs" (lib.concatStringsSep "," codecs))
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
