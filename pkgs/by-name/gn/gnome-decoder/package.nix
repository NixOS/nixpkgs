{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustc,
  glib,
  gtk4,
  libadwaita,
  sqlite,
  openssl,
  pipewire,
  gst_all_1,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-decoder";
  version = "0.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    tag = finalAttrs.version;
    hash = "sha256-lLZ8tll/R9cwk3t/MULmrR1KWZ1e+zneXL93035epPE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-USfC7HSL1TtjP1SmBRTKkPyKE4DkSn6xeH4mzfIBQWg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    gtk4
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    cargo
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    sqlite
    openssl
    pipewire
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs # for gtk4paintablesink
  ];

  # Adds vp8enc preset for camera enablement
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Scan and generate QR codes";
    homepage = "https://gitlab.gnome.org/World/decoder";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "decoder";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gnome-circle ];
  };
})
