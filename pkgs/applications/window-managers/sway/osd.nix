{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, gtk-layer-shell
, libevdev
, libinput
, libpulseaudio
, udev
}:

rustPlatform.buildRustPackage {
  pname = "swayosd";
  version = "unstable-2023-07-18";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "b14c83889c7860c174276d05dec6554169a681d9";
    hash = "sha256-MJuTwEI599Y7q+0u0DMxRYaXsZfpksc2csgnK9Ghp/E=";
  };

  cargoHash = "sha256-pExpzQwuHREhgkj+eZ8drBVsh/B3WiQBBh906O6ymFw=";

  nativeBuildInputs = [
    wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    gtk-layer-shell
    libevdev
    libinput
    libpulseaudio
    udev
  ];

  meta = with lib; {
    description = "A GTK based on screen display for keyboard shortcuts";
    homepage = "https://github.com/ErikReider/SwayOSD";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
