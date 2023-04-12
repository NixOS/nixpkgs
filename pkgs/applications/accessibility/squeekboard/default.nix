{ lib
, stdenv
, fetchFromGitLab
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
, feedbackd
, wrapGAppsHook
, fetchpatch
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "squeekboard";
  version = "1.21.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Mn0E+R/UzBLHPvarQHlEN4JBpf4VAaXdKdWLsFEyQE4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    cargoUpdateHook = ''
      cat Cargo.toml.in Cargo.deps.newer > Cargo.toml
      cp Cargo.lock.newer Cargo.lock
    '';
    name = "${pname}-${version}";
    hash = "sha256-F2mef0HvD9WZRx05DEpQ1AO1skMwcchHZzJa74AHmsM=";
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
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

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
