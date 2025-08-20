{
  stdenv,
  lib,
  fetchurl,
  glycin-loaders,
  cargo,
  desktop-file-utils,
  jq,
  meson,
  moreutils,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  glib,
  gst_all_1,
  gtk4,
  libadwaita,
  libcamera,
  libseccomp,
  pipewire,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapshot";
  version = "48.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/snapshot/${lib.versions.major finalAttrs.version}/snapshot-${finalAttrs.version}.tar.xz";
    hash = "sha256-OTF2hZogt9I138MDAxuiDGhkQRBpiNyRHdkbe21m4f0=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    jq
    meson
    moreutils # sponge is used in postPatch
    ninja
    pkg-config
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    glycin-loaders
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-rs # for gtk4paintablesink
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libcamera # for the gstreamer plugin
    libseccomp
    pipewire # for device provider
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
    )
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "snapshot";
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/snapshot";
    description = "Take pictures and videos on your computer, tablet, or phone";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "snapshot";
  };
})
