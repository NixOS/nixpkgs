{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, wrapGAppsHook
, cargo
, coreutils
, gtk-layer-shell
, libevdev
, libinput
, libpulseaudio
, meson
, ninja
, rustc
, stdenv
, udev
}:

stdenv.mkDerivation rec {
  pname = "swayosd";
  version = "unstable-2023-07-18";
=======
, gtk3
, gtk-layer-shell
, libpulseaudio
}:

rustPlatform.buildRustPackage {
  pname = "swayosd";
  version = "unstable-2023-05-09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
<<<<<<< HEAD
    rev = "b14c83889c7860c174276d05dec6554169a681d9";
    hash = "sha256-MJuTwEI599Y7q+0u0DMxRYaXsZfpksc2csgnK9Ghp/E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-pExpzQwuHREhgkj+eZ8drBVsh/B3WiQBBh906O6ymFw=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    pkg-config
    meson
    rustc
    cargo
    ninja
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    gtk-layer-shell
    libevdev
    libinput
    libpulseaudio
    udev
  ];

  patches = [
    ./swayosd_systemd_paths.patch
  ];

  postPatch = ''
    substituteInPlace data/udev/99-swayosd.rules \
      --replace /bin/chgrp ${coreutils}/bin/chgrp \
      --replace /bin/chmod ${coreutils}/bin/chmod
  '';

=======
    rev = "5c2176ae6a01a18fdc2b0f5d5f593737b5765914";
    hash = "sha256-rh42J6LWgNPOWYLaIwocU1JtQnA5P1jocN3ywVOfYoc=";
  };

  cargoHash = "sha256-ZcgrUcRQTcEYhw2mpJDuYDz3I/u/2Q+O60ajXYRMeow=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    libpulseaudio
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A GTK based on screen display for keyboard shortcuts";
    homepage = "https://github.com/ErikReider/SwayOSD";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
