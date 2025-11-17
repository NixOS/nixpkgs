{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream-glib,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  gdk-pixbuf,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  openssl,
  pipewire,
  sqlite,
  wayland,
  zbar,
  glycin-loaders,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "authenticator";
  version = "4.6.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Authenticator";
    tag = finalAttrs.version;
    hash = "sha256-UvHIVUed4rxmjliaZ7jnwCjiHyvUDihoJyG3G+fYtow=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-iOIGm3egVtVM6Eb3W5/ys9nQV5so0dnv2ZODjQwrVyw=";
  };

  strictDeps = true;

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

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
      # See https://gitlab.gnome.org/sophie-h/glycin/-/blob/0.1.beta.2/glycin/src/config.rs#L44
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Two-factor authentication code generator for GNOME";
    mainProgram = "authenticator";
    homepage = "https://gitlab.gnome.org/World/Authenticator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ austinbutler ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
