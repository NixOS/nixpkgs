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
<<<<<<< HEAD
  version = "5.3.1";
=======
  version = "5.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "keymapper";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-YKfKgsrjDrskLEoYCSRMYco7+7E/sgXFAMEwwm7rs7w=";
=======
    hash = "sha256-y1EVF3IwGzDy32ywo9LSzkQNki/HuKC40DySIme8nTc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
      spitulax
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    platforms = lib.platforms.linux;
  };
})
