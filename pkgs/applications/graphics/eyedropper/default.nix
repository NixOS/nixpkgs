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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZlqRTTSQHmsOhQNg8W2hKL2/zCOu2ECEUrTQ507WN90=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-/CIheSIFrymYcCip3NmozAS8ojPnF0qO+oXI15zttkE=";
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
    description = "Pick and format colors";
    homepage = "https://github.com/FineFindus/eyedropper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
