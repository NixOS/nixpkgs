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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sherlock-launcher";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "Skxxtz";
    repo = "sherlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r3cXrcpczI5xJUhCxabYLv2YImvA+Ixi+oZJnLS0WoY=";
  };

  nativeBuildInputs = [
    pkg-config
    glib
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
    dbus
    openssl
    sqlite
    glib
    wayland
  ];

  cargoHash = "sha256-zgvTMjDycqrHpcXonAP6vZSIv4IQQslyl19xpb74mSg=";

  meta = {
    description = "Lightweight and efficient application launcher for Wayland built with Rust and GTK4";
    homepage = "https://github.com/Skxxtz/sherlock";
    license = lib.licenses.cc-by-nc-40;
    mainProgram = "sherlock";
    maintainers = with lib.maintainers; [ agvantibo ];
  };
})
