{ lib
, stdenv
, fetchFromGitHub
, desktop-file-utils
, glib
, gtk4
, meson
, ninja
, pkg-config
, rustPlatform
, wrapGAppsHook4
, gtksourceview5
, libadwaita
, libpanel
, vte-gtk4
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "1.0.0-beta.9";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cW6n00EPe7eFuqT2Vk27Ax0fxjz9kWSlYuS2oIj0mXY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-y0njqlzAx1M7iC8bZrKlKACSiYnSRaHOrcAxs3bFF30=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libpanel
    vte-gtk4
  ];

  meta = with lib; {
    description = "A podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
