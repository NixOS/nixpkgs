{ appstream-glib
, cargo
, dbus
, desktop-file-utils
, fetchFromGitLab
, git
, glib
, gst_all_1
, gtk4
, lib
, libadwaita
, meson
, ninja
, nix-update-script
, pkg-config
, python3
, rustPlatform
, rustc
, stdenv
, wrapGAppsHook4
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "audio-sharing";
  version = "0.2.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "AudioSharing";
    rev = finalAttrs.version;
    hash = "sha256-ejNktgN9tfi4TzWDQJnESGcBkpvLVH34sukTFCBfo3U=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-c19DxHF4HFN0qTqC2CNzwko79uVeLeyrrXAvuyxeiOQ=";
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
  ] ++ (with rustPlatform; [
    cargoSetupHook
  ]);

  buildInputs = [
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good # pulsesrc
    gst_all_1.gst-rtsp-server
    gst_all_1.gstreamer
    gtk4
    libadwaita
    dbus
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/AudioSharing";
    description = "Automatically share the current audio playback in the form of an RTSP stream";
    mainProgram = "audio-sharing";
    maintainers = with maintainers; [ benediktbroich ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
})
