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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sDrMIryVFkjMGHbYvNDmKb1HyJNGb3Hd+muxUJKhogE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-mztc44hHdqzR3WbG6tkCL38EfgBajRLlpMC8ElpXnlo=";
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
