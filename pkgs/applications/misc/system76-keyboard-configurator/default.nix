{ lib, stdenv, fetchFromGitHub, rustPlatform, gtk3, glib, wrapGAppsHook, libusb1, hidapi, udev, pkg-config }:

# system76-keyboard-configurator tries to spawn a daemon as root via pkexec, so
# your system needs a PolicyKit authentication agent running for the
# configurator to work.

rustPlatform.buildRustPackage rec {
  pname = "system76-keyboard-configurator";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "keyboard-configurator";
    rev = "v${version}";
    sha256 = "sha256-RaJOtlnjxYiA6WrKRmIG3McAzc35zR3uMScLy2kLx98=";
  };

  nativeBuildInputs = [
    pkg-config
    glib # for glib-compile-resources
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    hidapi
    libusb1
    udev
  ];

  cargoHash = "sha256-qoOaLDzJ9WqCnI/kBSiu6DZx1HWU8Cd8ch6VVcgIfB4=";

  meta = with lib; {
    description = "Keyboard configuration application for System76 keyboards and laptops";
    homepage = "https://github.com/pop-os/keyboard-configurator";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ mirrexagon ];
    platforms = platforms.linux;
  };
}
