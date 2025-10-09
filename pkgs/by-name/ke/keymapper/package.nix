{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  dbus,
  libX11,
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
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "keymapper";
    tag = finalAttrs.version;
    hash = "sha256-3cUfgOuZ3GKSKbUI2k/MwvSmHtqvqiUvqUem3Nh/YuQ=";
  };

  # all the following must be in nativeBuildInputs
  nativeBuildInputs = [
    cmake
    pkg-config
    dbus
    wayland
    wayland-scanner
    libX11
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
      spitulax
    ];
    platforms = lib.platforms.linux;
  };
})
