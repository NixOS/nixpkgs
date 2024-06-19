{ lib
, stdenv
, fetchFromGitLab
, cargo
, meson
, ninja
, pkg-config
, gnome
, gnome-desktop
, glib
, gtk3
, wayland
, wayland-protocols
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
  version = "1.38.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZVSnLH2wLPcOHkU2pO0BgIdGmULMNiacIYMRmhN+bZ8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-tcn1tRuRlHVTYvc8T/ePfCEPNjih6B9lo/hdX+WwitQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    wayland
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
    description = "A virtual keyboard supporting Wayland";
    homepage = "https://gitlab.gnome.org/World/Phosh/squeekboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.linux;
  };
}
