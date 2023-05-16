{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, pkg-config
, meson
, ninja
, glib
, gtk4
, libadwaita
, rustc
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "eyedropper";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ZlqRTTSQHmsOhQNg8W2hKL2/zCOu2ECEUrTQ507WN90=";
=======
    hash = "sha256-kc/UREQpmw3suA6bYEr9fCIwMzNMrEY9E5qf+rhKsC4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-/CIheSIFrymYcCip3NmozAS8ojPnF0qO+oXI15zttkE=";
=======
    hash = "sha256-/eas1PObrj9IuDIzlBVbfhEhH8eDyZ7CD871JmAqnyY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "Pick and format colors";
=======
    description = "A powerful color picker and formatter";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/FineFindus/eyedropper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
