{ lib
, stdenv
, fetchFromGitLab
, appstream-glib
, cargo
, desktop-file-utils
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, gdk-pixbuf
, glib
, gst_all_1
, gtk4
, libadwaita
, openssl
, pipewire
, sqlite
, wayland
, zbar
}:

stdenv.mkDerivation rec {
  pname = "authenticator";
  version = "4.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Authenticator";
    rev = version;
    hash = "sha256-LNYhUDV5nM46qx29xXE6aCEdBo7VnwT61YgAW0ZXW30=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-ntkKH4P3Ui2NZSVy87hGAsRA1GDRwoK9UnA/nFjyLnA=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-bad.override { enableZbar = true; })
    gtk4
    libadwaita
    openssl
    pipewire
    sqlite
    wayland
    zbar
  ];

  meta = {
    description = "Two-factor authentication code generator for GNOME";
    homepage = "https://gitlab.gnome.org/World/Authenticator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ austinbutler ];
    platforms = lib.platforms.linux;
  };
}
