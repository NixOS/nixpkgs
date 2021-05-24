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
}:

stdenv.mkDerivation rec {
  pname = "squeekboard";
  version = "1.13.0";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xyd6ickbaqvrr8a7ak6j1ziqjk05jlnganjrdv43p74nnjyqr8y";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    cargoUpdateHook = ''
      cat Cargo.toml.in Cargo.deps > Cargo.toml
    '';
    name = "${pname}-${version}";
    sha256 = "096skk7vmr93axcf0qj7kyr8hm1faj0nkmd349g8mnzwd68a9npz";
  };

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
