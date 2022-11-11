{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, meson
, ninja
, glib
, gtk4
, libadwaita
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "eyedropper";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = pname;
    rev = version;
    hash = "sha256-bOpwHaFOoUlh+yyC1go6BeFxfJhUmwZPi6kYAqCagEI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-TkdOq+icU2zNbXzN6nbkXjL1o/Lfumqr/5S0pQaxY5Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ] ++ (with rustPlatform; [
    rust.cargo
    rust.rustc
    cargoSetupHook
  ]);

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "An easy-to-use color picker and editor";
    homepage = "https://github.com/FineFindus/eyedropper";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
