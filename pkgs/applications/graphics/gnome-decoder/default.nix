{
  lib,
  clangStdenv,
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
  gstreamer,
  gst-plugins-base,
  gst-plugins-bad,
  gst-plugins-good,
  gst-plugins-rs,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  nix-update-script,
}:

clangStdenv.mkDerivation rec {
  pname = "gnome-decoder";
  version = "0.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    rev = version;
    hash = "sha256-lLZ8tll/R9cwk3t/MULmrR1KWZ1e+zneXL93035epPE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-USfC7HSL1TtjP1SmBRTKkPyKE4DkSn6xeH4mzfIBQWg=";
  };

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst-plugins-good}/share/gstreamer-1.0/presets"
    )
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    sqlite
    openssl
    pipewire
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-plugins-good
    gst-plugins-rs # for gtk4paintablesink
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Scan and Generate QR Codes";
    homepage = "https://gitlab.gnome.org/World/decoder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "decoder";
    maintainers = with maintainers; [ zendo ];
    teams = [ teams.gnome-circle ];
  };
}
