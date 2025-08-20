{ lib
, stdenv
, fetchFromGitLab
, cargo
, meson
, ninja
, pkg-config
, gnome-desktop
, glib
, gtk3
, wayland
, wayland-protocols
, wayland-scanner
, libbsd
, libxml2
, libxkbcommon
, rustPlatform
, rustc
, feedbackd
, wrapGAppsHook3
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "squeekboard";
  version = "1.43.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UsUr4UnYNo2ybEdNyOD/IiafEZ1YJFwRQ3CVy76X2H0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-1yBGn8cZxwpEOeF2BcUIIcI4Uxn80vRau/MvlufX9GU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    wayland-scanner
    wrapGAppsHook3
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk3
    gnome-desktop
    wayland
    wayland-protocols
    libbsd
    libxml2
    libxkbcommon
    feedbackd
  ];

  passthru.tests.phosh = nixosTests.phosh;

  meta = with lib; {
    description = "Virtual keyboard supporting Wayland";
    homepage = "https://gitlab.gnome.org/World/Phosh/squeekboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.linux;
  };
}
