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
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    tag = finalAttrs.version;
    hash = "sha256-O+DXfR9nZ0iz9IX/SZVX6ESI/vRa4ErEPxdgqSyOye0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-lYbJN5XliFATZVoZqiTDD3wzKPTfpFHk24iLh7ctjG4=";
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
