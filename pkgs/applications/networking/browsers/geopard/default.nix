{ stdenv
, glib
, gtk4
, libadwaita
, pango
, rustPlatform
, openssl
, pkg-config
, lib
, wrapGAppsHook4
, meson
, ninja
, desktop-file-utils
, blueprint-compiler
, appstream-glib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "geopard";
  version = "1.2.0";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "cairo-rs-0.16.0" = "sha256-Y0qRUliZRuEYvLje2ld75BDgSM7lHOnWITyuI/RoxwI=";
      "gdk4-0.5.0" = "sha256-cRZS8csxpPZm6yxyb6MYiGO7rdw207E4w4uiuJqJoaU=";
      "gio-0.16.0" = "sha256-wENBSDGVUQIa6CK4d5oZ9ih0h1SY1CKWBKVtVcxsXP0=";
      "libadwaita-0.2.0" = "sha256-+ATfy8QIgpoifSCrcqdoub1ust3pEdU3skjOPfIaDQc=";
    };
  };

  src = fetchFromGitHub {
    owner = "ranfdev";
    repo = "geopard";
    rev = "v${version}";
    sha256 = "sha256-XFuCWe7XugE07k0YnZBCaBfdohx2JTl5NFc6uI9gwcQ=";
  };

  nativeBuildInputs = [
    openssl
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    blueprint-compiler
    desktop-file-utils
    appstream-glib
    blueprint-compiler
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
  ];

  buildInputs = [
    meson
    ninja
    desktop-file-utils
    glib
    gtk4
    libadwaita
    openssl
  ];
  meta = with lib; {
    homepage = "https://github.com/ranfdev/Geopard";
    description = "Colorful, adaptive gemini browser";
    maintainers = with maintainers; [ ranfdev ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
