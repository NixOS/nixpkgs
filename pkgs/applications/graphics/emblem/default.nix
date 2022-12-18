{ lib
, stdenv
, fetchFromGitLab
, meson
, pkg-config
, ninja
, rustPlatform
, glib
, pango
, gdk-pixbuf
, graphene
, gtk4
, libadwaita
, libxml2
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "emblem";
  version = "1.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World/design";
    repo = pname;
    rev = version;
    sha256 = "sha256-kNPV1SHkNTBXbMzDJGuDbaGz1WkBqMpVgZKjsh7ejmo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-fjuSRdcSpbEMcjCHJ2Ucfrjz1pxkhYwhVHQpiZmxzxs=";
  };

  nativeBuildInputs = (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]) ++ [
    meson
    pkg-config
    desktop-file-utils
    ninja
    appstream-glib
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    pango
    gdk-pixbuf
    graphene
    gtk4
    libadwaita
    libxml2
  ];

  meta = with lib; {
    description = "Generate project avatars.";
    homepage = "https://gitlab.gnome.org/World/design/emblem";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
