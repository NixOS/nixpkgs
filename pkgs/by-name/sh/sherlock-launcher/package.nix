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
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sherlock-launcher";
  version = "0.1.13-hotfix-1";

  src = fetchFromGitHub {
    owner = "Skxxtz";
    repo = "sherlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h8/72EipLTssik2I4GSfBRSc34ecAm0L39wA9hnGrR4=";
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
    gdk-pixbuf
    librsvg
  ];

  cargoHash = "sha256-F2jXCJnj2kGPANXSzx65DfKxKgXtwR0xRNFZie6PYx0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight and efficient application launcher for Wayland built with Rust and GTK4";
    homepage = "https://github.com/Skxxtz/sherlock";
    license = lib.licenses.cc-by-nc-40;
    mainProgram = "sherlock";
    maintainers = with lib.maintainers; [ agvantibo ];
  };
})
