{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cargo
, pkg-config
, meson
, ninja
, blueprint-compiler
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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PStQC9n+DTTOiNO9fHUjIkwgvKeA2alVbtX5qfqhTYo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-WRjoyIoVvOYcw2i/cMycE67iziZ8dvQrZ3EfE2v2jkQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
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
    mainProgram = "eyedropper";
    homepage = "https://github.com/FineFindus/eyedropper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
