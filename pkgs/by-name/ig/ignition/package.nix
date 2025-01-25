{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  blueprint-compiler,
  gjs,
  glib,
  gtk3,
  desktop-file-utils,
  ninja,
  libadwaita,
  pkg-config,
  cmake,
  appstream,
}:

stdenv.mkDerivation rec {
  pname = "ignition";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "flattool";
    repo = "ignition";
    tag = version;
    hash = "sha256-tkSMWXSqT+L8y3xUd16p34gF86PhJYg35/kgL2Ha4OI=";
  };

  nativeBuildInputs = [
    meson
    blueprint-compiler
    ninja
    pkg-config
    cmake
    appstream
  ];

  buildInputs = [
    glib
    gjs
    gtk3
    libadwaita
    desktop-file-utils
  ];

  dontUseCmakeConfigure = true;

  meta = {
    description = "Manage your startup apps and scripts on Freedesktop Linux distros";
    homepage = "https://github.com/flattool/ignition";
    mainProgram = "io.github.flattool.Ignition";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aucub ];
  };
}
