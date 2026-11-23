{
  appstream-glib,
  cargo,
  dbus,
  desktop-file-utils,
  fetchFromGitLab,
  git,
  glib,
  gstreamer,
  gst-rtsp-server,
  gst-plugins-good,
  gst-plugins-base,
  gtk4,
  lib,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  rustPlatform,
  rustc,
  stdenv,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "audio-sharing";
  version = "0.2.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "AudioSharing";
    rev = finalAttrs.version;
    hash = "sha256-yUMiy5DaCPfCmBIGCXpqtvSSmQl5wo6vsLdW7Tt/Wfo=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-ePgEAVYXLOHWQXG92Grb9nmenyGj0JkgVy1UDsQF0xw=";
  };

  nativeBuildInputs = [
    appstream-glib
    cargo
    desktop-file-utils
    git
    meson
    ninja
    pkg-config
    python3
    rustc
    wrapGAppsHook4
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
  ]);

  buildInputs = [
    glib
    gst-plugins-base
    gst-plugins-good # pulsesrc
    gst-rtsp-server
    gstreamer
    gtk4
    libadwaita
    dbus
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/World/AudioSharing";
    description = "Automatically share the current audio playback in the form of an RTSP stream";
    mainProgram = "audio-sharing";
    maintainers = with lib.maintainers; [ benediktbroich ];
    teams = [ lib.teams.gnome-circle ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
