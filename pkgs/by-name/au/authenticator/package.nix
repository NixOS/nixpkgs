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
, glycin-loaders
}:

stdenv.mkDerivation rec {
  pname = "authenticator";
  version = "4.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Authenticator";
    rev = version;
    hash = "sha256-g4+ntBuAEH9sj61CiS5t95nMfCgaWJTgiwRXtwrUTs0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-XNAC1eA+11gAvMRu95huRM+YHdsrg5Sqpzb6F3Rgu5U=";
  };

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
      # See https://gitlab.gnome.org/sophie-h/glycin/-/blob/0.1.beta.2/glycin/src/config.rs#L44
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

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
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs
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
    mainProgram = "authenticator";
    homepage = "https://gitlab.gnome.org/World/Authenticator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ austinbutler ] ++ lib.teams.gnome-circle.members;
    platforms = lib.platforms.linux;
  };
}
