{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, gtk-layer-shell
, libpulseaudio
}:

rustPlatform.buildRustPackage {
  pname = "swayosd";
  version = "unstable-2023-05-09";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "5c2176ae6a01a18fdc2b0f5d5f593737b5765914";
    hash = "sha256-rh42J6LWgNPOWYLaIwocU1JtQnA5P1jocN3ywVOfYoc=";
  };

  cargoHash = "sha256-ZcgrUcRQTcEYhw2mpJDuYDz3I/u/2Q+O60ajXYRMeow=";

  nativeBuildInputs = [
    wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    gtk-layer-shell
    libpulseaudio
  ];

  meta = with lib; {
    description = "A GTK based on screen display for keyboard shortcuts";
    homepage = "https://github.com/ErikReider/SwayOSD";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
