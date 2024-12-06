{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream-glib,
  cargo,
  dbus,
  desktop-file-utils,
  git,
  glib,
  gtk4,
  libadwaita,
  meson,
  ninja,
  openssl,
  pkg-config,
  rustPlatform,
  rustc,
  sqlite,
  transmission_4,
  wrapGAppsHook4,
}:

stdenv.mkDerivation rec {
  pname = "fragments";
  version = "3.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Fragments";
    rev = version;
    hash = "sha256-lTOO6ZQWImaFqYZ3qerYYHWj/eOLYU/2k2Wh/ju9Njw=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-7TIjd1ewazJGY8uG6f1B97ol+7+uLjnZVGC2/2DlUdQ=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    git
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    dbus
    glib
    gtk4
    libadwaita
    openssl
    sqlite
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ transmission_4 ]}"
    )
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Fragments";
    description = "Easy to use BitTorrent client for the GNOME desktop environment";
    maintainers = with maintainers; [ emilytrau ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "fragments";
  };
}
