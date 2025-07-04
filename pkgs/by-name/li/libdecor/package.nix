{
  stdenv,
  lib,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  wayland,
  wayland-protocols,
  wayland-scanner,
  cairo,
  dbus,
  pango,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "libdecor";
  version = "0.2.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libdecor";
    repo = "libdecor";
    rev = version;
    hash = "sha256-7h/Xfw8chzRmmWKcOyIB7KSL+ZzNGDpElfE22ReoJqY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "demo" false)
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    cairo
    dbus
    pango
    gtk3
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/libdecor/libdecor";
    description = "Client-side decorations library for Wayland clients";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
