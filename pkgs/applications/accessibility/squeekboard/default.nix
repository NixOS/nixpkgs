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
, libxml2
, libxkbcommon
, rustPlatform
, feedbackd
, wrapGAppsHook
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "squeekboard";
  version = "1.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wx3fKRX/SPYGAFuR9u03JAvVRhtYIPUvW8mAsCdx83I=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    cargoUpdateHook = ''
      cat Cargo.toml.in Cargo.deps.newer > Cargo.toml
      cp Cargo.lock.newer Cargo.lock
    '';
    name = "${pname}-${version}";
    sha256 = "sha256-BbNkapqnqEW/NglrCse10Tm80SXYVQWWrOC5dTN6oi0=";
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
    libxml2
    libxkbcommon
    feedbackd
  ];

  meta = with lib; {
    description = "A virtual keyboard supporting Wayland";
    homepage = "https://source.puri.sm/Librem5/squeekboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artturin tomfitzhenry ];
    platforms = platforms.linux;
  };
}
