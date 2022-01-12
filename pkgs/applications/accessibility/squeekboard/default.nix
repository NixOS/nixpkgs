{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gnome
, glib
, gtk3
, wayland
, wayland-protocols
, libxml2
, libxkbcommon
, rustPlatform
, feedbackd
, wrapGAppsHook
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "squeekboard";
  version = "1.14.0";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ayap40pgzcpmfydk5pbf3gwhh26m3cmbk6lyly4jihr9qw7dgb0";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    cargoUpdateHook = ''
      cat Cargo.toml.in Cargo.deps > Cargo.toml
    '';
    name = "${pname}-${version}";
    sha256 = "0148ynzmapxfrlccikf20ikmi0ssbkn9fl5wi6nh6azflv50pzzn";
  };

  patches = [
    # remove when updating from 1.14.0
    (fetchpatch {
      name = "fix-rust-1.54-build.patch";
      url = "https://gitlab.gnome.org/World/Phosh/squeekboard/-/commit/9cd56185c59ace535a6af26384ef6beca4423816.patch";
      sha256 = "sha256-8rWcfhQmGiwlc2lpkRvJ95XQp1Xg7St+0K85x8nQ0mk=";
    })
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
    gnome.gnome-desktop
    wayland
    wayland-protocols
    libxml2
    libxkbcommon
    feedbackd
  ];

  meta = with lib; {
    description = "A virtual keyboard supporting Wayland";
    homepage = "https://source.puri.sm/Librem5/squeekboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.linux;
  };
}
