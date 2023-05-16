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
<<<<<<< HEAD
  version = "1.22.0";
=======
  version = "1.21.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Rk6LOCZ5bhoo5ORAIIYWENrKUIVypd8bnKjyyBSbUYg=";
=======
    hash = "sha256-Mn0E+R/UzBLHPvarQHlEN4JBpf4VAaXdKdWLsFEyQE4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    cargoUpdateHook = ''
      cat Cargo.toml.in Cargo.deps.newer > Cargo.toml
      cp Cargo.lock.newer Cargo.lock
    '';
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-DygWra4R/w8KzkFzIVm4+ePpUpjiYGaDx2NQm6o+tWQ=";
=======
    hash = "sha256-F2mef0HvD9WZRx05DEpQ1AO1skMwcchHZzJa74AHmsM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
