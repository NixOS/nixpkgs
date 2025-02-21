{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, cmake
, pkg-config
, libdbusmenu-gtk3
, gtk-layer-shell
, stb
, wayland-protocols
, wayland-scanner
, bluez
, gtk3
, libpulseaudio
, wayland
}:

stdenv.mkDerivation {
  pname = "gbar";
  version = "unstable-2023-09-21";

  src = fetchFromGitHub {
    owner = "scorpion-26";
    repo = "gBar";
    rev = "96485f408efe411f281fa27dceb6d86399ec7804";
    hash = "sha256-4zPvo0JBQOV1qn2X2iI8/JWYEQjFf9sDEICIWSCeaWk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
    bluez
    gtk3
    gtk-layer-shell
    libpulseaudio
    stb
    libdbusmenu-gtk3
  ];

  meta = with lib; {
    description = "Blazingly fast status bar written with GTK";
    homepage = "https://github.com/scorpion-26/gBar";
    license = licenses.mit;
    maintainers = with maintainers; [ ocfox ];
    mainProgram = "gBar";
    platforms = platforms.linux;
  };
}
