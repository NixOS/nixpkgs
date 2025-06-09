{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  pkg-config,
  protobuf,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  dbus,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  blueprint-compiler,
  desktop-file-utils,
  appstream,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "packet";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nozwock";
    repo = "packet";
    tag = finalAttrs.version;
    hash = "sha256-MnDXwgzSnz8bLEAZE4PORKKIP8Ao5ZiImRqRzlQzYU8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-LlqJoxAWHAQ47VlYB/sOtk/UkNa+E5CQS/3FQnAYFsI=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    protobuf
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    glib
    gtk4
    appstream
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    libadwaita
    pango
  ];

  meta = {
    description = "Quick Share client for Linux";
    homepage = "https://github.com/nozwock/packet";
    changelog = "https://github.com/nozwock/packet/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ontake ];
    mainProgram = "packet";
    platforms = lib.platforms.linux;
  };
})
