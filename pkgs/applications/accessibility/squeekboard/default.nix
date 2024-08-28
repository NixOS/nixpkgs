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
  version = "1.41.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WHGdA0cEB1nu7vJ+pwjdl8aZzccJ232vsbSGmZohFVo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-CRKaH8cA/EhXQna3zCU0Z06zkB9qu6QxPJ4No3NFcs0=";
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
    description = "Virtual keyboard supporting Wayland";
    homepage = "https://gitlab.gnome.org/World/Phosh/squeekboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.linux;
  };
}
