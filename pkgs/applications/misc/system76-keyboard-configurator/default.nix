{ lib, stdenv, fetchFromGitHub, rustPlatform, gtk3, glib, wrapGAppsHook, libusb1, hidapi, udev, pkg-config }:

# system76-keyboard-configurator tries to spawn a daemon as root via pkexec, so
# your system needs a PolicyKit authentication agent running for the
# configurator to work.

rustPlatform.buildRustPackage rec {
  pname = "system76-keyboard-configurator";
<<<<<<< HEAD
  version = "1.3.9";
=======
  version = "1.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "keyboard-configurator";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-06qiJ3NZZSvDBH7r6K1qnz0q4ngB45wBoaG6eTFiRtk=";
=======
    sha256 = "sha256-k9VmEg/HZECUwHaD491ZmfGUxZ14hLOaJD5x3zMK2jI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  cargoHash = "sha256-tcyLoXOrC+lrFVRzxWfWpvHpfA6tbEBXFj9mSeTLcbc=";
=======
  cargoHash = "sha256-0SFph9quh4QWR3nU5IJr4FyLGqrYvmHcZHDRli6phsc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Keyboard configuration application for System76 keyboards and laptops";
    homepage = "https://github.com/pop-os/keyboard-configurator";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ mirrexagon ];
    platforms = platforms.linux;
  };
}
