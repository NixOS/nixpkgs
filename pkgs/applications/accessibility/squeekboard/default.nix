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
, wrapGAppsHook
, fetchpatch
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "squeekboard";
  version = "1.22.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Rk6LOCZ5bhoo5ORAIIYWENrKUIVypd8bnKjyyBSbUYg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    cargoUpdateHook = ''
      cat Cargo.toml.in Cargo.deps.newer > Cargo.toml
      cp Cargo.lock.newer Cargo.lock
    '';
    name = "${pname}-${version}";
    hash = "sha256-DygWra4R/w8KzkFzIVm4+ePpUpjiYGaDx2NQm6o+tWQ=";
  };

  mesonFlags = [
    "-Dnewer=true"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    wayland
    wrapGAppsHook
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
    homepage = "https://source.puri.sm/Librem5/squeekboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artturin tomfitzhenry ];
    platforms = platforms.linux;
  };
}
