{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  gtk4,
  gtk4-layer-shell,
  dbus,
  glib,
  wayland,
  openssl,
  sqlite,
  gdk-pixbuf,
  librsvg,
  nix-update-script,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sherlock-launcher";
  version = "0.1.14-2";

  src = fetchFromGitHub {
    owner = "Skxxtz";
    repo = "sherlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k5v1eeRxwCpU7+nBU6/q8I6O2e0kXojyhNTeZ3k/Qxo=";
  };

  nativeBuildInputs = [
    pkg-config
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
    dbus
    openssl
    sqlite
    glib
    wayland
    gdk-pixbuf
    librsvg
  ];

  cargoHash = "sha256-fct2xHZmrPMn/HXPtMaYraODT0Yi/wZEPw5X8KwhnGk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight and efficient application launcher for Wayland built with Rust and GTK4";
    homepage = "https://github.com/Skxxtz/sherlock";
    license = lib.licenses.cc-by-nc-40;
    mainProgram = "sherlock";
    maintainers = with lib.maintainers; [ agvantibo ];
  };
})
