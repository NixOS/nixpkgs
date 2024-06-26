{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bustle";
  version = "0.9.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "bustle";
    rev = finalAttrs.version;
    hash = "sha256-/B1rY8epcP0OFv+kVgv4Jx6x/oK3XpNnZcpSGvdIPx0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "bustle-${finalAttrs.version}";
    hash = "sha256-r29Z+6P+yuCpOBUE3vkESd15lcGXs5+ZTBiQ9nW6DJ4=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    desktop-file-utils
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Graphical D-Bus message analyser and profiler";
    homepage = "https://gitlab.gnome.org/World/bustle";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    mainProgram = "bustle";
    platforms = platforms.all;
  };
})
