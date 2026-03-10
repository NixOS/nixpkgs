{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  dbus,
  libx11,
  libusb1,
  pkg-config,
  udev,
  wayland,
  wayland-scanner,
  libxkbcommon,
  gtk3,
  libayatana-appindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keymapper";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "keymapper";
    tag = finalAttrs.version;
    hash = "sha256-d5UmVJAW6Z7SwR1BgbgNN4+GQ2BY357ioIBrkx6GlpM=";
  };

  # all the following must be in nativeBuildInputs
  nativeBuildInputs = [
    cmake
    pkg-config
    dbus
    wayland
    wayland-scanner
    libx11
    udev
    libusb1
    libxkbcommon
    gtk3
    libayatana-appindicator
  ];

  meta = {
    changelog = "https://github.com/houmain/keymapper/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Cross-platform context-aware key remapper";
    homepage = "https://github.com/houmain/keymapper";
    license = lib.licenses.gpl3Only;
    mainProgram = "keymapper";
    maintainers = with lib.maintainers; [
      dit7ya
    ];
    platforms = lib.platforms.linux;
  };
})
