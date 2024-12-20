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
  version = "47.1";

  src = fetchurl {
    url = "mirror://gnome/sources/snapshot/${lib.versions.major finalAttrs.version}/snapshot-${finalAttrs.version}.tar.xz";
    hash = "sha256-5LFiZ5ryTH6W7m4itH1f8NqW4KD2FtE66xIHxgn4lIM=";
  };

  patches = [
    # Fix paths in glycin library
    glycin-loaders.passthru.glycinPathsPatch
  ];

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

  postPatch = ''
    # Replace hash of file we patch in vendored glycin.
    jq \
      --arg hash "$(sha256sum vendor/glycin/src/sandbox.rs | cut -d' ' -f 1)" \
      '.files."src/sandbox.rs" = $hash' \
      vendor/glycin/.cargo-checksum.json \
      | sponge vendor/glycin/.cargo-checksum.json
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # vp8enc preset
      --prefix GST_PRESET_PATH : "${gst_all_1.gst-plugins-good}/share/gstreamer-1.0/presets"
      # See https://gitlab.gnome.org/sophie-h/glycin/-/blob/0.1.beta.2/glycin/src/config.rs#L44
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "snapshot";
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/snapshot";
    description = "Take pictures and videos on your computer, tablet, or phone";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    mainProgram = "snapshot";
  };
})
